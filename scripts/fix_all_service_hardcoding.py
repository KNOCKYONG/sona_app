#!/usr/bin/env python3
"""
Fix all hardcoded Korean text in service files.
"""

import os
import re

def fix_all_service_files():
    """Fix hardcoded Korean text in all service files."""
    
    # Map of files and their Korean strings to replace
    replacements = {
        # Weather context service
        "lib/services/context/weather_context_service.dart": [
            ("'맑음'", "'clear'"),
            ("'흐림'", "'cloudy'"),
            ("'비'", "'rainy'"),
            ("'눈'", "'snowy'"),
            ("'이슬비'", "'drizzle'"),
            ("'뇌우'", "'thunderstorm'"),
            ("'안개'", "'fog'"),
            ("'짙은 안개'", "'thick_fog'"),
            ("'구름 조금'", "'partly_cloudy'"),
            ("'비 오는데 우산 챙기셨어요?'", "'Did you bring an umbrella?'"),
            ("'눈 오는 거 보셨어요? 예쁘네요'", "'Did you see the snow? It looks pretty'"),
            ("'너무 더운데 시원하게 지내고 계세요?'", "'It is hot, are you staying cool?'"),
            ("'많이 춥죠? 따뜻하게 입으셨어요?'", "'It is cold, are you dressed warmly?'"),
        ],
        
        # Temporal context service
        "lib/services/context/temporal_context_service.dart": [
            ("'아침'", "'morning'"),
            ("'점심'", "'noon'"),
            ("'오후'", "'afternoon'"),
            ("'저녁'", "'evening'"),
            ("'밤'", "'night'"),
            ("'새벽'", "'dawn'"),
            ("'출근'", "'commute'"),
            ("'등교'", "'school'"),
            ("'아침식사'", "'breakfast'"),
            ("'운동'", "'exercise'"),
            ("'준비'", "'preparation'"),
            ("'월요일'", "'Monday'"),
            ("'화요일'", "'Tuesday'"),
            ("'수요일'", "'Wednesday'"),
            ("'목요일'", "'Thursday'"),
            ("'금요일'", "'Friday'"),
            ("'토요일'", "'Saturday'"),
            ("'일요일'", "'Sunday'"),
            ("'봄'", "'spring'"),
            ("'여름'", "'summer'"),
            ("'가을'", "'autumn'"),
            ("'겨울'", "'winter'"),
        ],
        
        # Daily care service
        "lib/services/care/daily_care_service.dart": [
            ("'아침 먹었어'", "'had_breakfast'"),
            ("'점심 먹었어'", "'had_lunch'"),
            ("'저녁 먹었어'", "'had_dinner'"),
            ("'간식'", "'snack'"),
            ("'식사'", "'meal'"),
        ],
        
        # Conflict resolution service  
        "lib/services/conflict/conflict_resolution_service.dart": [
            ("'갈등'", "'conflict'"),
            ("'해결'", "'resolution'"),
            ("'화해'", "'reconciliation'"),
            ("'양보'", "'compromise'"),
            ("'대화'", "'dialogue'"),
        ],
        
        # Persona service
        "lib/services/persona/persona_service.dart": [
            ("'프로필 정보를 먼저 설정해주세요'", "'Please set up your profile first'"),
            ("'잘못된 사용자 ID입니다'", "'Invalid user ID'"),
            ("'사용자를 찾을 수 없습니다'", "'User not found'"),
            ("'페르소나를 찾을 수 없습니다'", "'Persona not found'"),
        ],
        
        # Chat service
        "lib/services/chat/core/chat_service.dart": [
            ("'대화를 불러오는 중 오류 발생'", "'Error loading conversation'"),
            ("'메시지 전송 실패'", "'Failed to send message'"),
        ],
        
        # OpenAI service
        "lib/services/chat/core/openai_service.dart": [
            ("'응답 생성 실패'", "'Failed to generate response'"),
            ("'API 호출 실패'", "'API call failed'"),
        ],
        
        # Advanced pattern analyzer
        "lib/services/chat/analysis/advanced_pattern_analyzer.dart": [
            ("'사랑'", "'love'"),
            ("'행복'", "'happy'"),
            ("'슬픔'", "'sad'"),
            ("'화남'", "'angry'"),
            ("'불안'", "'anxious'"),
        ],
        
        # Emotion recognition service
        "lib/services/chat/analysis/emotion_recognition_service.dart": [
            ("'감정'", "'emotion'"),
            ("'기분'", "'mood'"),
            ("'상태'", "'state'"),
        ],
        
        # Memory services
        "lib/services/memory/memory_album_service.dart": [
            ("'추억'", "'memory'"),
            ("'기억'", "'remember'"),
            ("'순간'", "'moment'"),
        ],
        
        # Error handling
        "lib/services/chat/utils/error_recovery_service.dart": [
            ("'오류 발생'", "'Error occurred'"),
            ("'재시도'", "'Retry'"),
            ("'복구'", "'Recovery'"),
        ],
    }
    
    # Process each file
    for file_path, strings_to_replace in replacements.items():
        if not os.path.exists(file_path):
            print(f"WARNING: File not found: {file_path}")
            continue
            
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            original_content = content
            changes_made = []
            
            for old_text, new_text in strings_to_replace:
                if old_text in content:
                    content = content.replace(old_text, new_text)
                    changes_made.append(f"  - {old_text} → {new_text}")
            
            if content != original_content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"FIXED: {file_path}")
                for change in changes_made:
                    print(change)
            else:
                print(f"OK: No changes needed: {file_path}")
                
        except Exception as e:
            print(f"ERROR processing {file_path}: {e}")
    
    print("\n" + "="*60)
    print("Service file hardcoding fix complete!")
    print("="*60)

if __name__ == "__main__":
    fix_all_service_files()