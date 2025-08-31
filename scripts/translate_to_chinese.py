#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json

# 중국어 번역 매핑
translations = {
    # Basic UI
    "loading": "加载中...",
    "error": "错误",
    "retry": "重试",
    "cancel": "取消",
    "confirm": "确认",
    "next": "下一步",
    "skip": "跳过",
    "done": "完成",
    "save": "保存",
    "delete": "删除",
    "edit": "编辑",
    "close": "关闭",
    "search": "搜索",
    "filter": "筛选",
    "sort": "排序",
    "refresh": "刷新",
    "yes": "是",
    "no": "否",
    "you": "你",
    
    # Auth
    "login": "登录",
    "signup": "注册",
    "meetAIPersonas": "遇见AI伴侣",
    "welcomeMessage": "欢迎💕",
    "aiDatingQuestion": "你会和AI谈恋爱吗？",
    "loginSignup": "登录/注册",
    "or": "或",
    "startWithEmail": "使用邮箱开始",
    "startWithGoogle": "使用Google开始",
    "loginWithGoogle": "使用Google登录",
    "loginWithApple": "使用Apple登录",
    "loginError": "登录失败。请重试。",
    "googleLoginError": "Google登录失败",
    "appleLoginError": "Apple登录失败",
    "loginCancelled": "登录已取消",
    "loginWithoutAccount": "无账号继续",
    "logout": "退出",
    "logoutConfirm": "确定要退出吗？",
    
    # User Info
    "basicInfo": "基本信息",
    "enterBasicInfo": "输入您的基本信息",
    "email": "邮箱",
    "password": "密码",
    "passwordHint": "输入密码（6位以上）",
    "passwordError": "密码至少需要6位",
    "nickname": "昵称",
    "nicknameHint": "输入您的昵称",
    "nicknameError": "请输入昵称",
    "birthday": "生日",
    "age": "年龄",
    "gender": "性别",
    "male": "男",
    "female": "女",
    "other": "其他",
    "selectGender": "选择性别",
    "selectBirthday": "选择生日",
    "ageRestriction": "您必须年满18岁",
    "mbtiType": "MBTI类型",
    "selectMBTI": "选择MBTI",
    "idealType": "理想型",
    "idealPersona": "理想伴侣",
    "idealTypeHint": "描述您的理想型（选填）",
    "mbtiDescription": "选择您的性格类型",
    
    # Navigation
    "home": "首页",
    "chat": "聊天",
    "profile": "个人资料",
    "settings": "设置",
    "store": "商店",
    
    # Profile
    "myProfile": "我的资料",
    "editProfile": "编辑资料",
    "saveProfile": "保存资料",
    "profileUpdated": "资料已更新",
    "profileUpdateError": "资料更新失败",
    "changePhoto": "更换照片",
    "selectFromGallery": "从相册选择",
    "takePhoto": "拍照",
    "removePhoto": "删除照片",
    
    # Settings
    "notification": "通知",
    "notificationSettings": "通知设置",
    "pushNotifications": "推送通知",
    "emailNotifications": "邮件通知",
    "soundSettings": "声音设置",
    "vibration": "振动",
    "language": "语言",
    "languageSettings": "语言设置",
    "theme": "主题",
    "darkMode": "深色模式",
    "lightMode": "浅色模式",
    "systemDefault": "跟随系统",
    "privacy": "隐私",
    "privacyPolicy": "隐私政策",
    "termsOfService": "服务条款",
    "about": "关于",
    "version": "版本",
    "checkUpdate": "检查更新",
    "contactUs": "联系我们",
    "feedback": "反馈",
    "rateApp": "评价应用",
    "share": "分享",
    "accountSettings": "账号设置",
    "changePassword": "修改密码",
    "deleteAccount": "删除账号",
    "deleteAccountConfirm": "确定要删除账号吗？此操作不可恢复。",
    "blockedPersonas": "屏蔽的角色",
    "dataAndStorage": "数据与存储",
    "clearCache": "清除缓存",
    "downloadData": "下载数据",
    
    # Chat
    "sendMessage": "发送消息",
    "typeMessage": "输入消息...",
    "newChat": "新对话",
    "clearChat": "清除对话",
    "chatCleared": "对话已清除",
    "messageTooLong": "消息太长",
    "sendingMessage": "发送中...",
    "messageError": "消息发送失败",
    "retrySend": "重新发送",
    "messageCopied": "消息已复制",
    "copyMessage": "复制消息",
    "deleteMessage": "删除消息",
    "editMessage": "编辑消息",
    "reply": "回复",
    "forward": "转发",
    "selectPersona": "选择角色",
    "chatWith": "与{name}聊天",
    "online": "在线",
    "offline": "离线",
    "typing": "正在输入...",
    "lastSeen": "最后上线",
    "today": "今天",
    "yesterday": "昨天",
    "readReceipts": "已读回执",
    "delivered": "已送达",
    "read": "已读",
    "unread": "未读",
    
    # Personas
    "persona": "角色",
    "personas": "角色",
    "allPersonas": "所有角色",
    "myPersonas": "我的角色",
    "popularPersonas": "热门角色",
    "newPersonas": "新角色",
    "recommendedPersonas": "推荐角色",
    "searchPersonas": "搜索角色",
    "personaDetails": "角色详情",
    "aboutPersona": "关于角色",
    "chatNow": "立即聊天",
    "addToFavorites": "添加到收藏",
    "removeFromFavorites": "从收藏中移除",
    "blockPersona": "屏蔽角色",
    "unblockPersona": "取消屏蔽",
    "reportPersona": "举报角色",
    "personaBlocked": "角色已屏蔽",
    "personaUnblocked": "已取消屏蔽",
    "personaReported": "角色已举报",
    
    # Store & Hearts
    "hearts": "爱心",
    "buyHearts": "购买爱心",
    "heartBalance": "爱心余额",
    "heartHistory": "爱心历史",
    "purchase": "购买",
    "purchaseSuccess": "购买成功",
    "purchaseError": "购买失败",
    "insufficientHearts": "爱心不足",
    "earnHearts": "赚取爱心",
    "dailyReward": "每日奖励",
    "watchAd": "观看广告",
    "inviteFriends": "邀请朋友",
    "completeTasks": "完成任务",
    
    # Matching
    "matching": "匹配",
    "findMatch": "寻找匹配",
    "matchFound": "找到匹配！",
    "noMatchFound": "未找到匹配",
    "searchingMatch": "正在搜索...",
    "matchingPreferences": "匹配偏好",
    "ageRange": "年龄范围",
    "distance": "距离",
    "interests": "兴趣",
    "compatibility": "兼容性",
    
    # Errors
    "networkError": "网络错误",
    "serverError": "服务器错误",
    "unknownError": "未知错误",
    "tryAgainLater": "请稍后再试",
    "checkInternetConnection": "请检查网络连接",
    "sessionExpired": "会话已过期",
    "pleaseLoginAgain": "请重新登录",
    "permissionDenied": "权限被拒绝",
    "fileNotFound": "文件未找到",
    "invalidInput": "输入无效",
    "operationFailed": "操作失败",
    "timeout": "超时",
    
    # Common Actions
    "ok": "确定",
    "apply": "应用",
    "submit": "提交",
    "continue": "继续",
    "back": "返回",
    "exit": "退出",
    "more": "更多",
    "less": "收起",
    "showMore": "显示更多",
    "showLess": "显示更少",
    "viewAll": "查看全部",
    "collapse": "收起",
    "expand": "展开",
    "loading": "加载中",
    "processing": "处理中",
    "uploading": "上传中",
    "downloading": "下载中",
    "copied": "已复制",
    "shareApp": "分享应用",
    "inviteCode": "邀请码",
    "enterInviteCode": "输入邀请码",
    
    # Time
    "justNow": "刚刚",
    "minutesAgo": "{count}分钟前",
    "hoursAgo": "{count}小时前",
    "daysAgo": "{count}天前",
    "weeksAgo": "{count}周前",
    "monthsAgo": "{count}个月前",
    "yearsAgo": "{count}年前",
    
    # Premium
    "premium": "高级版",
    "premiumFeatures": "高级功能",
    "upgradeToPremium": "升级到高级版",
    "premiumBenefits": "高级版权益",
    "unlimitedMessages": "无限消息",
    "priorityMatching": "优先匹配",
    "advancedFilters": "高级筛选",
    "noAds": "无广告",
    "exclusivePersonas": "独家角色",
    
    # FAQ
    "faq": "常见问题",
    "helpCenter": "帮助中心",
    "customerSupport": "客户支持",
    "reportBug": "报告错误",
    "suggestFeature": "建议功能",
    
    # Onboarding
    "welcomeToApp": "欢迎使用SONA",
    "getStarted": "开始使用",
    "createYourProfile": "创建您的资料",
    "findYourMatch": "寻找您的匹配",
    "startChatting": "开始聊天",
    "onboardingComplete": "设置完成",
    
    # Additional
    "changeLanguage": "更改语言",
    "selectLanguage": "选择语言",
    "koreanLanguage": "韩语",
    "englishLanguage": "英语",
    "japaneseLanguage": "日语",
    "chineseLanguage": "中文",
    "useSystemLanguage": "使用系统语言",
    "followDeviceLanguage": "跟随设备语言设置",
    "setAppInterfaceLanguage": "设置应用界面语言",
    
    # Terms and Privacy
    "agreeToTerms": "同意条款",
    "termsAndConditions": "条款和条件",
    "privacyAndPolicy": "隐私政策",
    "acceptAll": "全部接受",
    "decline": "拒绝",
    "readMore": "阅读更多",
    
    # Matching Related
    "likePersona": "喜欢",
    "passPersona": "跳过",
    "superLike": "超级喜欢",
    "itsAMatch": "配对成功！",
    "keepSwiping": "继续滑动",
    "sendFirstMessage": "发送第一条消息",
    "unmatch": "取消配对",
    "unmatchConfirm": "确定要取消配对吗？",
    
    # Error Messages
    "errorOccurred": "发生错误",
    "somethingWentWrong": "出了点问题",
    "pleaseTryAgain": "请重试",
    "reportSent": "报告已发送",
    "thankYouForReport": "感谢您的报告",
}

