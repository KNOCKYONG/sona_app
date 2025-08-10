#!/usr/bin/env python3
"""
chat_orchestrator.dart 파일에서 4373번 라인 이후의 중복 코드를 제거하는 스크립트
"""

def clean_file():
    input_file = r"C:\Users\yong\sonaapp\sona_app\lib\services\chat\core\chat_orchestrator.dart"
    
    # 파일 읽기
    with open(input_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    # 4373번 라인까지만 유지 (인덱스는 4372)
    cleaned_lines = lines[:4373]
    
    # 파일 쓰기
    with open(input_file, 'w', encoding='utf-8') as f:
        f.writelines(cleaned_lines)
    
    print(f"File cleaned successfully. Total lines: {len(cleaned_lines)}")
    print(f"Removed lines: {len(lines) - len(cleaned_lines)}")

if __name__ == "__main__":
    clean_file()