# Firebase Setup Commands - Copy & Paste

## Your Firebase Project Details (from JSON):
- **Project ID**: `instaclinics-beace`
- **Client Email**: `firebase-adminsdk-fbsvc@instaclinics-beace.iam.gserviceaccount.com`

---

## Step 1: Set Supabase Secrets

Open your terminal and run these commands **one by one**:

```bash
# Navigate to your project
cd /Users/mac/StudioProjects/instaclinics

# Set Firebase Project ID
supabase secrets set FIREBASE_PROJECT_ID="instaclinics-beace"

# Set Firebase Client Email
supabase secrets set FIREBASE_CLIENT_EMAIL="firebase-adminsdk-fbsvc@instaclinics-beace.iam.gserviceaccount.com"

# Set Firebase Private Key (IMPORTANT: Copy the entire private key including BEGIN/END)
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

**Important**: When setting the private key, make sure:
- Keep the quotes `"` around the entire key
- Include the `-----BEGIN PRIVATE KEY-----` and `-----END PRIVATE KEY-----` lines
- Keep the line breaks as they are

---

## Step 2: Verify Secrets Are Set

```bash
supabase secrets list
```

You should see:
- FIREBASE_PROJECT_ID
- FIREBASE_CLIENT_EMAIL
- FIREBASE_PRIVATE_KEY

---

## Step 3: Deploy Edge Function

```bash
supabase functions deploy sendNotification
```

---

## Step 4: Test the Function

Get your Supabase URL and anon key from: https://app.supabase.com/project/YOUR_PROJECT/settings/api

Then test with curl:

```bash
curl -i --location --request POST 'https://YOUR_PROJECT_REF.supabase.co/functions/v1/sendNotification' \
  --header 'Authorization: Bearer YOUR_ANON_KEY' \
  --header 'Content-Type: application/json' \
  --data '{
    "tokens": ["test_token_here"],
    "title": "Test Notification",
    "message": "This is a test from Supabase Edge Function"
  }'
```

---

## Troubleshooting

### If secrets command fails:
- Make sure you're logged in: `supabase login`
- Link your project: `supabase link --project-ref YOUR_PROJECT_REF`

### To update a secret:
Just run the `supabase secrets set` command again with the new value.

### To delete a secret:
```bash
supabase secrets unset SECRET_NAME
```

---

## Next Steps

After deploying, your dashboard will automatically work! The Flutter code is already configured to call the Edge Function.

🎉 Your setup will be complete!
