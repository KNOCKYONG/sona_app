#!/usr/bin/env python3
"""
Translate all new localization keys to 13 languages.
"""

import json
import os

def translate_new_keys():
    """Translate all new localization keys to 13 languages."""
    
    # Translations for all new keys
    translations = {
        # Emotions
        "emotionHappy": {
            "ko": "행복",
            "en": "Happy",
            "ja": "幸せ",
            "zh": "快乐",
            "es": "Feliz",
            "fr": "Heureux",
            "de": "Glücklich",
            "it": "Felice",
            "pt": "Feliz",
            "ru": "Счастливый",
            "id": "Bahagia",
            "th": "มีความสุข",
            "vi": "Hạnh phúc"
        },
        "emotionLove": {
            "ko": "사랑",
            "en": "Love",
            "ja": "愛",
            "zh": "爱",
            "es": "Amor",
            "fr": "Amour",
            "de": "Liebe",
            "it": "Amore",
            "pt": "Amor",
            "ru": "Любовь",
            "id": "Cinta",
            "th": "รัก",
            "vi": "Yêu"
        },
        "emotionSad": {
            "ko": "슬픔",
            "en": "Sad",
            "ja": "悲しい",
            "zh": "悲伤",
            "es": "Triste",
            "fr": "Triste",
            "de": "Traurig",
            "it": "Triste",
            "pt": "Triste",
            "ru": "Грустный",
            "id": "Sedih",
            "th": "เศร้า",
            "vi": "Buồn"
        },
        "emotionAngry": {
            "ko": "화남",
            "en": "Angry",
            "ja": "怒り",
            "zh": "生气",
            "es": "Enojado",
            "fr": "En colère",
            "de": "Wütend",
            "it": "Arrabbiato",
            "pt": "Bravo",
            "ru": "Злой",
            "id": "Marah",
            "th": "โกรธ",
            "vi": "Giận"
        },
        "emotionCool": {
            "ko": "쿨함",
            "en": "Cool",
            "ja": "クール",
            "zh": "酷",
            "es": "Genial",
            "fr": "Cool",
            "de": "Cool",
            "it": "Figo",
            "pt": "Legal",
            "ru": "Крутой",
            "id": "Keren",
            "th": "เท่",
            "vi": "Ngầu"
        },
        "emotionThinking": {
            "ko": "생각",
            "en": "Thinking",
            "ja": "考える",
            "zh": "思考",
            "es": "Pensando",
            "fr": "Pensif",
            "de": "Nachdenklich",
            "it": "Pensieroso",
            "pt": "Pensativo",
            "ru": "Задумчивый",
            "id": "Berpikir",
            "th": "คิด",
            "vi": "Suy nghĩ"
        },
        
        # Weather
        "weatherClear": {
            "ko": "맑음",
            "en": "Clear",
            "ja": "晴れ",
            "zh": "晴朗",
            "es": "Despejado",
            "fr": "Clair",
            "de": "Klar",
            "it": "Sereno",
            "pt": "Limpo",
            "ru": "Ясно",
            "id": "Cerah",
            "th": "แจ่มใส",
            "vi": "Quang đãng"
        },
        "weatherCloudy": {
            "ko": "흐림",
            "en": "Cloudy",
            "ja": "曇り",
            "zh": "多云",
            "es": "Nublado",
            "fr": "Nuageux",
            "de": "Bewölkt",
            "it": "Nuvoloso",
            "pt": "Nublado",
            "ru": "Облачно",
            "id": "Berawan",
            "th": "มีเมฆมาก",
            "vi": "Nhiều mây"
        },
        "weatherRainy": {
            "ko": "비",
            "en": "Rainy",
            "ja": "雨",
            "zh": "下雨",
            "es": "Lluvioso",
            "fr": "Pluvieux",
            "de": "Regnerisch",
            "it": "Piovoso",
            "pt": "Chuvoso",
            "ru": "Дождливо",
            "id": "Hujan",
            "th": "ฝนตก",
            "vi": "Mưa"
        },
        "weatherSnowy": {
            "ko": "눈",
            "en": "Snowy",
            "ja": "雪",
            "zh": "下雪",
            "es": "Nevado",
            "fr": "Neigeux",
            "de": "Schneeig",
            "it": "Nevoso",
            "pt": "Nevado",
            "ru": "Снежно",
            "id": "Bersalju",
            "th": "หิมะตก",
            "vi": "Tuyết"
        },
        
        # Days of week
        "monday": {
            "ko": "월요일",
            "en": "Monday",
            "ja": "月曜日",
            "zh": "星期一",
            "es": "Lunes",
            "fr": "Lundi",
            "de": "Montag",
            "it": "Lunedì",
            "pt": "Segunda-feira",
            "ru": "Понедельник",
            "id": "Senin",
            "th": "วันจันทร์",
            "vi": "Thứ Hai"
        },
        "tuesday": {
            "ko": "화요일",
            "en": "Tuesday",
            "ja": "火曜日",
            "zh": "星期二",
            "es": "Martes",
            "fr": "Mardi",
            "de": "Dienstag",
            "it": "Martedì",
            "pt": "Terça-feira",
            "ru": "Вторник",
            "id": "Selasa",
            "th": "วันอังคาร",
            "vi": "Thứ Ba"
        },
        "wednesday": {
            "ko": "수요일",
            "en": "Wednesday",
            "ja": "水曜日",
            "zh": "星期三",
            "es": "Miércoles",
            "fr": "Mercredi",
            "de": "Mittwoch",
            "it": "Mercoledì",
            "pt": "Quarta-feira",
            "ru": "Среда",
            "id": "Rabu",
            "th": "วันพุธ",
            "vi": "Thứ Tư"
        },
        "thursday": {
            "ko": "목요일",
            "en": "Thursday",
            "ja": "木曜日",
            "zh": "星期四",
            "es": "Jueves",
            "fr": "Jeudi",
            "de": "Donnerstag",
            "it": "Giovedì",
            "pt": "Quinta-feira",
            "ru": "Четверг",
            "id": "Kamis",
            "th": "วันพฤหัสบดี",
            "vi": "Thứ Năm"
        },
        "friday": {
            "ko": "금요일",
            "en": "Friday",
            "ja": "金曜日",
            "zh": "星期五",
            "es": "Viernes",
            "fr": "Vendredi",
            "de": "Freitag",
            "it": "Venerdì",
            "pt": "Sexta-feira",
            "ru": "Пятница",
            "id": "Jumat",
            "th": "วันศุกร์",
            "vi": "Thứ Sáu"
        },
        "saturday": {
            "ko": "토요일",
            "en": "Saturday",
            "ja": "土曜日",
            "zh": "星期六",
            "es": "Sábado",
            "fr": "Samedi",
            "de": "Samstag",
            "it": "Sabato",
            "pt": "Sábado",
            "ru": "Суббота",
            "id": "Sabtu",
            "th": "วันเสาร์",
            "vi": "Thứ Bảy"
        },
        "sunday": {
            "ko": "일요일",
            "en": "Sunday",
            "ja": "日曜日",
            "zh": "星期日",
            "es": "Domingo",
            "fr": "Dimanche",
            "de": "Sonntag",
            "it": "Domenica",
            "pt": "Domingo",
            "ru": "Воскресенье",
            "id": "Minggu",
            "th": "วันอาทิตย์",
            "vi": "Chủ Nhật"
        },
        
        # Seasons
        "spring": {
            "ko": "봄",
            "en": "Spring",
            "ja": "春",
            "zh": "春天",
            "es": "Primavera",
            "fr": "Printemps",
            "de": "Frühling",
            "it": "Primavera",
            "pt": "Primavera",
            "ru": "Весна",
            "id": "Musim Semi",
            "th": "ฤดูใบไม้ผลิ",
            "vi": "Mùa xuân"
        },
        "summer": {
            "ko": "여름",
            "en": "Summer",
            "ja": "夏",
            "zh": "夏天",
            "es": "Verano",
            "fr": "Été",
            "de": "Sommer",
            "it": "Estate",
            "pt": "Verão",
            "ru": "Лето",
            "id": "Musim Panas",
            "th": "ฤดูร้อน",
            "vi": "Mùa hè"
        },
        "autumn": {
            "ko": "가을",
            "en": "Autumn",
            "ja": "秋",
            "zh": "秋天",
            "es": "Otoño",
            "fr": "Automne",
            "de": "Herbst",
            "it": "Autunno",
            "pt": "Outono",
            "ru": "Осень",
            "id": "Musim Gugur",
            "th": "ฤดูใบไม้ร่วง",
            "vi": "Mùa thu"
        },
        "winter": {
            "ko": "겨울",
            "en": "Winter",
            "ja": "冬",
            "zh": "冬天",
            "es": "Invierno",
            "fr": "Hiver",
            "de": "Winter",
            "it": "Inverno",
            "pt": "Inverno",
            "ru": "Зима",
            "id": "Musim Dingin",
            "th": "ฤดูหนาว",
            "vi": "Mùa đông"
        },
        
        # Times of day
        "morning": {
            "ko": "아침",
            "en": "Morning",
            "ja": "朝",
            "zh": "早晨",
            "es": "Mañana",
            "fr": "Matin",
            "de": "Morgen",
            "it": "Mattina",
            "pt": "Manhã",
            "ru": "Утро",
            "id": "Pagi",
            "th": "เช้า",
            "vi": "Buổi sáng"
        },
        "afternoon": {
            "ko": "오후",
            "en": "Afternoon",
            "ja": "午後",
            "zh": "下午",
            "es": "Tarde",
            "fr": "Après-midi",
            "de": "Nachmittag",
            "it": "Pomeriggio",
            "pt": "Tarde",
            "ru": "День",
            "id": "Siang",
            "th": "บ่าย",
            "vi": "Buổi chiều"
        },
        "evening": {
            "ko": "저녁",
            "en": "Evening",
            "ja": "夕方",
            "zh": "傍晚",
            "es": "Noche",
            "fr": "Soir",
            "de": "Abend",
            "it": "Sera",
            "pt": "Noite",
            "ru": "Вечер",
            "id": "Sore",
            "th": "เย็น",
            "vi": "Buổi tối"
        },
        "night": {
            "ko": "밤",
            "en": "Night",
            "ja": "夜",
            "zh": "夜晚",
            "es": "Noche",
            "fr": "Nuit",
            "de": "Nacht",
            "it": "Notte",
            "pt": "Noite",
            "ru": "Ночь",
            "id": "Malam",
            "th": "กลางคืน",
            "vi": "Đêm"
        },
        
        # UI Instructions
        "swipeDownToClose": {
            "ko": "아래로 스와이프하여 닫기",
            "en": "Swipe down to close",
            "ja": "下にスワイプして閉じる",
            "zh": "向下滑动关闭",
            "es": "Desliza hacia abajo para cerrar",
            "fr": "Glissez vers le bas pour fermer",
            "de": "Nach unten wischen zum Schließen",
            "it": "Scorri verso il basso per chiudere",
            "pt": "Deslize para baixo para fechar",
            "ru": "Проведите вниз, чтобы закрыть",
            "id": "Geser ke bawah untuk menutup",
            "th": "ปัดลงเพื่อปิด",
            "vi": "Vuốt xuống để đóng"
        },
        "tapBottomForDetails": {
            "ko": "하단 영역을 탭하여 상세 정보 보기",
            "en": "Tap bottom area to see details",
            "ja": "詳細を見るには下部をタップ",
            "zh": "点击底部查看详情",
            "es": "Toca la parte inferior para ver detalles",
            "fr": "Appuyez en bas pour voir les détails",
            "de": "Unten tippen für Details",
            "it": "Tocca in basso per i dettagli",
            "pt": "Toque na parte inferior para ver detalhes",
            "ru": "Нажмите внизу для подробностей",
            "id": "Ketuk bagian bawah untuk detail",
            "th": "แตะด้านล่างเพื่อดูรายละเอียด",
            "vi": "Chạm phía dưới để xem chi tiết"
        },
        "swipeAnyDirection": {
            "ko": "아무 방향으로나 스와이프하세요",
            "en": "Swipe in any direction",
            "ja": "どの方向にでもスワイプしてください",
            "zh": "向任意方向滑动",
            "es": "Desliza en cualquier dirección",
            "fr": "Glissez dans n'importe quelle direction",
            "de": "In beliebige Richtung wischen",
            "it": "Scorri in qualsiasi direzione",
            "pt": "Deslize em qualquer direção",
            "ru": "Проведите в любом направлении",
            "id": "Geser ke arah mana saja",
            "th": "ปัดไปทางใดก็ได้",
            "vi": "Vuốt theo bất kỳ hướng nào"
        },
        
        # Common actions
        "cancel": {
            "ko": "취소",
            "en": "Cancel",
            "ja": "キャンセル",
            "zh": "取消",
            "es": "Cancelar",
            "fr": "Annuler",
            "de": "Abbrechen",
            "it": "Annulla",
            "pt": "Cancelar",
            "ru": "Отмена",
            "id": "Batal",
            "th": "ยกเลิก",
            "vi": "Hủy"
        },
        "retry": {
            "ko": "재시도",
            "en": "Retry",
            "ja": "再試行",
            "zh": "重试",
            "es": "Reintentar",
            "fr": "Réessayer",
            "de": "Wiederholen",
            "it": "Riprova",
            "pt": "Tentar novamente",
            "ru": "Повторить",
            "id": "Coba lagi",
            "th": "ลองอีกครั้ง",
            "vi": "Thử lại"
        },
        
        # Error messages
        "filter": {
            "ko": "필터",
            "en": "Filter",
            "ja": "フィルター",
            "zh": "筛选",
            "es": "Filtro",
            "fr": "Filtre",
            "de": "Filter",
            "it": "Filtro",
            "pt": "Filtro",
            "ru": "Фильтр",
            "id": "Filter",
            "th": "ตัวกรอง",
            "vi": "Bộ lọc"
        },
        "current": {
            "ko": "현재",
            "en": "Current",
            "ja": "現在",
            "zh": "当前",
            "es": "Actual",
            "fr": "Actuel",
            "de": "Aktuell",
            "it": "Attuale",
            "pt": "Atual",
            "ru": "Текущий",
            "id": "Saat ini",
            "th": "ปัจจุบัน",
            "vi": "Hiện tại"
        },
        "errorMessage": {
            "ko": "에러 메시지:",
            "en": "Error message:",
            "ja": "エラーメッセージ:",
            "zh": "错误信息:",
            "es": "Mensaje de error:",
            "fr": "Message d'erreur:",
            "de": "Fehlermeldung:",
            "it": "Messaggio di errore:",
            "pt": "Mensagem de erro:",
            "ru": "Сообщение об ошибке:",
            "id": "Pesan kesalahan:",
            "th": "ข้อความแสดงข้อผิดพลาด:",
            "vi": "Thông báo lỗi:"
        },
        "userMessage": {
            "ko": "사용자 메시지:",
            "en": "User message:",
            "ja": "ユーザーメッセージ:",
            "zh": "用户消息:",
            "es": "Mensaje del usuario:",
            "fr": "Message de l'utilisateur:",
            "de": "Benutzernachricht:",
            "it": "Messaggio utente:",
            "pt": "Mensagem do usuário:",
            "ru": "Сообщение пользователя:",
            "id": "Pesan pengguna:",
            "th": "ข้อความผู้ใช้:",
            "vi": "Tin nhắn người dùng:"
        },
        "recentConversation": {
            "ko": "최근 대화:",
            "en": "Recent conversation:",
            "ja": "最近の会話:",
            "zh": "最近对话:",
            "es": "Conversación reciente:",
            "fr": "Conversation récente:",
            "de": "Neueste Unterhaltung:",
            "it": "Conversazione recente:",
            "pt": "Conversa recente:",
            "ru": "Недавний разговор:",
            "id": "Percakapan terbaru:",
            "th": "การสนทนาล่าสุด:",
            "vi": "Cuộc trò chuyện gần đây:"
        }
    }
    
    # Language codes
    languages = ["ko", "en", "ja", "zh", "es", "fr", "de", "it", "pt", "ru", "id", "th", "vi"]
    
    # Update each ARB file
    for lang in languages:
        arb_file = f"lib/l10n/app_{lang}.arb"
        
        if not os.path.exists(arb_file):
            print(f"WARNING: {arb_file} not found")
            continue
            
        # Read existing file
        with open(arb_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Add new translations
        updated = False
        for key, trans in translations.items():
            if key not in data and lang in trans:
                data[key] = trans[lang]
                updated = True
        
        # Write back if updated
        if updated:
            with open(arb_file, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
            print(f"Updated: {arb_file}")
        else:
            print(f"No changes needed: {arb_file}")
    
    print("\nTranslation complete!")
    print("Remember to run: flutter gen-l10n")

if __name__ == "__main__":
    translate_new_keys()