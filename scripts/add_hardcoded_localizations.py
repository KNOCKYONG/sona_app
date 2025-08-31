#!/usr/bin/env python3
"""
Add localization keys for all hardcoded Korean text found in the codebase.
"""

import json
import os

def add_localization_keys():
    """Add all necessary localization keys to ARB files."""
    
    # New keys to add for all hardcoded Korean text
    new_keys = {
        # Emotions (from modern_emotion_picker.dart)
        "emotionHappy": {
            "en": "Happy",
            "ko": "행복"
        },
        "emotionLove": {
            "en": "Love",
            "ko": "사랑"
        },
        "emotionSad": {
            "en": "Sad",
            "ko": "슬픔"
        },
        "emotionAngry": {
            "en": "Angry",
            "ko": "화남"
        },
        "emotionCool": {
            "en": "Cool",
            "ko": "쿨함"
        },
        "emotionThinking": {
            "en": "Thinking",
            "ko": "생각"
        },
        "selectEmotion": {
            "en": "Select Emotion",
            "ko": "감정 선택"
        },
        
        # UI Instructions (from tip_card.dart, persona_profile_viewer.dart)
        "swipeAnyDirection": {
            "en": "Swipe in any direction",
            "ko": "아무 방향으로나 스와이프하세요"
        },
        "swipeDownToClose": {
            "en": "Swipe down to close",
            "ko": "아래로 스와이프하여 닫기"
        },
        "tapForDetails": {
            "en": "Tap bottom area for details",
            "ko": "하단 영역을 탭하여 상세 정보 보기"
        },
        "personality": {
            "en": "Personality",
            "ko": "성격"
        },
        
        # Weather conditions (from weather_context_service.dart)
        "weatherClear": {
            "en": "Clear",
            "ko": "맑음"
        },
        "weatherCloudy": {
            "en": "Cloudy",
            "ko": "흐림"
        },
        "weatherRain": {
            "en": "Rain",
            "ko": "비"
        },
        "weatherDrizzle": {
            "en": "Drizzle",
            "ko": "이슬비"
        },
        "weatherThunderstorm": {
            "en": "Thunderstorm",
            "ko": "뇌우"
        },
        "weatherSnow": {
            "en": "Snow",
            "ko": "눈"
        },
        "weatherMist": {
            "en": "Mist",
            "ko": "안개"
        },
        "weatherFog": {
            "en": "Fog",
            "ko": "짙은 안개"
        },
        
        # Days of week (from temporal_context_service.dart)
        "monday": {
            "en": "Monday",
            "ko": "월요일"
        },
        "tuesday": {
            "en": "Tuesday",
            "ko": "화요일"
        },
        "wednesday": {
            "en": "Wednesday",
            "ko": "수요일"
        },
        "thursday": {
            "en": "Thursday",
            "ko": "목요일"
        },
        "friday": {
            "en": "Friday",
            "ko": "금요일"
        },
        "saturday": {
            "en": "Saturday",
            "ko": "토요일"
        },
        "sunday": {
            "en": "Sunday",
            "ko": "일요일"
        },
        
        # Time periods (from temporal_context_service.dart)
        "morning": {
            "en": "Morning",
            "ko": "아침"
        },
        "forenoon": {
            "en": "Forenoon",
            "ko": "오전"
        },
        "lunchtime": {
            "en": "Lunchtime",
            "ko": "점심시간"
        },
        "afternoon": {
            "en": "Afternoon",
            "ko": "오후"
        },
        "evening": {
            "en": "Evening",
            "ko": "저녁"
        },
        "night": {
            "en": "Night",
            "ko": "밤"
        },
        "dawn": {
            "en": "Dawn",
            "ko": "새벽"
        },
        
        # Seasons (from temporal_context_service.dart)
        "spring": {
            "en": "Spring",
            "ko": "봄"
        },
        "summer": {
            "en": "Summer",
            "ko": "여름"
        },
        "autumn": {
            "en": "Autumn",
            "ko": "가을"
        },
        "winter": {
            "en": "Winter",
            "ko": "겨울"
        },
        
        # Meals (from daily_care_service.dart)
        "breakfast": {
            "en": "Breakfast",
            "ko": "아침식사"
        },
        "lunch": {
            "en": "Lunch",
            "ko": "점심식사"
        },
        "dinner": {
            "en": "Dinner",
            "ko": "저녁식사"
        },
        "preparingForSleep": {
            "en": "Preparing for sleep",
            "ko": "수면준비"
        },
        "lateNight": {
            "en": "Late night",
            "ko": "늦은시간"
        },
        "afternoonFatigue": {
            "en": "Afternoon fatigue",
            "ko": "오후피로"
        },
        "dailyCheck": {
            "en": "Daily check",
            "ko": "일상체크"
        },
        
        # Error and system messages
        "unknownError": {
            "en": "An unknown error occurred",
            "ko": "알 수 없는 오류가 발생했습니다"
        },
        "guest": {
            "en": "Guest",
            "ko": "게스트"
        },
        "filter": {
            "en": "Filter",
            "ko": "필터"
        },
        "current": {
            "en": "Current",
            "ko": "현재"
        },
        "koreanLanguage": {
            "en": "Korean",
            "ko": "한국어"
        },
        "retryButton": {
            "en": "Retry",
            "ko": "재시도"
        },
        
        # Error dashboard specific
        "errorMessage": {
            "en": "Error Message:",
            "ko": "에러 메시지:"
        },
        "userMessage": {
            "en": "User Message:",
            "ko": "사용자 메시지:"
        },
        "recentConversation": {
            "en": "Recent Conversation:",
            "ko": "최근 대화:"
        },
        "user": {
            "en": "User: ",
            "ko": "사용자: "
        },
        "occurrenceInfo": {
            "en": "Occurrence Info:",
            "ko": "발생 정보:"
        },
        "firstOccurred": {
            "en": "First Occurred: ",
            "ko": "첫 발생: "
        },
        "lastOccurred": {
            "en": "Last Occurred: ",
            "ko": "마지막 발생: "
        },
        "totalOccurrences": {
            "en": "Total {count} occurrences",
            "ko": "총 {count}회 발생"
        },
        "errorFrequency24h": {
            "en": "Error Frequency (Last 24 hours)",
            "ko": "에러 발생 빈도 (최근 24시간)"
        },
        "hours24Ago": {
            "en": "24 hours ago",
            "ko": "24시간 전"
        },
        "apiKeyError": {
            "en": "API Key Error",
            "ko": "API 키 오류"
        },
        
        # Login screen specific
        "passwordText": {
            "en": "password",
            "ko": "비밀번호"
        },
        "notRegistered": {
            "en": "not registered",
            "ko": "등록되지 않은"
        },
        "incorrect": {
            "en": "incorrect",
            "ko": "올바르지 않습니다"
        },
        
        # Splash screen specific
        "matchedPersonas": {
            "en": "Matched Personas",
            "ko": "매칭된 페르소나"
        },
        
        # Time relative
        "todayText": {
            "en": "Today",
            "ko": "오늘"
        },
        "tomorrowText": {
            "en": "Tomorrow",
            "ko": "내일"
        },
        "dayAfterTomorrow": {
            "en": "Day after tomorrow",
            "ko": "모레"
        },
        
        # Cities
        "seoul": {
            "en": "Seoul",
            "ko": "서울"
        },
        
        # Activities
        "walk": {
            "en": "Walk",
            "ko": "산책"
        },
        "picnic": {
            "en": "Picnic",
            "ko": "피크닉"
        },
        "cycling": {
            "en": "Cycling",
            "ko": "자전거"
        },
        "cafeTerrace": {
            "en": "Cafe terrace",
            "ko": "카페 테라스"
        },
        
        # Holidays (from temporal_context_service.dart)
        "newYear": {
            "en": "New Year",
            "ko": "새해"
        },
        "valentinesDay": {
            "en": "Valentine's Day",
            "ko": "발렌타인데이"
        },
        "whiteDay": {
            "en": "White Day",
            "ko": "화이트데이"
        },
        "childrensDay": {
            "en": "Children's Day",
            "ko": "어린이날"
        },
        "parentsDay": {
            "en": "Parents' Day",
            "ko": "어버이날"
        },
        "teachersDay": {
            "en": "Teachers' Day",
            "ko": "스승의날"
        },
        "christmas": {
            "en": "Christmas",
            "ko": "크리스마스"
        },
        "yearEnd": {
            "en": "Year End",
            "ko": "연말"
        }
    }
    
    # Languages to update
    languages = ['en', 'ko', 'ja', 'zh', 'es', 'fr', 'de', 'it', 'pt', 'ru', 'id', 'th', 'vi']
    
    # Process each language
    for lang in languages:
        arb_path = f"sona_app/lib/l10n/app_{lang}.arb"
        
        if not os.path.exists(arb_path):
            print(f"Skipping {lang}: file not found")
            continue
            
        # Read existing ARB file
        with open(arb_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Add new keys
        added_count = 0
        for key, translations in new_keys.items():
            if key not in data:
                # Use Korean for Korean, English for others if not specified
                if lang == 'ko':
                    data[key] = translations.get('ko', translations.get('en', key))
                elif lang == 'en':
                    data[key] = translations.get('en', key)
                else:
                    # For other languages, use English temporarily (will translate later)
                    data[key] = translations.get('en', key)
                
                # Add description
                data[f"@{key}"] = {
                    "description": f"Localized string for {key}"
                }
                added_count += 1
        
        # Write back
        with open(arb_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        
        print(f"Updated {lang}: added {added_count} keys")
    
    print("\nDone! Now run: cd sona_app && flutter gen-l10n")

if __name__ == "__main__":
    add_localization_keys()