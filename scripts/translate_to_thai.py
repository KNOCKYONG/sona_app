#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import sys

# 태국어 번역 매핑
translations = {
    # Basic UI
    "appName": "SONA",
    "loading": "กำลังโหลด...",
    "error": "ข้อผิดพลาด",
    "retry": "ลองใหม่",
    "cancel": "ยกเลิก",
    "confirm": "ยืนยัน",
    "next": "ถัดไป",
    "skip": "ข้าม",
    "done": "เสร็จสิ้น",
    "save": "บันทึก",
    "delete": "ลบ",
    "edit": "แก้ไข",
    "close": "ปิด",
    "search": "ค้นหา",
    "filter": "กรอง",
    "sort": "เรียงลำดับ",
    "refresh": "รีเฟรช",
    "yes": "ใช่",
    "no": "ไม่",
    "you": "คุณ",
    
    # Auth
    "login": "เข้าสู่ระบบ",
    "signup": "สมัครสมาชิก",
    "meetAIPersonas": "พบกับ AI คู่ใจ",
    "welcomeMessage": "ยินดีต้อนรับ💕",
    "aiDatingQuestion": "คุณจะคบกับ AI ไหม?",
    "loginSignup": "เข้าสู่ระบบ/สมัครสมาชิก",
    "or": "หรือ",
    "startWithEmail": "เริ่มต้นด้วยอีเมล",
    "startWithGoogle": "เริ่มต้นด้วย Google",
    "loginWithGoogle": "เข้าสู่ระบบด้วย Google",
    "loginWithApple": "เข้าสู่ระบบด้วย Apple",
    "loginError": "เข้าสู่ระบบล้มเหลว กรุณาลองใหม่",
    "googleLoginError": "เข้าสู่ระบบ Google ล้มเหลว",
    "appleLoginError": "เข้าสู่ระบบ Apple ล้มเหลว",
    "loginCancelled": "ยกเลิกการเข้าสู่ระบบ",
    "loginWithoutAccount": "ดำเนินการต่อโดยไม่มีบัญชี",
    "logout": "ออกจากระบบ",
    "logoutConfirm": "คุณแน่ใจหรือว่าต้องการออกจากระบบ?",
    
    # User Info
    "basicInfo": "ข้อมูลพื้นฐาน",
    "enterBasicInfo": "กรอกข้อมูลพื้นฐานของคุณ",
    "email": "อีเมล",
    "password": "รหัสผ่าน",
    "passwordHint": "กรอกรหัสผ่าน (6 ตัวอักษรขึ้นไป)",
    "passwordError": "รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร",
    "nickname": "ชื่อเล่น",
    "nicknameHint": "กรอกชื่อเล่นของคุณ",
    "nicknameError": "กรุณากรอกชื่อเล่น",
    "birthday": "วันเกิด",
    "age": "อายุ",
    "gender": "เพศ",
    "male": "ชาย",
    "female": "หญิง",
    "other": "อื่นๆ",
    "selectGender": "เลือกเพศ",
    "selectBirthday": "เลือกวันเกิด",
    "ageRestriction": "คุณต้องมีอายุ 18 ปีขึ้นไป",
    "mbtiType": "ประเภท MBTI",
    "selectMBTI": "เลือก MBTI",
    "idealType": "ประเภทในอุดมคติ",
    "idealPersona": "คู่ใจในอุดมคติ",
    "idealTypeHint": "อธิบายประเภทในอุดมคติของคุณ (ไม่บังคับ)",
    "mbtiDescription": "เลือกประเภทบุคลิกภาพของคุณ",
    
    # Navigation
    "home": "หน้าแรก",
    "chat": "แชท",
    "profile": "โปรไฟล์",
    "settings": "การตั้งค่า",
    "store": "ร้านค้า",
    
    # Profile
    "myProfile": "โปรไฟล์ของฉัน",
    "editProfile": "แก้ไขโปรไฟล์",
    "saveProfile": "บันทึกโปรไฟล์",
    "profileUpdated": "อัปเดตโปรไฟล์แล้ว",
    "profileUpdateError": "อัปเดตโปรไฟล์ล้มเหลว",
    "changePhoto": "เปลี่ยนรูปภาพ",
    "selectFromGallery": "เลือกจากแกลเลอรี",
    "takePhoto": "ถ่ายรูป",
    "removePhoto": "ลบรูปภาพ",
    
    # Settings
    "notification": "การแจ้งเตือน",
    "notificationSettings": "ตั้งค่าการแจ้งเตือน",
    "pushNotifications": "การแจ้งเตือนแบบพุช",
    "emailNotifications": "การแจ้งเตือนทางอีเมล",
    "soundSettings": "ตั้งค่าเสียง",
    "vibration": "การสั่น",
    "language": "ภาษา",
    "languageSettings": "ตั้งค่าภาษา",
    "theme": "ธีม",
    "darkMode": "โหมดมืด",
    "lightMode": "โหมดสว่าง",
    "systemDefault": "ตามระบบ",
    "privacy": "ความเป็นส่วนตัว",
    "privacyPolicy": "นโยบายความเป็นส่วนตัว",
    "termsOfService": "ข้อกำหนดการให้บริการ",
    "about": "เกี่ยวกับ",
    "version": "เวอร์ชัน",
    "checkUpdate": "ตรวจสอบการอัปเดต",
    "contactUs": "ติดต่อเรา",
    "feedback": "ข้อเสนอแนะ",
    "rateApp": "ให้คะแนนแอป",
    "share": "แชร์",
    "accountSettings": "ตั้งค่าบัญชี",
    "changePassword": "เปลี่ยนรหัสผ่าน",
    "deleteAccount": "ลบบัญชี",
    "deleteAccountConfirm": "คุณแน่ใจหรือว่าต้องการลบบัญชี? การกระทำนี้ไม่สามารถย้อนกลับได้",
    "blockedPersonas": "บุคคลที่ถูกบล็อก",
    "dataAndStorage": "ข้อมูลและพื้นที่จัดเก็บ",
    "clearCache": "ล้างแคช",
    "downloadData": "ดาวน์โหลดข้อมูล",
    
    # Chat
    "sendMessage": "ส่งข้อความ",
    "typeMessage": "พิมพ์ข้อความ...",
    "newChat": "แชทใหม่",
    "clearChat": "ล้างแชท",
    "chatCleared": "ล้างแชทแล้ว",
    "messageTooLong": "ข้อความยาวเกินไป",
    "sendingMessage": "กำลังส่ง...",
    "messageError": "ส่งข้อความล้มเหลว",
    "retrySend": "ส่งใหม่",
    "messageCopied": "คัดลอกข้อความแล้ว",
    "copyMessage": "คัดลอกข้อความ",
    "deleteMessage": "ลบข้อความ",
    "editMessage": "แก้ไขข้อความ",
    "reply": "ตอบกลับ",
    "forward": "ส่งต่อ",
    "selectPersona": "เลือกบุคคล",
    "chatWith": "แชทกับ {name}",
    "online": "ออนไลน์",
    "offline": "ออฟไลน์",
    "typing": "กำลังพิมพ์...",
    "lastSeen": "เห็นล่าสุด",
    "today": "วันนี้",
    "yesterday": "เมื่อวาน",
    "readReceipts": "แจ้งเตือนการอ่าน",
    "delivered": "ส่งแล้ว",
    "read": "อ่านแล้ว",
    "unread": "ยังไม่อ่าน",
    
    # Personas
    "persona": "บุคคล",
    "personas": "บุคคล",
    "allPersonas": "บุคคลทั้งหมด",
    "myPersonas": "บุคคลของฉัน",
    "popularPersonas": "บุคคลยอดนิยม",
    "newPersonas": "บุคคลใหม่",
    "recommendedPersonas": "บุคคลแนะนำ",
    "searchPersonas": "ค้นหาบุคคล",
    "personaDetails": "รายละเอียดบุคคล",
    "aboutPersona": "เกี่ยวกับบุคคล",
    "chatNow": "แชทเลย",
    "addToFavorites": "เพิ่มในรายการโปรด",
    "removeFromFavorites": "ลบจากรายการโปรด",
    "blockPersona": "บล็อกบุคคล",
    "unblockPersona": "ยกเลิกการบล็อก",
    "reportPersona": "รายงานบุคคล",
    "personaBlocked": "บล็อกบุคคลแล้ว",
    "personaUnblocked": "ยกเลิกการบล็อกแล้ว",
    "personaReported": "รายงานบุคคลแล้ว",
    
    # Store & Hearts
    "hearts": "หัวใจ",
    "buyHearts": "ซื้อหัวใจ",
    "heartBalance": "ยอดหัวใจ",
    "heartHistory": "ประวัติหัวใจ",
    "purchase": "ซื้อ",
    "purchaseSuccess": "ซื้อสำเร็จ",
    "purchaseError": "ซื้อล้มเหลว",
    "insufficientHearts": "หัวใจไม่เพียงพอ",
    "earnHearts": "รับหัวใจ",
    "dailyReward": "รางวัลประจำวัน",
    "watchAd": "ดูโฆษณา",
    "inviteFriends": "เชิญเพื่อน",
    "completeTasks": "ทำภารกิจให้สำเร็จ",
    
    # Matching
    "matching": "จับคู่",
    "findMatch": "ค้นหาคู่",
    "matchFound": "พบคู่แล้ว!",
    "noMatchFound": "ไม่พบคู่",
    "searchingMatch": "กำลังค้นหา...",
    "matchingPreferences": "การตั้งค่าการจับคู่",
    "ageRange": "ช่วงอายุ",
    "distance": "ระยะทาง",
    "interests": "ความสนใจ",
    "compatibility": "ความเข้ากันได้",
    
    # Errors
    "networkError": "ข้อผิดพลาดเครือข่าย",
    "serverError": "ข้อผิดพลาดเซิร์ฟเวอร์",
    "unknownError": "ข้อผิดพลาดที่ไม่รู้จัก",
    "tryAgainLater": "กรุณาลองใหม่ภายหลัง",
    "checkInternetConnection": "กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต",
    "sessionExpired": "เซสชันหมดอายุ",
    "pleaseLoginAgain": "กรุณาเข้าสู่ระบบอีกครั้ง",
    "permissionDenied": "ปฏิเสธการอนุญาต",
    "fileNotFound": "ไม่พบไฟล์",
    "invalidInput": "ข้อมูลไม่ถูกต้อง",
    "operationFailed": "การดำเนินการล้มเหลว",
    "timeout": "หมดเวลา",
    
    # Common Actions
    "ok": "ตกลง",
    "apply": "นำไปใช้",
    "submit": "ส่ง",
    "continue": "ดำเนินการต่อ",
    "back": "กลับ",
    "exit": "ออก",
    "more": "เพิ่มเติม",
    "less": "น้อยลง",
    "showMore": "แสดงเพิ่มเติม",
    "showLess": "แสดงน้อยลง",
    "viewAll": "ดูทั้งหมด",
    "collapse": "ย่อ",
    "expand": "ขยาย",
    "loading": "กำลังโหลด",
    "processing": "กำลังประมวลผล",
    "uploading": "กำลังอัปโหลด",
    "downloading": "กำลังดาวน์โหลด",
    "copied": "คัดลอกแล้ว",
    "shareApp": "แชร์แอป",
    "inviteCode": "รหัสเชิญ",
    "enterInviteCode": "กรอกรหัสเชิญ",
    
    # Time
    "justNow": "เมื่อกี้นี้",
    "minutesAgo": "{count} นาทีที่แล้ว",
    "hoursAgo": "{count} ชั่วโมงที่แล้ว",
    "daysAgo": "{count} วันที่แล้ว",
    "weeksAgo": "{count} สัปดาห์ที่แล้ว",
    "monthsAgo": "{count} เดือนที่แล้ว",
    "yearsAgo": "{count} ปีที่แล้ว",
    
    # Premium
    "premium": "พรีเมียม",
    "premiumFeatures": "ฟีเจอร์พรีเมียม",
    "upgradeToPremium": "อัปเกรดเป็นพรีเมียม",
    "premiumBenefits": "สิทธิประโยชน์พรีเมียม",
    "unlimitedMessages": "ข้อความไม่จำกัด",
    "priorityMatching": "การจับคู่แบบพิเศษ",
    "advancedFilters": "ตัวกรองขั้นสูง",
    "noAds": "ไม่มีโฆษณา",
    "exclusivePersonas": "บุคคลพิเศษ",
    
    # FAQ
    "faq": "คำถามที่พบบ่อย",
    "helpCenter": "ศูนย์ช่วยเหลือ",
    "customerSupport": "ฝ่ายสนับสนุนลูกค้า",
    "reportBug": "รายงานข้อผิดพลาด",
    "suggestFeature": "เสนอฟีเจอร์",
    
    # Onboarding
    "welcomeToApp": "ยินดีต้อนรับสู่ SONA",
    "getStarted": "เริ่มต้นใช้งาน",
    "createYourProfile": "สร้างโปรไฟล์ของคุณ",
    "findYourMatch": "ค้นหาคู่ของคุณ",
    "startChatting": "เริ่มแชท",
    "onboardingComplete": "ตั้งค่าเสร็จสิ้น",
    
    # Additional
    "changeLanguage": "เปลี่ยนภาษา",
    "selectLanguage": "เลือกภาษา",
    "koreanLanguage": "ภาษาเกาหลี",
    "englishLanguage": "ภาษาอังกฤษ",
    "japaneseLanguage": "ภาษาญี่ปุ่น",
    "chineseLanguage": "ภาษาจีน",
    "thaiLanguage": "ภาษาไทย",
    "useSystemLanguage": "ใช้ภาษาของระบบ",
    "followDeviceLanguage": "ตามการตั้งค่าภาษาของอุปกรณ์",
    "setAppInterfaceLanguage": "ตั้งค่าภาษาของแอป",
    
    # Terms and Privacy
    "agreeToTerms": "ยอมรับข้อกำหนด",
    "termsAndConditions": "ข้อกำหนดและเงื่อนไข",
    "privacyAndPolicy": "นโยบายความเป็นส่วนตัว",
    "acceptAll": "ยอมรับทั้งหมด",
    "decline": "ปฏิเสธ",
    "readMore": "อ่านเพิ่มเติม",
    
    # Matching Related
    "likePersona": "ถูกใจ",
    "passPersona": "ข้าม",
    "superLike": "ถูกใจมาก",
    "itsAMatch": "จับคู่สำเร็จ!",
    "keepSwiping": "ปัดต่อ",
    "sendFirstMessage": "ส่งข้อความแรก",
    "unmatch": "ยกเลิกการจับคู่",
    "unmatchConfirm": "คุณแน่ใจหรือว่าต้องการยกเลิกการจับคู่?",
    
    # Error Messages
    "errorOccurred": "เกิดข้อผิดพลาด",
    "somethingWentWrong": "มีบางอย่างผิดพลาด",
    "pleaseTryAgain": "กรุณาลองใหม่",
    "reportSent": "ส่งรายงานแล้ว",
    "thankYouForReport": "ขอบคุณสำหรับรายงาน",
}

