#!/usr/bin/env python3
"""
Add parameterized methods to ARB files
"""

import json

# Parameterized strings for Korean
ko_parameterized = {
    "waitingForChat": "{name}님이 대화를 기다리고 있어요.",
    "@waitingForChat": {
        "description": "Shows that a persona is waiting to chat",
        "placeholders": {
            "name": {"type": "String"}
        }
    },
    "conversationWith": "{name}",
    "@conversationWith": {
        "description": "Conversation with name",
        "placeholders": {
            "name": {"type": "String"}
        }
    },
    "refreshComplete": "새로고침 완료! {count}명의 매칭된 페르소나",
    "@refreshComplete": {
        "description": "Refresh complete message",
        "placeholders": {
            "count": {"type": "int"}
        }
    },
    "daysRemaining": "{days}일 남음",
    "@daysRemaining": {
        "description": "Days remaining",
        "placeholders": {
            "days": {"type": "int"}
        }
    },
    "purchaseConfirmMessage": "{product}을(를) {price}에 구매하시겠습니까?",
    "@purchaseConfirmMessage": {
        "description": "Purchase confirmation message",
        "placeholders": {
            "product": {"type": "String"},
            "price": {"type": "String"}
        }
    },
    "discountAmountValue": "₩{amount} 할인",
    "@discountAmountValue": {
        "description": "Discount amount",
        "placeholders": {
            "amount": {"type": "String"}
        }
    },
    "chattingWithPersonas": "{count}명의 소나와 대화중",
    "@chattingWithPersonas": {
        "description": "Number of personas chatting with",
        "placeholders": {
            "count": {"type": "int"}
        }
    },
    "purchaseConfirmContent": "{product}을(를) {price}에 구매하시겠습니까?",
    "@purchaseConfirmContent": {
        "description": "Purchase confirmation content",
        "placeholders": {
            "product": {"type": "String"},
            "price": {"type": "String"}
        }
    },
    "reportError": "신고 접수 중 오류가 발생했습니다: {error}",
    "@reportError": {
        "description": "Report error message",
        "placeholders": {
            "error": {"type": "String"}
        }
    },
    "permissionDeniedMessage": "{permissionName} 권한이 거부되었습니다.\\n설정에서 권한을 허용해주세요.",
    "@permissionDeniedMessage": {
        "description": "Permission denied message",
        "placeholders": {
            "permissionName": {"type": "String"}
        }
    },
    "daysAgo": "{days}일 전",
    "@daysAgo": {
        "description": "Days ago",
        "placeholders": {
            "days": {"type": "int"}
        }
    },
    "hoursAgo": "{hours}시간 전",
    "@hoursAgo": {
        "description": "Hours ago",
        "placeholders": {
            "hours": {"type": "int"}
        }
    },
    "minutesAgo": "{minutes}분 전",
    "@minutesAgo": {
        "description": "Minutes ago",
        "placeholders": {
            "minutes": {"type": "int"}
        }
    },
    "isTyping": "{name}님이 입력 중...",
    "@isTyping": {
        "description": "Shows someone is typing",
        "placeholders": {
            "name": {"type": "String"}
        }
    },
    "ageRange": "{min}~{max}세",
    "@ageRange": {
        "description": "Age range",
        "placeholders": {
            "min": {"type": "int"},
            "max": {"type": "int"}
        }
    },
    "blockedAICount": "차단된 AI {count}개",
    "@blockedAICount": {
        "description": "Number of blocked AIs",
        "placeholders": {
            "count": {"type": "int"}
        }
    },
    "guestMessageRemaining": "게스트 메시지 {count}회 남음",
    "@guestMessageRemaining": {
        "description": "Guest messages remaining",
        "placeholders": {
            "count": {"type": "int"}
        }
    },
    "newMessageCount": "새 메시지 {count}개",
    "@newMessageCount": {
        "description": "Number of new messages",
        "placeholders": {
            "count": {"type": "int"}
        }
    },
    "notEnoughHeartsCount": "하트가 부족합니다. (현재: {count}개)",
    "@notEnoughHeartsCount": {
        "description": "Not enough hearts message",
        "placeholders": {
            "count": {"type": "int"}
        }
    },
    "restartConversationWithName": "{name}와 다시 대화를 시작합니다!",
    "@restartConversationWithName": {
        "description": "Restarting conversation message",
        "placeholders": {
            "name": {"type": "String"}
        }
    },
    "restartConversationQuestion": "{name}와 다시 대화를 시작하시겠어요?",
    "@restartConversationQuestion": {
        "description": "Restart conversation question",
        "placeholders": {
            "name": {"type": "String"}
        }
    },
    "monthDay": "{month}월 {day}일",
    "@monthDay": {
        "description": "Month and day format",
        "placeholders": {
            "month": {"type": "int"},
            "day": {"type": "int"}
        }
    },
    "alreadyChattingWith": "{name}님과는 이미 대화중이에요!",
    "@alreadyChattingWith": {
        "description": "Already chatting with persona",
        "placeholders": {
            "name": {"type": "String"}
        }
    },
    "cacheDeleteError": "캐시 삭제 중 오류가 발생했습니다: {error}",
    "@cacheDeleteError": {
        "description": "Cache delete error",
        "placeholders": {
            "error": {"type": "String"}
        }
    },
    "unblockPersonaConfirm": "{name}의 차단을 해제하시겠습니까?",
    "@unblockPersonaConfirm": {
        "description": "Unblock persona confirmation",
        "placeholders": {
            "name": {"type": "String"}
        }
    },
    "errorWithMessage": "오류가 발생했습니다: {error}",
    "@errorWithMessage": {
        "description": "Error with message",
        "placeholders": {
            "error": {"type": "String"}
        }
    }
}

