#!/usr/bin/env python3
"""Add missing localization keys to the English ARB file."""

import json
import os

# Missing keys to add with their English values
missing_keys = {
    "accountDeletedSuccess": "Account deleted successfully",
    "accountDeletionInfo": "Account deletion information",
    "accountDeletionWarning1": "Warning: This action cannot be undone",
    "accountDeletionWarning2": "All your data will be permanently deleted",
    "accountDeletionWarning3": "You will lose access to all conversations",
    "accountDeletionWarning4": "This includes all purchased content",
    "agreeToTerms": "I agree to the terms",
    "appTagline": "Your AI companions",
    "changeProfilePhoto": "Change Profile Photo",
    "checkInternetConnection": "Please check your internet connection",
    "copyrightInfringement": "Copyright infringement",
    "currentLanguage": "Current Language",
    "dailyLimitDescription": "You have reached your daily message limit",
    "dailyLimitTitle": "Daily Limit Reached",
    "deleteAccountWarning": "Are you sure you want to delete your account?",
    "deletingAccount": "Deleting account...",
    "effectSoundDescription": "Play sound effects",
    "emotionBasedEncounters": "Meet personas based on your emotions",
    "enterNickname": "Please enter a nickname",
    "enterPassword": "Please enter a password",
    "errorDescription": "Error description",
    "guestLoginPromptMessage": "Login to continue the conversation",
    "heartDescription": "Hearts for more messages",
    "inappropriateContent": "Inappropriate content",
    "incorrectPassword": "Incorrect password",
    "invalidEmailFormat": "Invalid email format",
    "invalidEmailFormatError": "Please enter a valid email address",
    "lastUpdated": "Last Updated",
    "loadingProducts": "Loading products...",
    "loginComplete": "Login complete",
    "loginFailed": "Login failed",
    "loginFailedTryAgain": "Login failed. Please try again.",
    "loginRequiredService": "Login required to use this service",
    "loginWithApple": "Login with Apple",
    "loginWithGoogle": "Login with Google",
    "logoutConfirm": "Are you sure you want to logout?",
    "meetNewPersonas": "Meet New Personas",
    "messageLimitReset": "Message limit will reset at midnight",
    "newMessageNotification": "Notify me of new messages",
    "nicknameAlreadyUsed": "This nickname is already in use",
    "nicknameHelperText": "3-10 characters",
    "nicknameInUse": "This nickname is already in use",
    "nicknameLabel": "Nickname",
    "nicknameLengthError": "Nickname must be 3-10 characters",
    "nicknamePlaceholder": "Enter your nickname",
    "noConversationYet": "No conversation yet",
    "noMatchedPersonas": "No matched personas yet",
    "noTranslatedMessages": "No messages to translate",
    "notificationPermissionRequired": "Notification permission required",
    "notificationSettings": "Notification Settings",
    "passwordConfirmation": "Enter password to confirm",
    "personalInfoExposure": "Personal information exposure",
    "privacyPolicyAgreement": "Please agree to the privacy policy",
    "privacySection1Content": "We are committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our service.",
    "privacySection2Content": "We collect information you provide directly to us, such as when you create an account, update your profile, or use our services.",
    "privacySection2Title": "Information We Collect",
    "privacySection3Content": "We use the information we collect to provide, maintain, and improve our services, and to communicate with you.",
    "privacySection4Content": "We do not sell, trade, or otherwise transfer your personal information to third parties without your consent.",
    "privacySection5Content": "We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.",
    "privacySection6Content": "We retain personal information for as long as necessary to provide our services and comply with legal obligations.",
    "privacySection7Content": "You have the right to access, update, or delete your personal information at any time through your account settings.",
    "privacySection7Title": "Your Rights",
    "privacySection8Content": "If you have any questions about this Privacy Policy, please contact us at support@sona.com.",
    "privacySection8Title": "Contact Us",
    "problemMessage": "Problem",
    "profilePhotoUpdateFailed": "Failed to update profile photo",
    "profilePhotoUpdated": "Profile photo updated",
    "profileUpdateFailed": "Failed to update profile",
    "profileUpdated": "Profile updated successfully",
    "purchaseAndRefundPolicy": "Purchase & Refund Policy",
    "purchaseFailed": "Purchase failed",
    "purchasePending": "Purchase pending...",
    "purchasePolicy": "Purchase Policy",
    "purchaseSection1Content": "We accept various payment methods including credit cards and digital wallets.",
    "purchaseSection1Title": "Payment Methods",
    "purchaseSection2Content": "Refunds are available within 14 days of purchase if you have not used the purchased items.",
    "purchaseSection2Title": "Refund Policy",
    "purchaseSection3Content": "You can cancel your subscription at any time through your account settings.",
    "purchaseSection3Title": "Cancellation",
    "purchaseSection4Content": "By making a purchase, you agree to our terms of use and service agreement.",
    "purchaseSection4Title": "Terms of Use",
    "purchaseSection5Content": "For purchase-related issues, please contact our support team.",
    "purchaseSection5Title": "Contact Support",
    "purchaseSection6Content": "All purchases are subject to our standard terms and conditions.",
    "recentLoginRequired": "Please login again for security",
    "referrerEmail": "Referrer Email",
    "referrerEmailHelper": "Optional: Email of who referred you",
    "refreshFailed": "Refresh failed",
    "refreshingChatList": "Refreshing chat list...",
    "reportFailed": "Report failed",
    "requiredTermsAgreement": "Please agree to the terms",
    "selectPersona": "Select a persona",
    "selectReportReason": "Select report reason",
    "sendFirstMessage": "Send your first message",
    "serviceTermsAgreement": "Please agree to the terms of service",
    "showAllGenderPersonas": "Show All Gender Personas",
    "sonaPrivacyPolicy": "SONA Privacy Policy",
    "sonaPurchasePolicy": "SONA Purchase Policy",
    "sonaTermsOfService": "SONA Terms of Service",
    "sorryNotHelpful": "Sorry this wasn't helpful",
    "startConversation": "Start a conversation",
    "storeConnectionError": "Could not connect to store",
    "storeNotAvailable": "Store is not available",
    "tapToSwipePhotos": "Tap to swipe photos",
    "termsSection10Content": "We reserve the right to modify these terms at any time with notice to users.",
    "termsSection11Content": "These terms shall be governed by the laws of the jurisdiction in which we operate.",
    "termsSection12Content": "If any provision of these terms is found to be unenforceable, the remaining provisions shall continue in full force and effect.",
    "termsSection2Content": "By using our service, you agree to be bound by these Terms of Service and our Privacy Policy.",
    "termsSection3Content": "You must be at least 13 years old to use our service.",
    "termsSection4Content": "You are responsible for maintaining the confidentiality of your account and password.",
    "termsSection5Content": "You agree not to use our service for any illegal or unauthorized purpose.",
    "termsSection6Content": "We reserve the right to terminate or suspend your account for violation of these terms.",
    "termsSection8Content": "We are not liable for any indirect, incidental, or consequential damages arising from your use of our service.",
    "termsSection9Content": "All content and materials available on our service are protected by intellectual property rights.",
    "termsSupplementary": "Supplementary Terms",
    "translationError": "Translation error",
    "weekdays": ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
}

def add_missing_keys():
    """Add missing keys to the English ARB file."""
    arb_path = "sona_app/lib/l10n/app_en.arb"
    
    # Read existing ARB file
    with open(arb_path, 'r', encoding='utf-8') as f:
        arb_data = json.load(f)
    
    # Add missing keys
    added_keys = []
    for key, value in missing_keys.items():
        if key not in arb_data:
            arb_data[key] = value
            # Add metadata for the key
            arb_data[f"@{key}"] = {
                "description": f"Localized string for {key}"
            }
            added_keys.append(key)
    
    # Write back to file
    with open(arb_path, 'w', encoding='utf-8') as f:
        json.dump(arb_data, f, indent=2, ensure_ascii=False)
    
    print(f"Added {len(added_keys)} missing keys to {arb_path}")
    if added_keys:
        print("Added keys:", ', '.join(added_keys[:10]))
        if len(added_keys) > 10:
            print(f"... and {len(added_keys) - 10} more")

if __name__ == "__main__":
    add_missing_keys()