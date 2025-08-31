#!/usr/bin/env python3
"""
Fix hardcoded Korean text in service files.
"""

import os
import re

def fix_service_files():
    """Fix hardcoded Korean text in service files."""
    
    # File fixes mapping
    fixes = {
        "sona_app/lib/services/weather_context_service.dart": [
            # Weather conditions
            ("'맑음'", "'clear'"),
            ("'흐림'", "'cloudy'"),
            ("'비'", "'rainy'"),
            ("'눈'", "'snowy'"),
            ("'구름 많음'", "'partly_cloudy'"),
            ("'안개'", "'foggy'"),
            ("'폭염'", "'heat_wave'"),
            ("'한파'", "'cold_wave'"),
        ],
        "sona_app/lib/services/temporal_context_service.dart": [
            # Days of week
            ("'월요일'", "'monday'"),
            ("'화요일'", "'tuesday'"),
            ("'수요일'", "'wednesday'"),
            ("'목요일'", "'thursday'"),
            ("'금요일'", "'friday'"),
            ("'토요일'", "'saturday'"),
            ("'일요일'", "'sunday'"),
            # Seasons
            ("'봄'", "'spring'"),
            ("'여름'", "'summer'"),
            ("'가을'", "'autumn'"),
            ("'겨울'", "'winter'"),
            # Times
            ("'새벽'", "'dawn'"),
            ("'아침'", "'morning'"),
            ("'점심'", "'noon'"),
            ("'오후'", "'afternoon'"),
            ("'저녁'", "'evening'"),
            ("'밤'", "'night'"),
            ("'늦은 밤'", "'late_night'"),
            ("'자정'", "'midnight'"),
            # Holidays
            ("'새해'", "'new_year'"),
            ("'설날'", "'lunar_new_year'"),
            ("'발렌타인'", "'valentine'"),
            ("'화이트데이'", "'white_day'"),
            ("'어린이날'", "'children_day'"),
            ("'어버이날'", "'parents_day'"),
            ("'스승의날'", "'teacher_day'"),
            ("'크리스마스'", "'christmas'"),
            ("'연말'", "'year_end'"),
        ],
        "sona_app/lib/services/daily_care_service.dart": [
            # Meal times
            ("'아침 먹었어'", "'had_breakfast'"),
            ("'점심 먹었어'", "'had_lunch'"),
            ("'저녁 먹었어'", "'had_dinner'"),
            # Emotions
            ("'행복'", "'happy'"),
            ("'슬픔'", "'sad'"),
            ("'화남'", "'angry'"),
            ("'불안'", "'anxious'"),
            ("'스트레스'", "'stressed'"),
        ],
        "sona_app/lib/services/conflict_resolution_service.dart": [
            ("'갈등 유형'", "'conflict_type'"),
            ("'해결 제안'", "'resolution_suggestion'"),
        ],
        "sona_app/lib/services/memory_emotional_service.dart": [
            ("'감정 기억'", "'emotional_memory'"),
            ("'중요한 순간'", "'important_moment'"),
        ],
        "sona_app/lib/services/empathy_engine.dart": [
            ("'공감'", "'empathy'"),
            ("'위로'", "'comfort'"),
            ("'격려'", "'encouragement'"),
        ],
        "sona_app/lib/services/persona/persona_service.dart": [
            # Comments can stay in Korean but code strings should be keys
            ("errorMessage = '프로필 정보를 먼저 설정해주세요';", "errorMessage = 'profile_required';"),
            ("errorMessage = '잘못된 사용자 ID입니다';", "errorMessage = 'invalid_user_id';"),
            ("errorMessage = '사용자를 찾을 수 없습니다';", "errorMessage = 'user_not_found';"),
            ("errorMessage = '페르소나를 찾을 수 없습니다';", "errorMessage = 'persona_not_found';"),
        ],
        "sona_app/lib/services/chat/conflict_resolution_service.dart": [
            ("'화해'", "'reconciliation'"),
            ("'양보'", "'compromise'"),
            ("'대화'", "'dialogue'"),
        ],
        "sona_app/lib/services/emotional_support_service.dart": [
            ("'감정 지원'", "'emotional_support'"),
            ("'따뜻한 말'", "'warm_words'"),
        ],
        "sona_app/lib/services/chat/chat_service.dart": [
            # Comments are already fixed
            ("'대화를 불러오는 중 오류 발생'", "'error_loading_conversation'"),
        ],
        "sona_app/lib/services/api/api_service.dart": [
            ("'API 호출 실패'", "'api_call_failed'"),
            ("'네트워크 오류'", "'network_error'"),
        ],
        "sona_app/lib/services/api/cloudflare_api_service.dart": [
            ("'이미지 업로드 실패'", "'image_upload_failed'"),
        ],
        "sona_app/lib/services/api/openai_api_service.dart": [
            ("'응답 생성 실패'", "'response_generation_failed'"),
        ],
        "sona_app/lib/services/emotion_analyzer.dart": [
            ("'감정 분석'", "'emotion_analysis'"),
        ],
    }
    
    for file_path, replacements in fixes.items():
        if not os.path.exists(file_path):
            print(f"File not found: {file_path}")
            continue
            
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        for old_text, new_text in replacements:
            content = content.replace(old_text, new_text)
        
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"Fixed: {file_path}")
        else:
            print(f"No changes needed: {file_path}")

if __name__ == "__main__":
    fix_service_files()