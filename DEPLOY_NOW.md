# 🚀 Deploy Push Notifications - Run These Commands

**Open your Terminal app and follow these steps exactly:**

---

## Step 1: Login to Supabase

```bash
supabase login
```

This will:
- Open your browser
- Ask you to authorize the CLI
- Automatically save your credentials

**✅ When successful, you'll see**: "Finished supabase login"

---

## Step 2: Navigate to Your Project

```bash
cd /Users/mac/StudioProjects/instaclinics
```

---

## Step 3: Link Your Project

**First, get your Project Reference ID:**
1. Open: https://app.supabase.com
2. Select your "instaclinics" project
3. Look at the URL: `https://app.supabase.com/project/YOUR_PROJECT_REF`
4. Copy the `YOUR_PROJECT_REF` part (it looks like: `djfbbxcvkwxwpkqqyjkr`)

**Then run** (replace YOUR_PROJECT_REF with your actual ID):

```bash
supabase link --project-ref YOUR_PROJECT_REF
```

**✅ When successful, you'll see**: "Finished supabase link"

---

## Step 4: Set Firebase Secrets

**Copy and paste each command one by one:**

### Secret 1: Project ID
```bash
supabase secrets set FIREBASE_PROJECT_ID="instaclinics-beace"
```

### Secret 2: Client Email
```bash
supabase secrets set FIREBASE_CLIENT_EMAIL="firebase-adminsdk-fbsvc@instaclinics-beace.iam.gserviceaccount.com"
```

### Secret 3: Private Key
**Important**: Copy this entire command including all the line breaks!

```bash
supabase secrets set FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDeJ4TSDTq4gOj2
X2QdUZ+mDsqyeQ5fInn515KTltTxnIpNasega7p648wNfPm/p16LEgobyp+2UeBo
SAt/e3bUNoehTHFOppFrTin38mrwI5wiaxFPMnUqaip4h9q+qH3ZFqSv8YX0KAGJ
1auAEdHU4AFzwN9Cbrn4jBhqI4msJm4/F6d90w72/YCgBiAWFr1IwYgIfEbYKbcW
RVcXf8T/WdZhQdb5oWlD9zjCXRy904olGqdppraxR7DAndxh+mP58ydjdqzeCndX
ia3HEundTDtWEeajKDmSi3vyemTIlUzpUuNk69KIQpYkx8lFowWRjzPa61w71cRv
9HYdaMHTAgMBAAECggEAPYoP+ooMorCfGCSrnI2QXpVJZDAxoXvw8xta8MR/H6EA
FNsICrHc+g7hZzkgDA3GnFq2byVtoblDo0+V0841SCsE3lNJLgLpVKLV8Gf4ZKZQ
qZ4kMN6m40V+l1325ArTtc/WdiC/PTfZ2T9V30fQaxpUfKbIkeQPY0EXwEsw531H
tS5JbxsROGsV/2KLjpjsykY+5h4yAAmsjs4rKmwnTDMARyNsVms+UIT2lLiMqmmB
QB6/kpdqhnhVIAReEJqq929njyvwk6bAvOR23KAPMJpw5seo0k5v3dCj+B/B0VVE
+pm5wmdRNF8gvFdtfok5KHT41rsPrmHlvbpdFcIfEQKBgQDzY7LV8mQQhebRICeJ
qIc6koJP01TYWG5DgEsNStlBItGUUnquFooIBxFTTTXGH44JmRRa2UlWapoAcY1l
y19lQNVDp1049XGdA6+QbArkGudSoytEqIN5Wq1QOdPltXtFqVZP6S+nywi53Vu3
eheF/Er/GJv1MnvN8WsJl5xj0QKBgQDpqijb0aLlUhjQ5ggv2pr2XCdqEHYfJCgb
WuIrKc4xVhn3RvRKeKW6X/TrcrK+iZjEcUK0skc8TjmAKZcrtFA489fMukQrNzau
k5nCpDJLHR6O3wP/PN27Nz9PUrPhFWm86Qr5s3Y7B8nVAqCQQUs3IrwY5jaUHmrg
IMbLf92oYwKBgAITdKAMjDvz2G8qNgwfit++BiyGIfAiePZMbtdzLv02PdFlDrTT
bmP5I3Wxb+b7t+tvCdRojA6XpC6iyVD39h1X+zmzgMEOnuR29pVlxoYBkL2MtL7G
LTDozBemFp+b96w1cI4H8CcfPTjQoYqkGPVEnKMmY5Yo0xODnqUbTPMxAoGBANEY
ehOrVw/LFXXqQy0/fCg1cvfQ30MiwdkozPc/I8q2d+n1zqnNqNBNCgifzSAAVXqE
t+KnHmPyxDXSAfsUEi3E1znW/SWG9SHn51JsSK0605uaKiN/PhRIbhj3swwac1Kf
YDjuxUAxygUZosE0DLC8HoJRkEmfppgF/J8iPyJtAoGAKuTT0vu0dD5Nlevsfdms
jbJI5B3b5edaVQWJ8oEoaOQJpJOtNe5WfGXdexuGB/I3QuQKUPHVjw7Icsi0+vTo
5eL81sPknLNeDqN+Z5KgQQQlKrhvyT3sAZx+nLvHvfbyLauUATzboEhex1cqZS1P
GD1KQUD7raS9TyuKI0CNWuc=
-----END PRIVATE KEY-----"
```

**✅ After each secret**: You'll see "Finished supabase secrets set"

---

## Step 5: Verify Secrets Are Set

```bash
supabase secrets list
```

**✅ You should see**:
```
FIREBASE_PROJECT_ID
FIREBASE_CLIENT_EMAIL
FIREBASE_PRIVATE_KEY
```

---

## Step 6: Deploy Edge Function 🚀

```bash
supabase functions deploy sendNotification
```

**✅ When successful, you'll see**:
```
Deploying Function sendNotification...
Function URL: https://xxxxx.supabase.co/functions/v1/sendNotification
Deployed!
```

**Copy this URL!** You'll use it to verify deployment.

---

## Step 7: Test the Deployment (Optional)

Get your Supabase anon key from:
https://app.supabase.com/project/YOUR_PROJECT_REF/settings/api

Then test:

```bash
curl -i --location --request POST \
  'https://YOUR_PROJECT_REF.supabase.co/functions/v1/sendNotification' \
  --header 'Authorization: Bearer YOUR_ANON_KEY' \
  --header 'Content-Type: application/json' \
  --data '{
    "tokens": ["test_token"],
    "title": "Test",
    "message": "Hello!"
  }'
```

---

## 🎉 Done!

Once you see "Deployed!" you can:
1. Open your Flutter web dashboard
2. Go to "Notifications" page
3. Send notifications to users!

---

## 🆘 If You Get Errors:

### "command not found: supabase"
```bash
brew install supabase/tap/supabase
```

### "Access token not provided"
Run `supabase login` again

### "Project not found"
Check your project ref is correct

### "Invalid private key"
Make sure you copied the entire private key including BEGIN/END lines

---

## 📝 Summary of Commands

```bash
# All commands in order:
supabase login
cd /Users/mac/StudioProjects/instaclinics
supabase link --project-ref YOUR_PROJECT_REF
supabase secrets set FIREBASE_PROJECT_ID="instaclinics-beace"
supabase secrets set FIREBASE_CLIENT_EMAIL="firebase-adminsdk-fbsvc@instaclinics-beace.iam.gserviceaccount.com"
supabase secrets set FIREBASE_PRIVATE_KEY="[PASTE THE ENTIRE KEY]"
supabase secrets list
supabase functions deploy sendNotification
```

**That's it!** 🚀