# 매개변수 문자열
parameterized = {
    "chatWith": "แชทกับ {name}",
    "minutesAgo": "{count} นาทีที่แล้ว",
    "hoursAgo": "{count} ชั่วโมงที่แล้ว",
    "daysAgo": "{count} วันที่แล้ว",
    "weeksAgo": "{count} สัปดาห์ที่แล้ว",
    "monthsAgo": "{count} เดือนที่แล้ว",
    "yearsAgo": "{count} ปีที่แล้ว",
    "heartCount": "{count} หัวใจ",
    "messageCount": "{count} ข้อความ",
    "personaCount": "{count} บุคคล",
    "dayCount": "{count} วัน",
    "matchPercentage": "ตรงกัน {percent}%",
    "ageValue": "{age} ปี",
    "distanceKm": "{distance} กิโลเมตร",
    "onlineTime": "ออนไลน์ {time}",
    "offlineTime": "ออฟไลน์ {time}",
    "typingTo": "กำลังพิมพ์ถึง {name}...",
    "repliedTo": "ตอบกลับ {name}",
    "welcomeUser": "ยินดีต้อนรับ {name}!",
    "greetingWithName": "สวัสดี {name}",
    "profileOf": "โปรไฟล์ของ {name}",
    "reportUser": "รายงาน {name}",
    "blockUser": "บล็อก {name}",
    "unblockUser": "ยกเลิกการบล็อก {name}",
    "deleteChat": "ลบแชทกับ {name}",
    "clearChatHistory": "ล้างประวัติแชทกับ {name}",
    "restartConversationQuestion": "เริ่มการสนทนาใหม่กับ {name}?",
    "alreadyChattingWith": "กำลังแชทกับ {name} อยู่แล้ว",
    "unblockPersonaConfirm": "ยกเลิกการบล็อก {name}?",
    "errorWithMessage": "ข้อผิดพลาด: {error}",
    "monthDay": "{day} {month}",
}

def translate_arb_file():
    # Read the existing file
    with open('sona_app/lib/l10n/app_th.arb', 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Update locale
    data['@@locale'] = 'th'
    
    # Apply translations
    updated_count = 0
    for key, value in translations.items():
        if key in data:
            data[key] = value
            updated_count += 1
            print(f"Translated: {key}")
    
    # Apply parameterized translations
    param_count = 0
    for key, value in parameterized.items():
        if key in data:
            data[key] = value
            param_count += 1
            print(f"Translated (parameterized): {key}")
    
    # Write back
    with open('sona_app/lib/l10n/app_th.arb', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"\n✅ Translated {updated_count} simple strings")
    print(f"✅ Translated {param_count} parameterized strings")
    print(f"📁 File saved: sona_app/lib/l10n/app_th.arb")

if __name__ == "__main__":
    translate_arb_file()