# Parameterized strings for English
en_parameterized = {
    "waitingForChat": "{name} is waiting to chat.",
    "@waitingForChat": {
        "description": "Shows that a persona is waiting to chat",
        "placeholders": {
            "name": {"type": "String"}
        }
    },
    "conversationWith": "{name}",
    "@conversationWith": {
        "description": "Conversation with name",
        "placeholders": {
            "name": {"type": "String"}
        }
    },
    "refreshComplete": "Refresh complete! {count} matched personas",
    "@refreshComplete": {
        "description": "Refresh complete message",
        "placeholders": {
            "count": {"type": "int"}
        }
    },
    "daysRemaining": "{days} days remaining",
    "@daysRemaining": {
        "description": "Days remaining",
        "placeholders": {
            "days": {"type": "int"}
        }
    },
    "purchaseConfirmMessage": "Purchase {product} for {price}?",
    "@purchaseConfirmMessage": {
        "description": "Purchase confirmation message",
        "placeholders": {
            "product": {"type": "String"},
            "price": {"type": "String"}
        }
    },
    "discountAmountValue": "Save ₩{amount}",
    "@discountAmountValue": {
        "description": "Discount amount",
        "placeholders": {
            "amount": {"type": "String"}
        }
    },
    "chattingWithPersonas": "Chatting with {count} personas",
    "@chattingWithPersonas": {
        "description": "Number of personas chatting with",
        "placeholders": {
            "count": {"type": "int"}
        }
    },
    "purchaseConfirmContent": "Purchase {product} for {price}?",
    "@purchaseConfirmContent": {
        "description": "Purchase confirmation content",
        "placeholders": {
            "product": {"type": "String"},
            "price": {"type": "String"}
        }
    },
    "reportError": "Error occurred while reporting: {error}",
    "@reportError": {
        "description": "Report error message",
        "placeholders": {
            "error": {"type": "String"}
        }
    },
    "permissionDeniedMessage": "{permissionName} permission was denied.\\nPlease allow the permission in settings.",
    "@permissionDeniedMessage": {
        "description": "Permission denied message",
        "placeholders": {
            "permissionName": {"type": "String"}
        }
    },
    "daysAgo": "{days} days ago",
    "@daysAgo": {
        "description": "Days ago",
        "placeholders": {
            "days": {"type": "int"}
        }
    },
    "hoursAgo": "{hours} hours ago",
    "@hoursAgo": {
        "description": "Hours ago",
        "placeholders": {
            "hours": {"type": "int"}
        }
    },
    "minutesAgo": "{minutes} minutes ago",
    "@minutesAgo": {
        "description": "Minutes ago",
        "placeholders": {
            "minutes": {"type": "int"}
        }
    },
    "isTyping": "{name} is typing...",
    "@isTyping": {
        "description": "Shows someone is typing",
        "placeholders": {
            "name": {"type": "String"}
        }
    },
    "ageRange": "{min}-{max} years old",
    "@ageRange": {
        "description": "Age range",
        "placeholders": {
            "min": {"type": "int"},
            "max": {"type": "int"}
        }
    },
    "blockedAICount": "{count} blocked AIs",
    "@blockedAICount": {
        "description": "Number of blocked AIs",
        "placeholders": {
            "count": {"type": "int"}
        }
    },
    "guestMessageRemaining": "{count} guest messages remaining",
    "@guestMessageRemaining": {
        "description": "Guest messages remaining",
        "placeholders": {
            "count": {"type": "int"}
        }
    },
    "newMessageCount": "{count} new messages",
    "@newMessageCount": {
        "description": "Number of new messages",
        "placeholders": {
            "count": {"type": "int"}
        }
    },
    "notEnoughHeartsCount": "Not enough hearts. (Current: {count})",
    "@notEnoughHeartsCount": {
        "description": "Not enough hearts message",
        "placeholders": {
            "count": {"type": "int"}
        }
    },
    "restartConversationWithName": "Restarting conversation with {name}!",
    "@restartConversationWithName": {
        "description": "Restarting conversation message",
        "placeholders": {
            "name": {"type": "String"}
        }
    },
    "restartConversationQuestion": "Would you like to restart the conversation with {name}?",
    "@restartConversationQuestion": {
        "description": "Restart conversation question",
        "placeholders": {
            "name": {"type": "String"}
        }
    },
    "monthDay": "{month} {day}",
    "@monthDay": {
        "description": "Month and day format",
        "placeholders": {
            "month": {"type": "String"},
            "day": {"type": "int"}
        }
    },
    "alreadyChattingWith": "Already chatting with {name}!",
    "@alreadyChattingWith": {
        "description": "Already chatting with persona",
        "placeholders": {
            "name": {"type": "String"}
        }
    },
    "cacheDeleteError": "Error deleting cache: {error}",
    "@cacheDeleteError": {
        "description": "Cache delete error",
        "placeholders": {
            "error": {"type": "String"}
        }
    },
    "unblockPersonaConfirm": "Unblock {name}?",
    "@unblockPersonaConfirm": {
        "description": "Unblock persona confirmation",
        "placeholders": {
            "name": {"type": "String"}
        }
    },
    "errorWithMessage": "Error occurred: {error}",
    "@errorWithMessage": {
        "description": "Error with message",
        "placeholders": {
            "error": {"type": "String"}
        }
    }
}

def update_arb_file(file_path, new_entries):
    """Update ARB file with new entries"""
    
    # Read existing file
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Add new entries
    data.update(new_entries)
    
    # Write back
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"Updated {file_path} with {len(new_entries)//2} parameterized strings")

def main():
    # Update Korean ARB
    update_arb_file("sona_app/lib/l10n/app_ko.arb", ko_parameterized)
    
    # Update English ARB
    update_arb_file("sona_app/lib/l10n/app_en.arb", en_parameterized)
    
    print("Parameterized methods added successfully!")

if __name__ == "__main__":
    main()