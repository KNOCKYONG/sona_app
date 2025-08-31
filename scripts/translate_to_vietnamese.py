#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Vietnamese (vi-VN) Translation Script for SONA App
Translates Korean ARB file to Vietnamese
"""

import json
import os
from pathlib import Path

def translate_to_vietnamese():
    """Translate Korean ARB to Vietnamese"""
    
    # Paths
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    l10n_dir = project_root / "sona_app" / "lib" / "l10n"
    
    ko_arb_path = l10n_dir / "app_ko.arb"
    vi_arb_path = l10n_dir / "app_vi.arb"
    
    # Read Korean ARB
    with open(ko_arb_path, 'r', encoding='utf-8') as f:
        ko_data = json.load(f)
    
    
    # Vietnamese translations (manual for accuracy)
    vi_translations = {
        "appName": "SONA",
        "loading": "Đang tải...",
        "error": "Lỗi",
        "retry": "Thử lại",
        "cancel": "Hủy",
        "confirm": "Xác nhận",
        "next": "Tiếp theo",
        "skip": "Bỏ qua",
        "done": "Hoàn thành",
        "save": "Lưu",
        "delete": "Xóa",
        "edit": "Chỉnh sửa",
        "close": "Đóng",
        "search": "Tìm kiếm",
        "filter": "Lọc",
        "sort": "Sắp xếp",
        "refresh": "Làm mới",
        "yes": "Có",
        "no": "Không",
        "you": "Bạn",
        "login": "Đăng nhập",
        "signup": "Đăng ký",
        "meetAIPersonas": "Gặp gỡ các nhân vật AI",
        "welcomeMessage": "Chào mừng bạn💕",
        "loginSignup": "Đăng nhập/Đăng ký",
        "logout": "Đăng xuất",
        "email": "Email",
        "password": "Mật khẩu",
        "confirmPassword": "Xác nhận mật khẩu",
        "nickname": "Biệt danh",
        "forgotPassword": "Quên mật khẩu?",
        "alreadyHaveAccount": "Đã có tài khoản?",
        "dontHaveAccount": "Chưa có tài khoản?",
        "continueWithGoogle": "Tiếp tục với Google",
        "continueWithApple": "Tiếp tục với Apple",
        "or": "hoặc",
        "termsOfService": "Điều khoản dịch vụ",
        "privacyPolicy": "Chính sách bảo mật",
        "agreeToTerms": "Bằng cách đăng ký, bạn đồng ý với {terms} và {privacy} của chúng tôi",
        "emailRequired": "Vui lòng nhập email",
        "passwordRequired": "Vui lòng nhập mật khẩu",
        "nicknameRequired": "Vui lòng nhập biệt danh",
        "invalidEmail": "Email không hợp lệ",
        "passwordTooShort": "Mật khẩu phải có ít nhất 6 ký tự",
        "passwordMismatch": "Mật khẩu không khớp",
        "loginFailed": "Đăng nhập thất bại",
        "signupFailed": "Đăng ký thất bại",
        "emailAlreadyInUse": "Email đã được sử dụng",
        "weakPassword": "Mật khẩu quá yếu",
        "userNotFound": "Không tìm thấy người dùng",
        "wrongPassword": "Sai mật khẩu",
        "networkError": "Lỗi mạng",
        "unknownError": "Lỗi không xác định",
        "profile": "Hồ sơ",
        "settings": "Cài đặt",
        "notifications": "Thông báo",
        "language": "Ngôn ngữ",
        "theme": "Giao diện",
        "darkMode": "Chế độ tối",
        "lightMode": "Chế độ sáng",
        "systemDefault": "Mặc định hệ thống",
        "about": "Về chúng tôi",
        "version": "Phiên bản",
        "contactUs": "Liên hệ",
        "reportBug": "Báo lỗi",
        "rateApp": "Đánh giá ứng dụng",
        "shareApp": "Chia sẻ ứng dụng",
        "chat": "Trò chuyện",
        "personas": "Nhân vật",
        "store": "Cửa hàng",
        "heart": "Tim",
        "hearts": "Tim",
        "coin": "Xu",
        "coins": "Xu",
        "level": "Cấp độ",
        "experience": "Kinh nghiệm",
        "achievement": "Thành tựu",
        "achievements": "Thành tựu",
        "reward": "Phần thưởng",
        "rewards": "Phần thưởng",
        "daily": "Hàng ngày",
        "weekly": "Hàng tuần",
        "monthly": "Hàng tháng",
        "newMessage": "Tin nhắn mới",
        "typeMessage": "Nhập tin nhắn...",
        "send": "Gửi",
        "sending": "Đang gửi...",
        "sent": "Đã gửi",
        "delivered": "Đã nhận",
        "read": "Đã đọc",
        "online": "Trực tuyến",
        "offline": "Ngoại tuyến",
        "lastSeen": "Hoạt động lần cuối",
        "typing": "Đang nhập...",
        "recording": "Đang ghi âm...",
        "photo": "Ảnh",
        "camera": "Máy ảnh",
        "gallery": "Thư viện",
        "file": "Tệp",
        "location": "Vị trí",
        "voice": "Giọng nói",
        "video": "Video",
        "monday": "Thứ Hai",
        "tuesday": "Thứ Ba",
        "wednesday": "Thứ Tư",
        "thursday": "Thứ Năm",
        "friday": "Thứ Sáu",
        "saturday": "Thứ Bảy",
        "sunday": "Chủ Nhật",
        "january": "Tháng Một",
        "february": "Tháng Hai",
        "march": "Tháng Ba",
        "april": "Tháng Tư",
        "may": "Tháng Năm",
        "june": "Tháng Sáu",
        "july": "Tháng Bảy",
        "august": "Tháng Tám",
        "september": "Tháng Chín",
        "october": "Tháng Mười",
        "november": "Tháng Mười Một",
        "december": "Tháng Mười Hai",
        "today": "Hôm nay",
        "yesterday": "Hôm qua",
        "tomorrow": "Ngày mai",
        "now": "Bây giờ",
        "justNow": "Vừa xong",
        "minutesAgo": "{count} phút trước",
        "hoursAgo": "{count} giờ trước",
        "daysAgo": "{count} ngày trước",
        "weeksAgo": "{count} tuần trước",
        "monthsAgo": "{count} tháng trước",
        "yearsAgo": "{count} năm trước",
        
        # Additional SONA-specific translations
        "personaSelection": "Chọn nhân vật",
        "selectYourPersona": "Chọn nhân vật của bạn",
        "personalityTraits": "Đặc điểm tính cách",
        "conversationStyle": "Phong cách trò chuyện",
        "interests": "Sở thích",
        "startChat": "Bắt đầu trò chuyện",
        "endChat": "Kết thúc trò chuyện",
        "clearChat": "Xóa trò chuyện",
        "chatHistory": "Lịch sử trò chuyện",
        "noMessages": "Chưa có tin nhắn",
        "noPersonasAvailable": "Không có nhân vật nào",
        "loadingPersonas": "Đang tải nhân vật...",
        "personaLocked": "Nhân vật bị khóa",
        "unlockWithHearts": "Mở khóa với {hearts} tim",
        "insufficientHearts": "Không đủ tim",
        "purchaseHearts": "Mua tim",
        "earnHearts": "Kiếm tim",
        "dailyReward": "Phần thưởng hàng ngày",
        "claimReward": "Nhận thưởng",
        "rewardClaimed": "Đã nhận thưởng",
        "comeBackTomorrow": "Quay lại vào ngày mai",
        "personalityTest": "Kiểm tra tính cách",
        "takeTest": "Làm bài kiểm tra",
        "retakeTest": "Làm lại bài kiểm tra",
        "testResults": "Kết quả kiểm tra",
        "yourPersonalityType": "Loại tính cách của bạn",
        "matchingPersonas": "Nhân vật phù hợp",
        "recommendedForYou": "Đề xuất cho bạn",
        "popularPersonas": "Nhân vật phổ biến",
        "newPersonas": "Nhân vật mới",
        "favoritePersonas": "Nhân vật yêu thích",
        "blockedPersonas": "Nhân vật đã chặn",
        "unblockPersona": "Bỏ chặn nhân vật",
        "blockPersona": "Chặn nhân vật",
        "reportPersona": "Báo cáo nhân vật",
        "reportReason": "Lý do báo cáo",
        "reportSubmitted": "Đã gửi báo cáo",
        "changeNickname": "Đổi biệt danh",
        "changePassword": "Đổi mật khẩu",
        "deleteAccount": "Xóa tài khoản",
        "accountDeleted": "Tài khoản đã bị xóa",
        "confirmDelete": "Bạn có chắc muốn xóa tài khoản?",
        "cannotBeUndone": "Hành động này không thể hoàn tác",
        "profileUpdated": "Hồ sơ đã cập nhật",
        "settingsUpdated": "Cài đặt đã cập nhật",
        "notificationsEnabled": "Thông báo đã bật",
        "notificationsDisabled": "Thông báo đã tắt",
        "soundEnabled": "Âm thanh đã bật",
        "soundDisabled": "Âm thanh đã tắt",
        "vibrationEnabled": "Rung đã bật",
        "vibrationDisabled": "Rung đã tắt",
        "dataUsage": "Sử dụng dữ liệu",
        "cacheCleared": "Đã xóa bộ nhớ cache",
        "clearCache": "Xóa bộ nhớ cache",
        "storageUsed": "Dung lượng đã dùng",
        "availableStorage": "Dung lượng khả dụng",
        "backupData": "Sao lưu dữ liệu",
        "restoreData": "Khôi phục dữ liệu",
        "exportChat": "Xuất trò chuyện",
        "importChat": "Nhập trò chuyện",
        "connectionLost": "Mất kết nối",
        "reconnecting": "Đang kết nối lại...",
        "reconnected": "Đã kết nối lại",
        "checkingForUpdates": "Kiểm tra cập nhật...",
        "updateAvailable": "Có bản cập nhật",
        "updateNow": "Cập nhật ngay",
        "updateLater": "Để sau",
        "downloadingUpdate": "Đang tải cập nhật...",
        "installingUpdate": "Đang cài đặt cập nhật...",
        "updateComplete": "Cập nhật hoàn tất",
        "restartRequired": "Cần khởi động lại",
        "restartNow": "Khởi động lại ngay",
        "restartLater": "Để sau",
        
        # Premium/Purchase related
        "premium": "Premium",
        "upgradeToPremium": "Nâng cấp Premium",
        "premiumBenefits": "Quyền lợi Premium",
        "unlimitedHearts": "Tim không giới hạn",
        "unlimitedChats": "Trò chuyện không giới hạn",
        "exclusivePersonas": "Nhân vật độc quyền",
        "adFree": "Không quảng cáo",
        "prioritySupport": "Hỗ trợ ưu tiên",
        "monthlySubscription": "Gói tháng",
        "yearlySubscription": "Gói năm",
        "lifetimeAccess": "Truy cập trọn đời",
        "purchaseSuccessful": "Mua thành công",
        "purchaseFailed": "Mua thất bại",
        "restorePurchases": "Khôi phục giao dịch",
        "purchasesRestored": "Đã khôi phục giao dịch",
        "noPurchasesToRestore": "Không có giao dịch nào",
        
        # Error messages
        "somethingWentWrong": "Đã xảy ra lỗi",
        "pleaseTryAgain": "Vui lòng thử lại",
        "errorLoadingData": "Lỗi khi tải dữ liệu",
        "errorSavingData": "Lỗi khi lưu dữ liệu",
        "errorDeletingData": "Lỗi khi xóa dữ liệu",
        "noInternetConnection": "Không có kết nối internet",
        "serverError": "Lỗi máy chủ",
        "requestTimeout": "Hết thời gian yêu cầu",
        "invalidData": "Dữ liệu không hợp lệ",
        "accessDenied": "Truy cập bị từ chối",
        "sessionExpired": "Phiên đã hết hạn",
        "pleaseLoginAgain": "Vui lòng đăng nhập lại",
        
        # Success messages
        "success": "Thành công",
        "savedSuccessfully": "Đã lưu thành công",
        "deletedSuccessfully": "Đã xóa thành công",
        "updatedSuccessfully": "Đã cập nhật thành công",
        "sentSuccessfully": "Đã gửi thành công",
        
        # Confirmation dialogs
        "areYouSure": "Bạn có chắc chắn?",
        "confirmAction": "Xác nhận hành động",
        "confirmLogout": "Bạn có chắc muốn đăng xuất?",
        "confirmClearChat": "Bạn có chắc muốn xóa trò chuyện?",
        "confirmBlockPersona": "Bạn có chắc muốn chặn nhân vật này?",
        
        # Onboarding
        "welcomeToSona": "Chào mừng đến với SONA",
        "getStarted": "Bắt đầu",
        "nextStep": "Bước tiếp theo",
        "previousStep": "Bước trước",
        "completeSetup": "Hoàn tất cài đặt",
        "skipSetup": "Bỏ qua cài đặt",
        "onboardingTitle1": "Gặp gỡ bạn AI hoàn hảo",
        "onboardingDesc1": "Khám phá các nhân vật AI được cá nhân hóa phù hợp với tính cách của bạn",
        "onboardingTitle2": "Trò chuyện tự nhiên",
        "onboardingDesc2": "Tận hưởng các cuộc trò chuyện có ý nghĩa với AI hiểu bạn",
        "onboardingTitle3": "Phát triển cùng nhau",
        "onboardingDesc3": "Xây dựng kết nối sâu sắc hơn qua từng cuộc trò chuyện",
        
        # Personality traits
        "introvert": "Hướng nội",
        "extrovert": "Hướng ngoại",
        "thinking": "Lý trí",
        "feeling": "Cảm xúc",
        "judging": "Quyết đoán",
        "perceiving": "Linh hoạt",
        "sensing": "Thực tế",
        "intuition": "Trực giác",
        
        # Chat emotions/reactions
        "happy": "Vui vẻ",
        "sad": "Buồn",
        "angry": "Tức giận",
        "surprised": "Ngạc nhiên",
        "love": "Yêu thương",
        "confused": "Bối rối",
        "excited": "Phấn khích",
        "worried": "Lo lắng",
        "grateful": "Biết ơn",
        "proud": "Tự hào",
        
        # Time periods
        "morning": "Buổi sáng",
        "afternoon": "Buổi chiều",
        "evening": "Buổi tối",
        "night": "Ban đêm",
        "weekend": "Cuối tuần",
        "weekday": "Ngày thường",
        
        # Special features
        "voiceCall": "Gọi thoại",
        "videoCall": "Gọi video",
        "shareScreen": "Chia sẻ màn hình",
        "sendGift": "Gửi quà",
        "playGame": "Chơi game",
        "watchTogether": "Xem cùng nhau",
        "listenMusic": "Nghe nhạc",
        "readStory": "Đọc truyện",
        
        # Settings categories
        "accountSettings": "Cài đặt tài khoản",
        "chatSettings": "Cài đặt trò chuyện",
        "notificationSettings": "Cài đặt thông báo",
        "privacySettings": "Cài đặt quyền riêng tư",
        "appearanceSettings": "Cài đặt giao diện",
        "languageSettings": "Cài đặt ngôn ngữ",
        "dataSettings": "Cài đặt dữ liệu",
        "helpAndSupport": "Trợ giúp & Hỗ trợ",
        
        # Help/Support
        "faq": "Câu hỏi thường gặp",
        "userGuide": "Hướng dẫn sử dụng",
        "contactSupport": "Liên hệ hỗ trợ",
        "feedbackAndSuggestions": "Phản hồi & Đề xuất",
        "reportProblem": "Báo cáo vấn đề",
        "requestFeature": "Yêu cầu tính năng",
        
        # Legal
        "terms": "Điều khoản",
        "privacy": "Quyền riêng tư",
        "licenses": "Giấy phép",
        "copyright": "Bản quyền",
        "disclaimer": "Tuyên bố miễn trừ",
        
        # Additional UI elements
        "pull_to_refresh": "Kéo để làm mới",
        "release_to_refresh": "Thả để làm mới",
        "refreshing": "Đang làm mới...",
        "load_more": "Tải thêm",
        "loading_more": "Đang tải thêm...",
        "no_more_data": "Không còn dữ liệu",
        "empty_state": "Không có gì ở đây",
        "try_again_later": "Vui lòng thử lại sau",
        "coming_soon": "Sắp ra mắt",
        "beta": "Beta",
        "new": "Mới",
        "updated": "Đã cập nhật",
        "featured": "Nổi bật",
        "trending": "Xu hướng",
        "hot": "Hot",
        "limited": "Giới hạn",
        "exclusive": "Độc quyền",
        "special": "Đặc biệt",
        "recommended": "Đề xuất",
        "popular": "Phổ biến",
        "verified": "Đã xác minh",
        "official": "Chính thức",
        
        # Gender
        "male": "Nam",
        "female": "Nữ",
        "other": "Khác",
        "preferNotToSay": "Không muốn nói",
        
        # Age
        "ageRange": "Độ tuổi",
        "under18": "Dưới 18",
        "18to24": "18-24",
        "25to34": "25-34",
        "35to44": "35-44",
        "45to54": "45-54",
        "55plus": "55+",
        
        # Relationship status
        "single": "Độc thân",
        "inRelationship": "Đang hẹn hò",
        "married": "Đã kết hôn",
        "divorced": "Đã ly hôn",
        "widowed": "Góa",
        "complicated": "Phức tạp",
        
        # Mood/Status
        "available": "Có mặt",
        "busy": "Bận",
        "away": "Vắng mặt",
        "doNotDisturb": "Không làm phiền",
        "invisible": "Ẩn",
        
        # Actions
        "like": "Thích",
        "unlike": "Bỏ thích",
        "favorite": "Yêu thích",
        "unfavorite": "Bỏ yêu thích",
        "follow": "Theo dõi",
        "unfollow": "Bỏ theo dõi",
        "share": "Chia sẻ",
        "copy": "Sao chép",
        "paste": "Dán",
        "cut": "Cắt",
        "undo": "Hoàn tác",
        "redo": "Làm lại",
        "selectAll": "Chọn tất cả",
        "deselectAll": "Bỏ chọn tất cả",
        
        # Permissions
        "allowAccess": "Cho phép truy cập",
        "denyAccess": "Từ chối truy cập",
        "grantPermission": "Cấp quyền",
        "revokePermission": "Thu hồi quyền",
        "cameraPermission": "Quyền truy cập máy ảnh",
        "microphonePermission": "Quyền truy cập micro",
        "locationPermission": "Quyền truy cập vị trí",
        "notificationPermission": "Quyền thông báo",
        "storagePermission": "Quyền lưu trữ",
        "contactsPermission": "Quyền truy cập danh bạ",
        
        # Validation messages
        "fieldRequired": "Trường này là bắt buộc",
        "invalidFormat": "Định dạng không hợp lệ",
        "tooShort": "Quá ngắn",
        "tooLong": "Quá dài",
        "invalidCharacters": "Ký tự không hợp lệ",
        "alreadyExists": "Đã tồn tại",
        "notFound": "Không tìm thấy",
        "expired": "Đã hết hạn",
        "invalid": "Không hợp lệ",
        "required": "Bắt buộc",
        "optional": "Tùy chọn",
        
        # Navigation
        "home": "Trang chủ",
        "back": "Quay lại",
        "forward": "Tiến",
        "menu": "Menu",
        "more": "Thêm",
        "less": "Ít hơn",
        "showMore": "Hiển thị thêm",
        "showLess": "Hiển thị ít hơn",
        "viewAll": "Xem tất cả",
        "viewDetails": "Xem chi tiết",
        "goBack": "Quay lại",
        "goToHome": "Về trang chủ",
        "goToSettings": "Đến cài đặt",
        "goToProfile": "Đến hồ sơ",
        
        # Formats
        "dateFormat": "dd/MM/yyyy",
        "timeFormat": "HH:mm",
        "dateTimeFormat": "dd/MM/yyyy HH:mm",
        "currency": "₫",
        "currencySymbol": "₫",
        "decimalSeparator": ",",
        "thousandsSeparator": ".",
        
        # Special Vietnamese phrases
        "xinChao": "Xin chào",
        "tamBiet": "Tạm biệt",
        "camOn": "Cảm ơn",
        "xinLoi": "Xin lỗi",
        "khongCoGi": "Không có gì",
        "ratVui": "Rất vui",
        "henGapLai": "Hẹn gặp lại",
        "chucMungNamMoi": "Chúc mừng năm mới",
        "chucMung": "Chúc mừng",
        "thuongYeu": "Thương yêu"
    }
    
    # Create Vietnamese ARB with proper structure
    vi_data = {"@@locale": "vi"}
    
    # Copy all keys from Korean ARB and translate
    for key, value in ko_data.items():
        if key.startswith("@@"):
            # Keep metadata as is
            if key == "@@locale":
                vi_data[key] = "vi"
            else:
                vi_data[key] = value
        elif key.startswith("@"):
            # Keep description metadata
            vi_data[key] = value
        else:
            # Use manual translation if available, otherwise keep for later translation
            if key in vi_translations:
                vi_data[key] = vi_translations[key]
            else:
                # For now, keep the Korean text as placeholder
                # In production, you would use professional translation
                vi_data[key] = value
                print(f"Warning: No translation for key '{key}'")
    
    # Write Vietnamese ARB file
    with open(vi_arb_path, 'w', encoding='utf-8') as f:
        json.dump(vi_data, f, ensure_ascii=False, indent=2)
    
    print(f"✅ Vietnamese ARB file created at: {vi_arb_path}")
    print(f"📊 Translated {len(vi_translations)} keys")
    
    # Return the path for verification
    return vi_arb_path

if __name__ == "__main__":
    vi_arb_path = translate_to_vietnamese()
    print(f"\n🎉 Vietnamese translation complete!")
    print(f"📁 File location: {vi_arb_path}")
    print("\n⚠️ Note: Please have a native Vietnamese speaker review the translations for accuracy.")