# 参数化字符串
parameterized = {
    "chatWith": "与{name}聊天",
    "minutesAgo": "{count}分钟前",
    "hoursAgo": "{count}小时前",
    "daysAgo": "{count}天前",
    "weeksAgo": "{count}周前",
    "monthsAgo": "{count}个月前",
    "yearsAgo": "{count}年前",
    "heartCount": "{count}个爱心",
    "messageCount": "{count}条消息",
    "personaCount": "{count}个角色",
    "dayCount": "{count}天",
    "matchPercentage": "{percent}%匹配",
    "ageValue": "{age}岁",
    "distanceKm": "{distance}公里",
    "onlineTime": "{time}在线",
    "offlineTime": "{time}离线",
    "typingTo": "正在给{name}输入...",
    "repliedTo": "回复{name}",
    "welcomeUser": "欢迎，{name}！",
    "greetingWithName": "你好，{name}",
    "profileOf": "{name}的资料",
    "reportUser": "举报{name}",
    "blockUser": "屏蔽{name}",
    "unblockUser": "取消屏蔽{name}",
    "deleteChat": "删除与{name}的对话",
    "clearChatHistory": "清除与{name}的聊天记录",
    "monthDay": "{month}月{day}日",
}

def translate_arb_file():
    # Read the existing file
    with open('sona_app/lib/l10n/app_zh.arb', 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Update locale
    data['@@locale'] = 'zh'
    
    # Apply translations
    for key, value in translations.items():
        if key in data:
            data[key] = value
            print(f"Translated: {key}")
    
    # Apply parameterized translations
    for key, value in parameterized.items():
        if key in data:
            data[key] = value
            print(f"Translated (parameterized): {key}")
    
    # Write back
    with open('sona_app/lib/l10n/app_zh.arb', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"\n✅ Translated {len(translations)} simple strings")
    print(f"✅ Translated {len(parameterized)} parameterized strings")
    print(f"📁 File saved: sona_app/lib/l10n/app_zh.arb")

if __name__ == "__main__":
    translate_arb_file()