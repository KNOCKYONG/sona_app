#!/usr/bin/env python3
"""
Complete all Chinese translations by replacing any English text.
"""

import json
import os
import sys

# Complete Chinese translations for all keys
CHINESE_TRANSLATIONS = {
    "enterEmail": "请输入邮箱",
    "profilePhoto": "个人照片",
    "birthDate": "出生日期",
    "setNow": "立即设置",
    "personaGenderSection": "角色性别偏好",
    "showAllGendersOption": "显示所有性别",
    "enterBasicInformation": "请输入基本信息",
    "optional": "可选",
    "previous": "上一步",
    "completeSignup": "完成注册",
    "year": "年",
    "month": "月",
    "day": "日",
    "selfIntroductionHint": "写一段关于你自己的简短介绍",
    "usagePurpose": "使用目的",
    "selectFeeling": "选择心情",
    "happy": "开心",
    "sad": "难过",
    "angry": "生气",
    "anxious": "焦虑",
    "excited": "兴奋",
    "relaxed": "放松",
    "confused": "困惑",
    "messageDeleted": "消息已删除",
    "messagesRemaining": "剩余消息",
    "dailyMessages": "每日消息",
    "totalMatches": "总匹配数",
    "memberSince": "加入时间",
    "lastActive": "最后活跃",
    "accountSettings": "账户设置",
    "changePassword": "更改密码",
    "emailVerification": "邮箱验证",
    "profileCompletion": "资料完成度",
    "purchaseHistory": "购买记录",
    "supportCenter": "支持中心",
    "contactSupport": "联系支持",
    "faq": "常见问题",
    "reportBug": "报告错误",
    "suggestFeature": "功能建议",
    "rateApp": "为应用评分",
    "shareApp": "分享应用",
    "inviteFriends": "邀请朋友",
    "enterPassword": "请输入密码",
    "confirmPassword": "确认密码",
    "passwordsDoNotMatch": "密码不匹配",
    "weakPassword": "密码太弱",
    "strongPassword": "密码强度高",
    "minimumPasswordLength": "最少8个字符",
    "registrationComplete": "注册完成",
    "welcomeToApp": "欢迎使用应用",
    "letsGetStarted": "让我们开始吧",
    "skipForNow": "暂时跳过",
    "continueText": "继续",
    "backText": "返回",
    "finishText": "完成",
    "laterText": "稍后",
    "updateNow": "立即更新",
    "updateAvailable": "有可用更新",
    "newVersionAvailable": "新版本可用",
    "currentVersion": "当前版本",
    "latestVersion": "最新版本",
    "whatsNew": "更新内容",
    "updateRequired": "需要更新",
    "optionalUpdate": "可选更新",
    "downloadingUpdate": "正在下载更新",
    "installingUpdate": "正在安装更新",
    "updateFailed": "更新失败",
    "retryUpdate": "重试更新",
    "notNow": "现在不",
    "remindMeLater": "稍后提醒",
    "dontAskAgain": "不再询问",
    "networkError": "网络错误",
    "serverError": "服务器错误",
    "unknownError": "未知错误",
    "tryAgainLater": "请稍后再试",
    "connectionLost": "连接丢失",
    "reconnecting": "重新连接中",
    "offline": "离线",
    "online": "在线",
    "syncingData": "同步数据中",
    "dataSynced": "数据已同步",
    "syncFailed": "同步失败",
    "retrySync": "重试同步",
    "lastSynced": "最后同步",
    "autoSync": "自动同步",
    "manualSync": "手动同步",
    "syncNow": "立即同步",
    "syncSettings": "同步设置",
    "cloudBackup": "云备份",
    "restoreBackup": "恢复备份",
    "createBackup": "创建备份",
    "backupCreated": "备份已创建",
    "restoreComplete": "恢复完成",
    "deleteBackup": "删除备份",
    "backupDeleted": "备份已删除",
    "selectBackup": "选择备份",
    "noBackupsFound": "未找到备份",
    "automaticBackup": "自动备份",
    "backupFrequency": "备份频率",
    "daily": "每日",
    "weekly": "每周",
    "monthly": "每月",
    "never": "从不"
}

def update_chinese_arb():
    """Update Chinese ARB file with proper translations."""
    arb_path = "sona_app/lib/l10n/app_zh.arb"
    
    if not os.path.exists(arb_path):
        print(f"Error: {arb_path} not found")
        return False
    
    # Read the ARB file
    with open(arb_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    updated_count = 0
    
    # Check each key in the ARB file
    for key in list(data.keys()):
        if key.startswith('@'):
            continue
            
        value = data[key]
        
        # If it's in English (contains only ASCII characters), try to translate
        if isinstance(value, str) and value.encode('ascii', 'ignore').decode('ascii') == value:
            # Check if we have a translation
            if key in CHINESE_TRANSLATIONS:
                data[key] = CHINESE_TRANSLATIONS[key]
                print(f"  Translated: {key}")
                updated_count += 1
    
    # Write back the updated file
    with open(arb_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"\nUpdated {updated_count} translations in Chinese")
    return True

def main():
    print("Completing Chinese translations...")
    print("=" * 60)
    
    if update_chinese_arb():
        print("\nRegenerating localization files...")
        os.system("cd sona_app && flutter gen-l10n")
        print("\nChinese translations completed!")
    else:
        print("\nFailed to update Chinese translations")
        sys.exit(1)

if __name__ == "__main__":
    main()