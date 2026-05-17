/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest, onCall} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");

// Initialize Firebase Admin SDK
admin.initializeApp();

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

/**
 * Send push notifications to multiple FCM tokens
 * This function can be called from Supabase Edge Functions or directly from your app
 */
exports.sendNotification = onCall(async (request) => {
  try {
    const {tokens, title, message, data} = request.data;

    // Validate input
    if (!tokens || !Array.isArray(tokens) || tokens.length === 0) {
      throw new Error("Invalid or empty tokens array");
    }
    if (!title || !message) {
      throw new Error("Title and message are required");
    }

    logger.info("Sending notifications", {
      tokenCount: tokens.length,
      title,
      message,
    });

    // Prepare notification payload
    const payload = {
      notification: {
        title: title,
        body: message,
      },
      data: data || {},
    };

    // Send to multiple tokens
    const promises = tokens.map((token) => {
      return admin.messaging().send({
        token: token,
        ...payload,
      }).catch((error) => {
        logger.error(`Failed to send to token ${token}:`, error);
        return {error: error.message, token};
      });
    });

    const results = await Promise.all(promises);

    // Count successes and failures
    const successes = results.filter((r) => !r.error).length;
    const failures = results.filter((r) => r.error).length;

    logger.info("Notification results", {successes, failures});

    return {
      success: true,
      totalSent: successes,
      totalFailed: failures,
      results: results,
    };
  } catch (error) {
    logger.error("Error sending notifications:", error);
    throw new Error(`Failed to send notifications: ${error.message}`);
  }
});

/**
 * HTTP endpoint version for Supabase Edge Functions
 */
exports.sendNotificationHttp = onRequest(async (request, response) => {
  // Set CORS headers
  response.set("Access-Control-Allow-Origin", "*");
  response.set("Access-Control-Allow-Methods", "POST, OPTIONS");
  response.set("Access-Control-Allow-Headers", "Content-Type, Authorization");

  // Handle preflight OPTIONS request
  if (request.method === "OPTIONS") {
    response.status(204).send("");
    return;
  }

  if (request.method !== "POST") {
    response.status(405).send("Method Not Allowed");
    return;
  }

  try {
    const {tokens, title, message, data} = request.body;

    // Validate input
    if (!tokens || !Array.isArray(tokens) || tokens.length === 0) {
      response.status(400).json({
        success: false,
        error: "Invalid or empty tokens array",
      });
      return;
    }
    if (!title || !message) {
      response.status(400).json({
        success: false,
        error: "Title and message are required",
      });
      return;
    }

    logger.info("Sending notifications (HTTP)", {
      tokenCount: tokens.length,
      title,
      message,
    });

    // Prepare notification payload
    const payload = {
      notification: {
        title: title,
        body: message,
      },
      data: data || {},
    };

    // Send to multiple tokens
    const promises = tokens.map((token) => {
      return admin.messaging().send({
        token: token,
        ...payload,
      }).catch((error) => {
        logger.error(`Failed to send to token ${token}:`, error);
        return {error: error.message, token};
      });
    });

    const results = await Promise.all(promises);

    // Count successes and failures
    const successes = results.filter((r) => !r.error).length;
    const failures = results.filter((r) => r.error).length;

    logger.info("Notification results (HTTP)", {successes, failures});

    response.status(200).json({
      success: true,
      totalSent: successes,
      totalFailed: failures,
      results: results,
    });
  } catch (error) {
    logger.error("Error sending notifications (HTTP):", error);
    response.status(500).json({
      success: false,
      error: `Failed to send notifications: ${error.message}`,
    });
  }
});
