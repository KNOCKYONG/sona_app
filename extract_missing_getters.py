import re

error_text = """
lib/screens/splash_screen.dart:457:57: Error: The getter 'loginFailedTryAgain' isn't defined for the class 'AppLocalizations'.
lib/screens/splash_screen.dart:503:55: Error: The getter 'emotionBasedEncounters' isn't defined for the class 'AppLocalizations'.
lib/screens/login_screen.dart:81:55: Error: The getter 'checkInternetConnection' isn't defined for the class 'AppLocalizations'.
lib/screens/login_screen.dart:315:55: Error: The getter 'invalidEmailFormatError' isn't defined for the class 'AppLocalizations'.
lib/screens/login_screen.dart:573:54: Error: The getter 'invalidEmailFormat' isn't defined for the class 'AppLocalizations'.
lib/screens/login_screen.dart:601:54: Error: The getter 'enterPassword' isn't defined for the class 'AppLocalizations'.
lib/screens/login_screen.dart:784:51: Error: The getter 'loginWithGoogle' isn't defined for the class 'AppLocalizations'.
lib/screens/login_screen.dart:831:53: Error: The getter 'loginWithApple' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_screen.dart:369:56: Error: The getter 'loginRequiredService' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_screen.dart:519:46: Error: The getter 'dailyLimitTitle' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_screen.dart:520:52: Error: The getter 'dailyLimitDescription' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_screen.dart:531:58: Error: The getter 'messageLimitReset' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_screen.dart:658:54: Error: The getter 'weekdays' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_screen.dart:1289:21: Error: The getter 'inappropriateContent' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_screen.dart:1295:21: Error: The getter 'personalInfoExposure' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_screen.dart:1296:21: Error: The getter 'copyrightInfringement' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_screen.dart:1331:37: Error: The getter 'selectReportReason' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_screen.dart:1483:41: Error: The getter 'reportFailed' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_screen.dart:1659:50: Error: The getter 'problemMessage' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_screen.dart:1659:120: Error: The getter 'errorDescription' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_screen.dart:1923:57: Error: The getter 'noTranslatedMessages' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_screen.dart:1938:50: Error: The getter 'translationError' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_screen.dart:2115:47: Error: The getter 'guestLoginPromptMessage' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_screen.dart:2226:69: Error: The getter 'loginComplete' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_screen.dart:2579:53: Error: The getter 'selectPersona' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_screen.dart:2948:43: Error: The getter 'noConversationYet' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_screen.dart:2957:43: Error: The getter 'sendFirstMessage' isn't defined for the class 'AppLocalizations'.
lib/screens/privacy_policy_screen.dart:24:29: Error: The getter 'sonaPrivacyPolicy' isn't defined for the class 'AppLocalizations'.
lib/screens/privacy_policy_screen.dart:33:29: Error: The getter 'lastUpdated' isn't defined for the class 'AppLocalizations'.
lib/screens/privacy_policy_screen.dart:42:38: Error: The getter 'privacySection1Content' isn't defined for the class 'AppLocalizations'.
lib/screens/privacy_policy_screen.dart:45:36: Error: The getter 'privacySection2Title' isn't defined for the class 'AppLocalizations'.
lib/screens/privacy_policy_screen.dart:46:38: Error: The getter 'privacySection2Content' isn't defined for the class 'AppLocalizations'.
lib/screens/privacy_policy_screen.dart:50:38: Error: The getter 'privacySection3Content' isn't defined for the class 'AppLocalizations'.
lib/screens/privacy_policy_screen.dart:54:38: Error: The getter 'privacySection4Content' isn't defined for the class 'AppLocalizations'.
lib/screens/privacy_policy_screen.dart:58:38: Error: The getter 'privacySection5Content' isn't defined for the class 'AppLocalizations'.
lib/screens/privacy_policy_screen.dart:62:38: Error: The getter 'privacySection6Content' isn't defined for the class 'AppLocalizations'.
lib/screens/privacy_policy_screen.dart:65:36: Error: The getter 'privacySection7Title' isn't defined for the class 'AppLocalizations'.
lib/screens/privacy_policy_screen.dart:66:38: Error: The getter 'privacySection7Content' isn't defined for the class 'AppLocalizations'.
lib/screens/privacy_policy_screen.dart:69:36: Error: The getter 'privacySection8Title' isn't defined for the class 'AppLocalizations'.
lib/screens/privacy_policy_screen.dart:70:38: Error: The getter 'privacySection8Content' isn't defined for the class 'AppLocalizations'.
lib/screens/terms_of_service_screen.dart:23:29: Error: The getter 'sonaTermsOfService' isn't defined for the class 'AppLocalizations'.
lib/screens/terms_of_service_screen.dart:32:29: Error: The getter 'lastUpdated' isn't defined for the class 'AppLocalizations'.
lib/screens/terms_of_service_screen.dart:45:38: Error: The getter 'termsSection2Content' isn't defined for the class 'AppLocalizations'.
lib/screens/terms_of_service_screen.dart:49:38: Error: The getter 'termsSection3Content' isn't defined for the class 'AppLocalizations'.
lib/screens/terms_of_service_screen.dart:53:38: Error: The getter 'termsSection4Content' isn't defined for the class 'AppLocalizations'.
lib/screens/terms_of_service_screen.dart:57:38: Error: The getter 'termsSection5Content' isn't defined for the class 'AppLocalizations'.
lib/screens/terms_of_service_screen.dart:61:38: Error: The getter 'termsSection6Content' isn't defined for the class 'AppLocalizations'.
lib/screens/terms_of_service_screen.dart:69:38: Error: The getter 'termsSection8Content' isn't defined for the class 'AppLocalizations'.
lib/screens/terms_of_service_screen.dart:73:38: Error: The getter 'termsSection9Content' isn't defined for the class 'AppLocalizations'.
lib/screens/terms_of_service_screen.dart:77:38: Error: The getter 'termsSection10Content' isn't defined for the class 'AppLocalizations'.
lib/screens/terms_of_service_screen.dart:82:38: Error: The getter 'termsSection11Content' isn't defined for the class 'AppLocalizations'.
lib/screens/terms_of_service_screen.dart:86:38: Error: The getter 'termsSection12Content' isn't defined for the class 'AppLocalizations'.
lib/screens/terms_of_service_screen.dart:89:29: Error: The getter 'termsSupplementary' isn't defined for the class 'AppLocalizations'.
lib/screens/settings_screen.dart:114:39: Error: The getter 'locale' isn't defined for the class 'AppLocalizations'.
lib/screens/settings_screen.dart:128:46: Error: The getter 'notificationSettings' isn't defined for the class 'AppLocalizations'.
lib/screens/settings_screen.dart:132:39: Error: The getter 'newMessageNotification' isn't defined for the class 'AppLocalizations'.
lib/screens/settings_screen.dart:147:39: Error: The getter 'effectSoundDescription' isn't defined for the class 'AppLocalizations'.
lib/screens/settings_screen.dart:282:36: Error: The getter 'purchasePolicy' isn't defined for the class 'AppLocalizations'.
lib/screens/settings_screen.dart:314:47: Error: The getter 'deleteAccountWarning' isn't defined for the class 'AppLocalizations'.
lib/screens/settings_screen.dart:499:29: Error: The getter 'appTagline' isn't defined for the class 'AppLocalizations'.
lib/screens/purchase_screen.dart:59:47: Error: The getter 'storeNotAvailable' isn't defined for the class 'AppLocalizations'.
lib/screens/purchase_screen.dart:167:49: Error: The getter 'storeConnectionError' isn't defined for the class 'AppLocalizations'.
lib/screens/purchase_screen.dart:203:48: Error: The getter 'loadingProducts' isn't defined for the class 'AppLocalizations'.
lib/screens/purchase_screen.dart:243:35: Error: The getter 'heartDescription' isn't defined for the class 'AppLocalizations'.
lib/screens/purchase_screen.dart:391:55: Error: The getter 'purchasePending' isn't defined for the class 'AppLocalizations'.
lib/screens/purchase_screen.dart:432:55: Error: The getter 'purchaseFailed' isn't defined for the class 'AppLocalizations'.
lib/screens/purchase_policy_screen.dart:13:35: Error: The getter 'purchaseAndRefundPolicy' isn't defined for the class 'AppLocalizations'.
lib/screens/purchase_policy_screen.dart:24:29: Error: The getter 'sonaPurchasePolicy' isn't defined for the class 'AppLocalizations'.
lib/screens/purchase_policy_screen.dart:41:36: Error: The getter 'purchaseSection1Title' isn't defined for the class 'AppLocalizations'.
lib/screens/purchase_policy_screen.dart:42:38: Error: The getter 'purchaseSection1Content' isn't defined for the class 'AppLocalizations'.
lib/screens/purchase_policy_screen.dart:45:36: Error: The getter 'purchaseSection2Title' isn't defined for the class 'AppLocalizations'.
lib/screens/purchase_policy_screen.dart:46:38: Error: The getter 'purchaseSection2Content' isn't defined for the class 'AppLocalizations'.
lib/screens/purchase_policy_screen.dart:49:36: Error: The getter 'purchaseSection3Title' isn't defined for the class 'AppLocalizations'.
lib/screens/purchase_policy_screen.dart:50:38: Error: The getter 'purchaseSection3Content' isn't defined for the class 'AppLocalizations'.
lib/screens/purchase_policy_screen.dart:53:36: Error: The getter 'purchaseSection4Title' isn't defined for the class 'AppLocalizations'.
lib/screens/purchase_policy_screen.dart:54:38: Error: The getter 'purchaseSection4Content' isn't defined for the class 'AppLocalizations'.
lib/screens/purchase_policy_screen.dart:57:36: Error: The getter 'purchaseSection5Title' isn't defined for the class 'AppLocalizations'.
lib/screens/purchase_policy_screen.dart:58:38: Error: The getter 'purchaseSection5Content' isn't defined for the class 'AppLocalizations'.
lib/screens/purchase_policy_screen.dart:62:38: Error: The getter 'purchaseSection6Content' isn't defined for the class 'AppLocalizations'.
lib/screens/signup_screen.dart:135:52: Error: The getter 'requiredTermsAgreement' isn't defined for the class 'AppLocalizations'.
lib/screens/signup_screen.dart:333:56: Error: The getter 'enterNickname' isn't defined for the class 'AppLocalizations'.
lib/screens/signup_screen.dart:338:56: Error: The getter 'nicknameLengthError' isn't defined for the class 'AppLocalizations'.
lib/screens/signup_screen.dart:342:56: Error: The getter 'nicknameAlreadyUsed' isn't defined for the class 'AppLocalizations'.
lib/screens/signup_screen.dart:356:56: Error: The getter 'serviceTermsAgreement' isn't defined for the class 'AppLocalizations'.
lib/screens/signup_screen.dart:360:56: Error: The getter 'privacyPolicyAgreement' isn't defined for the class 'AppLocalizations'.
lib/screens/signup_screen.dart:624:40: Error: The getter 'nicknameLabel' isn't defined for the class 'AppLocalizations'.
lib/screens/signup_screen.dart:625:39: Error: The getter 'nicknamePlaceholder' isn't defined for the class 'AppLocalizations'.
lib/screens/signup_screen.dart:626:41: Error: The getter 'nicknameHelperText' isn't defined for the class 'AppLocalizations'.
lib/screens/signup_screen.dart:695:39: Error: The getter 'referrerEmail' isn't defined for the class 'AppLocalizations'.
lib/screens/signup_screen.dart:697:41: Error: The getter 'referrerEmailHelper' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_list_screen.dart:284:34: Error: The getter 'startConversation' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_list_screen.dart:454:60: Error: The getter 'refreshingChatList' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_list_screen.dart:485:64: Error: The getter 'refreshFailed' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_list_screen.dart:570:51: Error: The getter 'noMatchedPersonas' isn't defined for the class 'AppLocalizations'.
lib/screens/chat_list_screen.dart:579:51: Error: The getter 'meetNewPersonas' isn't defined for the class 'AppLocalizations'.
lib/screens/persona_selection_screen.dart:788:57: Error: The getter 'loginFailed' isn't defined for the class 'AppLocalizations'.
lib/screens/profile_screen.dart:81:56: Error: The getter 'profilePhotoUpdated' isn't defined for the class 'AppLocalizations'.
lib/screens/profile_screen.dart:91:51: Error: The getter 'profilePhotoUpdateFailed' isn't defined for the class 'AppLocalizations'.
lib/screens/profile_screen.dart:498:63: Error: The getter 'logoutConfirm' isn't defined for the class 'AppLocalizations'.
lib/screens/language_settings_screen.dart:272:55: Error: The getter 'currentLanguage' isn't defined for the class 'AppLocalizations'.
lib/screens/faq_screen.dart:594:51: Error: The getter 'sorryNotHelpful' isn't defined for the class 'AppLocalizations'.
lib/screens/profile_edit_screen.dart:129:55: Error: The getter 'profileUpdated' isn't defined for the class 'AppLocalizations'.
lib/screens/profile_edit_screen.dart:138:45: Error: The getter 'profileUpdateFailed' isn't defined for the class 'AppLocalizations'.
lib/screens/profile_edit_screen.dart:273:47: Error: The getter 'changeProfilePhoto' isn't defined for the class 'AppLocalizations'.
lib/screens/profile_edit_screen.dart:329:64: Error: The getter 'nicknameInUse' isn't defined for the class 'AppLocalizations'.
lib/screens/profile_edit_screen.dart:459:71: Error: The getter 'showAllGenderPersonas' isn't defined for the class 'AppLocalizations'.
lib/utils/account_deletion_dialog.dart:31:48: Error: The getter 'accountDeletionInfo' isn't defined for the class 'AppLocalizations'.
lib/utils/account_deletion_dialog.dart:33:48: Error: The getter 'accountDeletionWarning1' isn't defined for the class 'AppLocalizations'.
lib/utils/account_deletion_dialog.dart:34:48: Error: The getter 'accountDeletionWarning2' isn't defined for the class 'AppLocalizations'.
lib/utils/account_deletion_dialog.dart:35:48: Error: The getter 'accountDeletionWarning3' isn't defined for the class 'AppLocalizations'.
lib/utils/account_deletion_dialog.dart:36:48: Error: The getter 'accountDeletionWarning4' isn't defined for the class 'AppLocalizations'.
lib/utils/account_deletion_dialog.dart:64:53: Error: The getter 'passwordConfirmation' isn't defined for the class 'AppLocalizations'.
lib/utils/account_deletion_dialog.dart:113:54: Error: The getter 'deletingAccount' isn't defined for the class 'AppLocalizations'.
lib/utils/account_deletion_dialog.dart:175:57: Error: The getter 'accountDeletedSuccess' isn't defined for the class 'AppLocalizations'.
lib/utils/account_deletion_dialog.dart:187:56: Error: The getter 'incorrectPassword' isn't defined for the class 'AppLocalizations'.
lib/utils/account_deletion_dialog.dart:189:56: Error: The getter 'recentLoginRequired' isn't defined for the class 'AppLocalizations'.
lib/widgets/auth/terms_agreement_widget.dart:139:52: Error: The getter 'agreeToTerms' isn't defined for the class 'AppLocalizations'.
lib/utils/permission_helper.dart:170:45: Error: The getter 'notificationPermissionRequired' isn't defined for the class 'AppLocalizations'.
lib/widgets/persona/persona_card.dart:631:57: Error: The getter 'tapToSwipePhotos' isn't defined for the class 'AppLocalizations'.
"""

