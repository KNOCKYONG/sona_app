# Language Test Samples for SONA App

## All 21 Supported Languages Test Phrases

### 1. English (EN) 🇬🇧🇺🇸
- "Hello, how are you today?"
- "I'm tired from work"
- "Thanks for your help"
- "What time is it?"

### 2. Japanese (JA) 🇯🇵
- "こんにちは、元気ですか？"
- "今日は疲れました"
- "ありがとうございます"
- "何時ですか？"

### 3. Chinese (ZH) 🇨🇳
- "你好，今天怎么样？"
- "我很累"
- "谢谢你的帮助"
- "现在几点了？"

### 4. Spanish (ES) 🇪🇸🇲🇽
- "Hola, ¿cómo estás?"
- "Estoy cansado del trabajo"
- "Gracias por tu ayuda"
- "¿Qué hora es?"

### 5. French (FR) 🇫🇷
- "Bonjour, comment allez-vous?"
- "Je suis fatigué du travail"
- "Merci pour votre aide"
- "Quelle heure est-il?"

### 6. German (DE) 🇩🇪
- "Hallo, wie geht es dir?"
- "Ich bin müde von der Arbeit"
- "Danke für deine Hilfe"
- "Wie spät ist es?"

### 7. Italian (IT) 🇮🇹
- "Ciao, come stai?"
- "Sono stanco dal lavoro"
- "Grazie per il tuo aiuto"
- "Che ore sono?"

### 8. Portuguese (PT) 🇵🇹🇧🇷
- "Olá, como está?"
- "Estou cansado do trabalho"
- "Obrigado pela sua ajuda"
- "Que horas são?"

### 9. Russian (RU) 🇷🇺
- "Привет, как дела?"
- "Я устал от работы"
- "Спасибо за помощь"
- "Который час?"

### 10. Arabic (AR) 🇸🇦
- "مرحبا، كيف حالك؟"
- "أنا متعب من العمل"
- "شكرا لمساعدتك"
- "كم الساعة؟"

### 11. Thai (TH) 🇹🇭
- "สวัสดีครับ คุณสบายดีไหม"
- "ผมเหนื่อยจากการทำงาน"
- "ขอบคุณสำหรับความช่วยเหลือ"
- "ตอนนี้กี่โมงแล้ว"

### 12. Indonesian (ID) 🇮🇩
- "Halo, apa kabar?"
- "Aku lelah kerja lembur"
- "Terima kasih atas bantuannya"
- "Jam berapa sekarang?"

### 13. Malay (MS) 🇲🇾
- "Hai, apa khabar?"
- "Saya penat bekerja"
- "Terima kasih atas bantuan awak"
- "Pukul berapa sekarang?"

### 14. Vietnamese (VI) 🇻🇳
- "Xin chào, bạn khỏe không?"
- "Tôi mệt vì làm việc"
- "Cảm ơn bạn đã giúp đỡ"
- "Bây giờ là mấy giờ?"

### 15. Dutch (NL) 🇳🇱
- "Hallo, hoe gaat het?"
- "Ik ben moe van het werk"
- "Bedankt voor je hulp"
- "Hoe laat is het?"

### 16. Swedish (SV) 🇸🇪
- "Hej, hur mår du?"
- "Jag är trött från arbetet"
- "Tack för din hjälp"
- "Vad är klockan?"

### 17. Polish (PL) 🇵🇱
- "Cześć, jak się masz?"
- "Jestem zmęczony z pracy"
- "Dziękuję za pomoc"
- "Która godzina?"

### 18. Turkish (TR) 🇹🇷
- "Merhaba, nasılsın?"
- "İşten yorgunum"
- "Yardımın için teşekkürler"
- "Saat kaç?"

### 19. Hindi (HI) 🇮🇳
- "नमस्ते, आप कैसे हैं?"
- "मैं काम से थक गया हूं"
- "आपकी मदद के लिए धन्यवाद"
- "अभी कितने बजे हैं?"

### 20. Urdu (UR) 🇵🇰
- "السلام علیکم، آپ کیسے ہیں؟"
- "میں کام سے تھک گیا ہوں"
- "آپ کی مدد کے لیے شکریہ"
- "اب کتنے بجے ہیں؟"

### 21. Tagalog (TL) 🇵🇭
- "Kumusta ka?"
- "Pagod na ako sa trabaho"
- "Salamat sa tulong mo"
- "Anong oras na?"

## Expected Behavior

When a user types in any of these languages:

1. **Character Detection (Non-Latin scripts)**: Thai, Arabic, Hindi, Chinese, Japanese, Russian, Urdu should be detected immediately by their unique character sets
2. **Keyword Detection (Latin scripts)**: English, Spanish, French, German, Italian, Portuguese, Dutch, Swedish, Polish, Turkish, Vietnamese, Indonesian, Malay, Tagalog detected by keywords
3. **Translation Toggle**: Should automatically appear when non-Korean language is detected
4. **Response Format**: AI should respond with `[KO] (Korean response) [DETECTED_LANG] (response in user's language)`

## Testing Checklist

- [ ] Korean input → No translation toggle
- [ ] English input → Translation toggle appears, [KO] and [EN] tags in response
- [ ] Japanese input → Translation toggle appears, [KO] and [JA] tags in response
- [ ] Chinese input → Translation toggle appears, [KO] and [ZH] tags in response
- [ ] Spanish input → Translation toggle appears, [KO] and [ES] tags in response
- [ ] French input → Translation toggle appears, [KO] and [FR] tags in response
- [ ] German input → Translation toggle appears, [KO] and [DE] tags in response
- [ ] Italian input → Translation toggle appears, [KO] and [IT] tags in response
- [ ] Portuguese input → Translation toggle appears, [KO] and [PT] tags in response
- [ ] Russian input → Translation toggle appears, [KO] and [RU] tags in response
- [ ] Arabic input → Translation toggle appears, [KO] and [AR] tags in response
- [ ] Thai input → Translation toggle appears, [KO] and [TH] tags in response
- [ ] Indonesian input → Translation toggle appears, [KO] and [ID] tags in response
- [ ] Malay input → Translation toggle appears, [KO] and [MS] tags in response
- [ ] Vietnamese input → Translation toggle appears, [KO] and [VI] tags in response
- [ ] Dutch input → Translation toggle appears, [KO] and [NL] tags in response
- [ ] Swedish input → Translation toggle appears, [KO] and [SV] tags in response
- [ ] Polish input → Translation toggle appears, [KO] and [PL] tags in response
- [ ] Turkish input → Translation toggle appears, [KO] and [TR] tags in response
- [ ] Hindi input → Translation toggle appears, [KO] and [HI] tags in response
- [ ] Urdu input → Translation toggle appears, [KO] and [UR] tags in response
- [ ] Tagalog input → Translation toggle appears, [KO] and [TL] tags in response

## Translation Error Report Test

After sending messages in different languages:
1. Open chat menu → "번역 오류 신고" (Report Translation Error)
2. Should show recent messages with translations
3. Should allow selecting problematic message
4. Should submit error report successfully