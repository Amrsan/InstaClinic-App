// Supabase Edge Function to send FCM notifications
// This function uses Firebase Admin SDK credentials to send push notifications
// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts";

// Get Firebase credentials from environment variables (set via supabase secrets)
const FIREBASE_PROJECT_ID = Deno.env.get("FIREBASE_PROJECT_ID")!;
const FIREBASE_CLIENT_EMAIL = Deno.env.get("FIREBASE_CLIENT_EMAIL")!;
const FIREBASE_PRIVATE_KEY = Deno.env.get("FIREBASE_PRIVATE_KEY")!.replace(/\\n/g, "\n");

/**
 * Generate OAuth2 access token for Firebase Admin SDK
 * Uses service account credentials to authenticate with Firebase
 */
async function getFirebaseAccessToken(): Promise<string> {
  try {
    // JWT Header
    const header = {
      alg: "RS256",
      typ: "JWT",
    };

    // JWT Claims
    const now = Math.floor(Date.now() / 1000);
    const claims = {
      iss: FIREBASE_CLIENT_EMAIL,
      scope: "https://www.googleapis.com/auth/firebase.messaging",
      aud: "https://oauth2.googleapis.com/token",
      exp: now + 3600, // Token expires in 1 hour
      iat: now,
    };

    // Encode header and claims
    const encodedHeader = btoa(JSON.stringify(header));
    const encodedClaims = btoa(JSON.stringify(claims));
    const unsignedToken = `${encodedHeader}.${encodedClaims}`;

    // Import private key for signing
    const pemHeader = "-----BEGIN PRIVATE KEY-----";
    const pemFooter = "-----END PRIVATE KEY-----";
    const pemContents = FIREBASE_PRIVATE_KEY
      .replace(pemHeader, "")
      .replace(pemFooter, "")
      .replace(/\s/g, "");

    // Decode base64 private key
    const binaryKey = Uint8Array.from(atob(pemContents), (c) => c.charCodeAt(0));

    // Import the key
    const cryptoKey = await crypto.subtle.importKey(
      "pkcs8",
      binaryKey,
      {
        name: "RSASSA-PKCS1-v1_5",
        hash: "SHA-256",
      },
      false,
      ["sign"]
    );

    // Sign the JWT
    const signature = await crypto.subtle.sign(
      "RSASSA-PKCS1-v1_5",
      cryptoKey,
      new TextEncoder().encode(unsignedToken)
    );

    // Encode signature
    const encodedSignature = btoa(String.fromCharCode(...new Uint8Array(signature)))
      .replace(/\+/g, "-")
      .replace(/\//g, "_")
      .replace(/=/g, "");

    // Complete JWT
    const jwt = `${unsignedToken}.${encodedSignature}`;

    // Exchange JWT for access token
    const tokenResponse = await fetch("https://oauth2.googleapis.com/token", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${jwt}`,
    });

    if (!tokenResponse.ok) {
      const error = await tokenResponse.text();
      throw new Error(`Failed to get access token: ${error}`);
    }

    const tokenData = await tokenResponse.json();
    return tokenData.access_token;
  } catch (error) {
    console.error("Error getting Firebase access token:", error);
    throw error;
  }
}

/**
 * Send push notification via FCM
 */
async function sendFCMNotification(
  accessToken: string,
  fcmToken: string,
  title: string,
  body: string,
  data?: Record<string, string>
) {
  const fcmEndpoint = `https://fcm.googleapis.com/v1/projects/${FIREBASE_PROJECT_ID}/messages:send`;

  const message = {
    message: {
      token: fcmToken,
      notification: {
        title,
        body,
      },
      data: data || {},
      android: {
        priority: "high",
        notification: {
          sound: "default",
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
            badge: 1,
          },
        },
      },
    },
  };

  const response = await fetch(fcmEndpoint, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${accessToken}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(message),
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`FCM Error: ${error}`);
  }

  return await response.json();
}

/**
 * Main handler for the Edge Function
 */
Deno.serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === "OPTIONS") {
    return new Response(null, {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
      },
    });
  }

  try {
    // Parse request body
    const { tokens, title, message, data } = await req.json();

    // Validate input
    if (!tokens || !Array.isArray(tokens) || tokens.length === 0) {
      return new Response(
        JSON.stringify({ 
          success: false, 
          error: "Invalid or empty tokens array" 
        }),
        { 
          status: 400,
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
          },
        }
      );
    }

    if (!title || !message) {
      return new Response(
        JSON.stringify({ 
          success: false, 
          error: "Title and message are required" 
        }),
        { 
          status: 400,
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
          },
        }
      );
    }

    console.log(`Sending notification to ${tokens.length} device(s)`);
    console.log(`Title: ${title}`);
    console.log(`Message: ${message}`);

    // Get Firebase access token
    const accessToken = await getFirebaseAccessToken();

    // Send notifications to all tokens
    const results = await Promise.allSettled(
      tokens.map((token) => 
        sendFCMNotification(accessToken, token, title, message, data)
      )
    );

    // Count successes and failures
    const successful = results.filter((r) => r.status === "fulfilled").length;
    const failed = results.filter((r) => r.status === "rejected").length;

    // Collect error details
    const errors = results
      .filter((r) => r.status === "rejected")
      .map((r: any) => r.reason.message);

    console.log(`Notification results: ${successful} successful, ${failed} failed`);

    return new Response(
      JSON.stringify({
        success: true,
        totalSent: successful,
        totalFailed: failed,
        errors: errors.length > 0 ? errors : undefined,
      }),
      {
        status: 200,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
      }
    );
  } catch (error) {
    console.error("Error in sendNotification function:", error);
    return new Response(
      JSON.stringify({ 
        success: false, 
        error: error.message 
      }),
      {
        status: 500,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
      }
    );
  }
});

/* 
 * Local Testing:
 * 
 * 1. Start Supabase locally:
 *    supabase start
 * 
 * 2. Set environment variables:
 *    supabase secrets set FIREBASE_PROJECT_ID="instaclinics-beace"
 *    supabase secrets set FIREBASE_CLIENT_EMAIL="firebase-adminsdk-fbsvc@instaclinics-beace.iam.gserviceaccount.com"
 *    supabase secrets set FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
 * 
 * 3. Test with curl:
 *    curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/sendNotification' \
 *      --header 'Authorization: Bearer YOUR_ANON_KEY' \
 *      --header 'Content-Type: application/json' \
 *      --data '{
 *        "tokens": ["test_fcm_token"],
 *        "title": "Test Notification",
 *        "message": "This is a test message"
 *      }'
 * 
 * 4. Deploy to production:
 *    supabase functions deploy sendNotification
 */