# Extract all getter names using regex
pattern = r"Error: The getter '(\w+)' isn't defined"
matches = re.findall(pattern, error_text)

# Remove duplicates and sort
unique_getters = sorted(set(matches))

print(f"Found {len(unique_getters)} unique missing getters:")
print("\n".join(unique_getters))

# Now check for any wrong signatures (monthDay, etc.)
wrong_signatures = """
lib/screens/chat_screen.dart:662:58: Error: The argument type 'int' can't be assigned to the parameter type 'String'.
      return AppLocalizations.of(context)!.monthDay(date.month, date.day);
lib/screens/purchase_screen.dart:407:36: Error: Too few positional arguments: 3 required, 2 given.
            .purchaseConfirmMessage(product.title, product.price)),
lib/screens/chat_list_screen.dart:328:55: Error: Too few positional arguments: 2 required, 1 given.
          return AppLocalizations.of(context)!.daysAgo(difference.inDays);
lib/screens/chat_list_screen.dart:330:56: Error: Too few positional arguments: 2 required, 1 given.
          return AppLocalizations.of(context)!.hoursAgo(difference.inHours);
lib/screens/chat_list_screen.dart:332:58: Error: Too few positional arguments: 2 required, 1 given.
          return AppLocalizations.of(context)!.minutesAgo(difference.inMinutes);
lib/screens/settings/blocked_personas_screen.dart:151:59: Error: Too few positional arguments: 2 required, 1 given.
              content: Text(localizations.errorWithMessage(e.toString())),
"""

print("\n\nMethods with wrong signatures to fix:")
print("- monthDay: expects String but gets int")
print("- purchaseConfirmMessage: expects 3 arguments but gets 2")
print("- daysAgo, hoursAgo, minutesAgo: expect 2 arguments but get 1")
print("- errorWithMessage: expects 2 arguments but gets 1")