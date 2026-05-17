#!/bin/bash

# Quick Deploy Script for Push Notifications
# Run this script to deploy everything in one go

echo "🚀 Starting Push Notifications Deployment..."
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo -e "${RED}❌ Supabase CLI not found!${NC}"
    echo "Install it with: brew install supabase/tap/supabase"
    exit 1
fi

echo -e "${GREEN}✅ Supabase CLI found${NC}"
echo ""

# Login to Supabase (if not already logged in)
echo -e "${BLUE}Step 1: Checking Supabase login...${NC}"
if ! supabase projects list &> /dev/null; then
    echo "Please login to Supabase:"
    supabase login
fi
echo -e "${GREEN}✅ Logged in${NC}"
echo ""

# Link project (if not already linked)
echo -e "${BLUE}Step 2: Linking project...${NC}"
echo "If not already linked, enter your project ref from Supabase dashboard:"
read -p "Project Ref (or press Enter if already linked): " PROJECT_REF

if [ ! -z "$PROJECT_REF" ]; then
    supabase link --project-ref "$PROJECT_REF"
fi
echo -e "${GREEN}✅ Project linked${NC}"
echo ""

# Set Firebase secrets
echo -e "${BLUE}Step 3: Setting Firebase secrets...${NC}"
echo "Setting FIREBASE_PROJECT_ID..."
supabase secrets set FIREBASE_PROJECT_ID="instaclinics-beace"

echo "Setting FIREBASE_CLIENT_EMAIL..."
supabase secrets set FIREBASE_CLIENT_EMAIL="firebase-adminsdk-fbsvc@instaclinics-beace.iam.gserviceaccount.com"

echo "Setting FIREBASE_PRIVATE_KEY..."
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

echo -e "${GREEN}✅ Secrets configured${NC}"
echo ""

# Verify secrets
echo -e "${BLUE}Step 4: Verifying secrets...${NC}"
supabase secrets list
echo ""

# Deploy Edge Function
echo -e "${BLUE}Step 5: Deploying Edge Function...${NC}"
supabase functions deploy sendNotification

echo ""
echo -e "${GREEN}✅ ✅ ✅ Deployment Complete! ✅ ✅ ✅${NC}"
echo ""
echo "🎉 Your push notification system is now live!"
echo ""
echo "Next steps:"
echo "1. Test from dashboard: Open your Flutter web dashboard → Notifications"
echo "2. View logs: https://app.supabase.com/project/YOUR_PROJECT/functions"
echo "3. Register devices from mobile app (see NOTIFICATION_DEPLOYMENT_CHECKLIST.md)"
echo ""
echo "For detailed instructions, see:"
echo "  - NOTIFICATION_DEPLOYMENT_CHECKLIST.md"
echo "  - FIREBASE_SETUP_COMMANDS.md"
