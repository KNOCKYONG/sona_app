#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Complete remaining translations for all languages
"""

import json
import os

# Remaining translations for languages with 5 missing keys
remaining_5_keys = {
    'de': {  # German
        'mbtiComplete': 'Persönlichkeitstest abgeschlossen!',
        'mbtiQuestion': 'Persönlichkeitsfrage',
        'mbtiStepDescription': 'Lassen Sie uns bestimmen, welche Persönlichkeit Ihre Persona haben soll. Beantworten Sie Fragen, um ihren Charakter zu formen.',
        'shareDescription': 'Ihre Persona kann nach Genehmigung mit anderen Benutzern geteilt werden',
        'startTest': 'Test starten'
    },
    'fr': {  # French
        'mbtiComplete': 'Test de personnalité terminé!',
        'mbtiQuestion': 'Question de personnalité',
        'mbtiStepDescription': 'Déterminons quelle personnalité votre persona devrait avoir. Répondez aux questions pour façonner son caractère.',
        'shareDescription': 'Votre persona peut être partagé avec d\'autres utilisateurs après approbation',
        'startTest': 'Commencer le test'
    },
    'it': {  # Italian
        'mbtiComplete': 'Test di personalità completato!',
        'mbtiQuestion': 'Domanda sulla personalità',
        'mbtiStepDescription': 'Determiniamo quale personalità dovrebbe avere il tuo persona. Rispondi alle domande per modellare il suo carattere.',
        'shareDescription': 'Il tuo persona può essere condiviso con altri utenti dopo l\'approvazione',
        'startTest': 'Inizia il test'
    },
    'pt': {  # Portuguese
        'mbtiComplete': 'Teste de personalidade concluído!',
        'mbtiQuestion': 'Pergunta de personalidade',
        'mbtiStepDescription': 'Vamos determinar qual personalidade sua persona deve ter. Responda às perguntas para moldar seu caráter.',
        'shareDescription': 'Sua persona pode ser compartilhada com outros usuários após aprovação',
        'startTest': 'Iniciar teste'
    },
    'ru': {  # Russian
        'mbtiComplete': 'Тест личности завершен!',
        'mbtiQuestion': 'Вопрос о личности',
        'mbtiStepDescription': 'Давайте определим, какая личность должна быть у вашей персоны. Ответьте на вопросы, чтобы сформировать ее характер.',
        'shareDescription': 'Ваша персона может быть доступна другим пользователям после одобрения',
        'startTest': 'Начать тест'
    }
}

# Remaining translations for Spanish (4 keys)
remaining_es = {
    'mbtiComplete': 'Prueba de personalidad completada!',
    'mbtiQuestion': 'Pregunta de personalidad',
    'mbtiStepDescription': 'Determinemos qué personalidad debería tener tu persona. Responde preguntas para formar su carácter.',
    'startTest': 'Iniciar prueba'
}

# Remaining translations for languages with 15 missing keys
remaining_15_keys = {
    'ar': {  # Arabic
        'alwaysShowTranslationOff': 'إخفاء الترجمة التلقائية',
        'alwaysShowTranslationOn': 'إظهار الترجمة دائماً',
        'loginRequiredContent': 'يرجى تسجيل الدخول للمتابعة',
        'mbtiComplete': 'اختبار الشخصية مكتمل!',
        'mbtiQuestion': 'سؤال الشخصية',
        'mbtiStepDescription': 'دعنا نحدد الشخصية التي يجب أن تكون عليها شخصيتك. أجب على الأسئلة لتشكيل شخصيتها.',
        'permissionGuideAndroid': 'الإعدادات > التطبيقات > SONA > الصلاحيات\nيرجى السماح بصلاحية الصور',
        'permissionGuideIOS': 'الإعدادات > SONA > الصور\nيرجى السماح بالوصول للصور',
        'personaDescriptionHint': 'صف الشخصية',
        'personaLimitReached': 'لقد وصلت إلى حد 3 شخصيات',
        'personaNameHint': 'أدخل اسم الشخصية',
        'reportErrorButton': 'الإبلاغ عن خطأ',
        'shareDescription': 'يمكن مشاركة شخصيتك مع المستخدمين الآخرين بعد الموافقة',
        'sharePersona': 'مشاركة الشخصية',
        'shareWithCommunity': 'مشاركة مع المجتمع',
        'startTest': 'بدء الاختبار',
        'tellUsAboutYourPersona': 'أخبرنا عن شخصيتك',
        'uploadPersonaImages': 'رفع صور لشخصيتك',
        'willBeSharedAfterApproval': 'سيتم المشاركة بعد موافقة المسؤول'
    },
    'hi': {  # Hindi
        'alwaysShowTranslationOff': 'स्वचालित अनुवाद छुपाएं',
        'alwaysShowTranslationOn': 'हमेशा अनुवाद दिखाएं',
        'loginRequiredContent': 'जारी रखने के लिए कृपया लॉगिन करें',
        'mbtiComplete': 'व्यक्तित्व परीक्षण पूर्ण!',
        'mbtiQuestion': 'व्यक्तित्व प्रश्न',
        'mbtiStepDescription': 'आइए निर्धारित करें कि आपके व्यक्तित्व की क्या विशेषता होनी चाहिए। उनके चरित्र को आकार देने के लिए प्रश्नों का उत्तर दें।',
        'permissionGuideAndroid': 'सेटिंग्स > ऐप्स > SONA > अनुमतियां\nकृपया फोटो की अनुमति दें',
        'permissionGuideIOS': 'सेटिंग्स > SONA > फोटो\nकृपया फोटो एक्सेस की अनुमति दें',
        'personaDescriptionHint': 'व्यक्तित्व का वर्णन करें',
        'personaLimitReached': 'आप 3 व्यक्तित्वों की सीमा तक पहुंच गए हैं',
        'personaNameHint': 'व्यक्तित्व का नाम दर्ज करें',
        'reportErrorButton': 'त्रुटि रिपोर्ट करें',
        'shareDescription': 'अनुमोदन के बाद आपका व्यक्तित्व अन्य उपयोगकर्ताओं के साथ साझा किया जा सकता है',
        'sharePersona': 'व्यक्तित्व साझा करें',
        'shareWithCommunity': 'समुदाय के साथ साझा करें',
        'startTest': 'परीक्षण शुरू करें',
        'tellUsAboutYourPersona': 'हमें अपने व्यक्तित्व के बारे में बताएं',
        'uploadPersonaImages': 'अपने व्यक्तित्व के लिए छवियां अपलोड करें',
        'willBeSharedAfterApproval': 'व्यवस्थापक अनुमोदन के बाद साझा किया जाएगा'
    },
    'id': {  # Indonesian
        'alwaysShowTranslationOff': 'Sembunyikan Terjemahan Otomatis',
        'alwaysShowTranslationOn': 'Selalu Tampilkan Terjemahan',
        'loginRequiredContent': 'Silakan masuk untuk melanjutkan',
        'mbtiComplete': 'Tes Kepribadian Selesai!',
        'mbtiQuestion': 'Pertanyaan Kepribadian',
        'mbtiStepDescription': 'Mari tentukan kepribadian apa yang harus dimiliki persona Anda. Jawab pertanyaan untuk membentuk karakternya.',
        'permissionGuideAndroid': 'Pengaturan > Aplikasi > SONA > Izin\nHarap izinkan akses foto',
        'permissionGuideIOS': 'Pengaturan > SONA > Foto\nHarap izinkan akses foto',
        'personaDescriptionHint': 'Jelaskan persona',
        'personaLimitReached': 'Anda telah mencapai batas 3 persona',
        'personaNameHint': 'Masukkan nama persona',
        'reportErrorButton': 'Laporkan Kesalahan',
        'shareDescription': 'Persona Anda dapat dibagikan dengan pengguna lain setelah persetujuan',
        'sharePersona': 'Bagikan Persona',
        'shareWithCommunity': 'Bagikan dengan Komunitas',
        'startTest': 'Mulai Tes',
        'tellUsAboutYourPersona': 'Ceritakan tentang persona Anda',
        'uploadPersonaImages': 'Unggah gambar untuk persona Anda',
        'willBeSharedAfterApproval': 'Akan dibagikan setelah persetujuan admin'
    },
    'nl': {  # Dutch
        'alwaysShowTranslationOff': 'Automatische vertaling verbergen',
        'alwaysShowTranslationOn': 'Altijd vertaling tonen',
        'loginRequiredContent': 'Log in om door te gaan',
        'mbtiComplete': 'Persoonlijkheidstest voltooid!',
        'mbtiQuestion': 'Persoonlijkheidsvraag',
        'mbtiStepDescription': 'Laten we bepalen welke persoonlijkheid je persona moet hebben. Beantwoord vragen om hun karakter te vormen.',
        'permissionGuideAndroid': 'Instellingen > Apps > SONA > Toestemmingen\nSta foto-toegang toe',
        'permissionGuideIOS': 'Instellingen > SONA > Foto\'s\nSta foto-toegang toe',
        'personaDescriptionHint': 'Beschrijf de persona',
        'personaLimitReached': 'Je hebt de limiet van 3 personas bereikt',
        'personaNameHint': 'Voer persona naam in',
        'reportErrorButton': 'Fout melden',
        'shareDescription': 'Je persona kan na goedkeuring met andere gebruikers worden gedeeld',
        'sharePersona': 'Persona delen',
        'shareWithCommunity': 'Delen met gemeenschap',
        'startTest': 'Test starten',
        'tellUsAboutYourPersona': 'Vertel ons over je persona',
        'uploadPersonaImages': 'Upload afbeeldingen voor je persona',
        'willBeSharedAfterApproval': 'Wordt gedeeld na goedkeuring door beheerder'
    },
    'pl': {  # Polish
        'alwaysShowTranslationOff': 'Ukryj automatyczne tłumaczenie',
        'alwaysShowTranslationOn': 'Zawsze pokazuj tłumaczenie',
        'loginRequiredContent': 'Zaloguj się, aby kontynuować',
        'mbtiComplete': 'Test osobowości zakończony!',
        'mbtiQuestion': 'Pytanie o osobowość',
        'mbtiStepDescription': 'Określmy, jaką osobowość powinna mieć twoja persona. Odpowiedz na pytania, aby ukształtować jej charakter.',
        'permissionGuideAndroid': 'Ustawienia > Aplikacje > SONA > Uprawnienia\nZezwól na dostęp do zdjęć',
        'permissionGuideIOS': 'Ustawienia > SONA > Zdjęcia\nZezwól na dostęp do zdjęć',
        'personaDescriptionHint': 'Opisz personę',
        'personaLimitReached': 'Osiągnąłeś limit 3 person',
        'personaNameHint': 'Wprowadź nazwę persony',
        'reportErrorButton': 'Zgłoś błąd',
        'shareDescription': 'Twoja persona może być udostępniona innym użytkownikom po zatwierdzeniu',
        'sharePersona': 'Udostępnij personę',
        'shareWithCommunity': 'Udostępnij społeczności',
        'startTest': 'Rozpocznij test',
        'tellUsAboutYourPersona': 'Opowiedz nam o swojej personie',
        'uploadPersonaImages': 'Prześlij obrazy dla swojej persony',
        'willBeSharedAfterApproval': 'Zostanie udostępnione po zatwierdzeniu przez administratora'
    },
    'sv': {  # Swedish
        'alwaysShowTranslationOff': 'Dölj automatisk översättning',
        'alwaysShowTranslationOn': 'Visa alltid översättning',
        'loginRequiredContent': 'Logga in för att fortsätta',
        'mbtiComplete': 'Personlighetstest klart!',
        'mbtiQuestion': 'Personlighetsfråga',
        'mbtiStepDescription': 'Låt oss bestämma vilken personlighet din persona ska ha. Svara på frågor för att forma deras karaktär.',
        'permissionGuideAndroid': 'Inställningar > Appar > SONA > Behörigheter\nTillåt fotoåtkomst',
        'permissionGuideIOS': 'Inställningar > SONA > Foton\nTillåt fotoåtkomst',
        'personaDescriptionHint': 'Beskriv personan',
        'personaLimitReached': 'Du har nått gränsen på 3 personas',
        'personaNameHint': 'Ange personanamn',
        'reportErrorButton': 'Rapportera fel',
        'shareDescription': 'Din persona kan delas med andra användare efter godkännande',
        'sharePersona': 'Dela persona',
        'shareWithCommunity': 'Dela med gemenskapen',
        'startTest': 'Starta test',
        'tellUsAboutYourPersona': 'Berätta om din persona',
        'uploadPersonaImages': 'Ladda upp bilder för din persona',
        'willBeSharedAfterApproval': 'Kommer att delas efter administratörsgodkännande'
    },
    'th': {  # Thai
        'alwaysShowTranslationOff': 'ซ่อนการแปลอัตโนมัติ',
        'alwaysShowTranslationOn': 'แสดงการแปลเสมอ',
        'loginRequiredContent': 'กรุณาเข้าสู่ระบบเพื่อดำเนินการต่อ',
        'mbtiComplete': 'ทดสอบบุคลิกภาพเสร็จสิ้น!',
        'mbtiQuestion': 'คำถามบุคลิกภาพ',
        'mbtiStepDescription': 'มากำหนดว่าเพอร์โซน่าของคุณควรมีบุคลิกภาพแบบไหน ตอบคำถามเพื่อสร้างลักษณะนิสัย',
        'permissionGuideAndroid': 'การตั้งค่า > แอป > SONA > สิทธิ์\nกรุณาอนุญาตการเข้าถึงรูปภาพ',
        'permissionGuideIOS': 'การตั้งค่า > SONA > รูปภาพ\nกรุณาอนุญาตการเข้าถึงรูปภาพ',
        'personaDescriptionHint': 'อธิบายเพอร์โซน่า',
        'personaLimitReached': 'คุณถึงขีดจำกัด 3 เพอร์โซน่าแล้ว',
        'personaNameHint': 'ใส่ชื่อเพอร์โซน่า',
        'reportErrorButton': 'รายงานข้อผิดพลาด',
        'shareDescription': 'เพอร์โซน่าของคุณสามารถแชร์กับผู้ใช้อื่นได้หลังจากได้รับการอนุมัติ',
        'sharePersona': 'แชร์เพอร์โซน่า',
        'shareWithCommunity': 'แชร์กับชุมชน',
        'startTest': 'เริ่มทดสอบ',
        'tellUsAboutYourPersona': 'บอกเราเกี่ยวกับเพอร์โซน่าของคุณ',
        'uploadPersonaImages': 'อัปโหลดรูปภาพสำหรับเพอร์โซน่าของคุณ',
        'willBeSharedAfterApproval': 'จะถูกแชร์หลังจากผู้ดูแลอนุมัติ'
    },
    'tl': {  # Tagalog
        'alwaysShowTranslationOff': 'Itago ang Awtomatikong Pagsasalin',
        'alwaysShowTranslationOn': 'Palaging Ipakita ang Pagsasalin',
        'loginRequiredContent': 'Mag-login para magpatuloy',
        'mbtiComplete': 'Tapos na ang Pagsusulit sa Personalidad!',
        'mbtiQuestion': 'Tanong sa Personalidad',
        'mbtiStepDescription': 'Tukuyin natin kung anong personalidad ang dapat magkaroon ang iyong persona. Sagutin ang mga tanong para hubugin ang kanilang karakter.',
        'permissionGuideAndroid': 'Settings > Apps > SONA > Permissions\nPahintulutan ang access sa larawan',
        'permissionGuideIOS': 'Settings > SONA > Photos\nPahintulutan ang access sa larawan',
        'personaDescriptionHint': 'Ilarawan ang persona',
        'personaLimitReached': 'Naabot mo na ang limitasyon na 3 persona',
        'personaNameHint': 'Ilagay ang pangalan ng persona',
        'reportErrorButton': 'I-report ang Error',
        'shareDescription': 'Ang iyong persona ay maaaring ibahagi sa ibang users pagkatapos ng pag-apruba',
        'sharePersona': 'Ibahagi ang Persona',
        'shareWithCommunity': 'Ibahagi sa Komunidad',
        'startTest': 'Simulan ang Pagsusulit',
        'tellUsAboutYourPersona': 'Sabihin sa amin tungkol sa iyong persona',
        'uploadPersonaImages': 'Mag-upload ng mga larawan para sa iyong persona',
        'willBeSharedAfterApproval': 'Ibabahagi pagkatapos ng pag-apruba ng admin'
    },
    'tr': {  # Turkish
        'alwaysShowTranslationOff': 'Otomatik Çeviriyi Gizle',
        'alwaysShowTranslationOn': 'Her Zaman Çeviriyi Göster',
        'loginRequiredContent': 'Devam etmek için lütfen giriş yapın',
        'mbtiComplete': 'Kişilik Testi Tamamlandı!',
        'mbtiQuestion': 'Kişilik Sorusu',
        'mbtiStepDescription': 'Personanızın hangi kişiliğe sahip olması gerektiğini belirleyelim. Karakterini şekillendirmek için soruları yanıtlayın.',
        'permissionGuideAndroid': 'Ayarlar > Uygulamalar > SONA > İzinler\nLütfen fotoğraf iznini verin',
        'permissionGuideIOS': 'Ayarlar > SONA > Fotoğraflar\nLütfen fotoğraf erişimine izin verin',
        'personaDescriptionHint': 'Personayı tanımlayın',
        'personaLimitReached': '3 persona sınırına ulaştınız',
        'personaNameHint': 'Persona adını girin',
        'reportErrorButton': 'Hatayı Bildir',
        'shareDescription': 'Personanız onaydan sonra diğer kullanıcılarla paylaşılabilir',
        'sharePersona': 'Personayı Paylaş',
        'shareWithCommunity': 'Toplulukla Paylaş',
        'startTest': 'Testi Başlat',
        'tellUsAboutYourPersona': 'Bize personanız hakkında bilgi verin',
        'uploadPersonaImages': 'Personanız için resimler yükleyin',
        'willBeSharedAfterApproval': 'Yönetici onayından sonra paylaşılacak'
    },
    'ur': {  # Urdu
        'alwaysShowTranslationOff': 'خودکار ترجمہ چھپائیں',
        'alwaysShowTranslationOn': 'ہمیشہ ترجمہ دکھائیں',
        'loginRequiredContent': 'جاری رکھنے کے لیے لاگ ان کریں',
        'mbtiComplete': 'شخصیت ٹیسٹ مکمل!',
        'mbtiQuestion': 'شخصیت کا سوال',
        'mbtiStepDescription': 'آئیے طے کریں کہ آپ کی شخصیت کی کیا خصوصیت ہونی چاہیے۔ ان کے کردار کو تشکیل دینے کے لیے سوالات کا جواب دیں۔',
        'permissionGuideAndroid': 'سیٹنگز > ایپس > SONA > اجازات\nبراہ کرم تصویر کی اجازت دیں',
        'permissionGuideIOS': 'سیٹنگز > SONA > تصاویر\nبراہ کرم تصویر تک رسائی کی اجازت دیں',
        'personaDescriptionHint': 'شخصیت کی وضاحت کریں',
        'personaLimitReached': 'آپ 3 شخصیات کی حد تک پہنچ گئے ہیں',
        'personaNameHint': 'شخصیت کا نام درج کریں',
        'reportErrorButton': 'خرابی کی اطلاع دیں',
        'shareDescription': 'منظوری کے بعد آپ کی شخصیت دوسرے صارفین کے ساتھ شیئر کی جا سکتی ہے',
        'sharePersona': 'شخصیت شیئر کریں',
        'shareWithCommunity': 'کمیونٹی کے ساتھ شیئر کریں',
        'startTest': 'ٹیسٹ شروع کریں',
        'tellUsAboutYourPersona': 'ہمیں اپنی شخصیت کے بارے میں بتائیں',
        'uploadPersonaImages': 'اپنی شخصیت کے لیے تصاویر اپ لوڈ کریں',
        'willBeSharedAfterApproval': 'ایڈمن کی منظوری کے بعد شیئر کیا جائے گا'
    },
    'vi': {  # Vietnamese
        'alwaysShowTranslationOff': 'Ẩn dịch tự động',
        'alwaysShowTranslationOn': 'Luôn hiển thị bản dịch',
        'loginRequiredContent': 'Vui lòng đăng nhập để tiếp tục',
        'mbtiComplete': 'Kiểm tra tính cách hoàn tất!',
        'mbtiQuestion': 'Câu hỏi tính cách',
        'mbtiStepDescription': 'Hãy xác định persona của bạn nên có tính cách như thế nào. Trả lời các câu hỏi để hình thành tính cách của họ.',
        'permissionGuideAndroid': 'Cài đặt > Ứng dụng > SONA > Quyền\nVui lòng cho phép truy cập ảnh',
        'permissionGuideIOS': 'Cài đặt > SONA > Ảnh\nVui lòng cho phép truy cập ảnh',
        'personaDescriptionHint': 'Mô tả persona',
        'personaLimitReached': 'Bạn đã đạt giới hạn 3 persona',
        'personaNameHint': 'Nhập tên persona',
        'reportErrorButton': 'Báo cáo lỗi',
        'shareDescription': 'Persona của bạn có thể được chia sẻ với người dùng khác sau khi được phê duyệt',
        'sharePersona': 'Chia sẻ Persona',
        'shareWithCommunity': 'Chia sẻ với cộng đồng',
        'startTest': 'Bắt đầu kiểm tra',
        'tellUsAboutYourPersona': 'Hãy cho chúng tôi biết về persona của bạn',
        'uploadPersonaImages': 'Tải lên hình ảnh cho persona của bạn',
        'willBeSharedAfterApproval': 'Sẽ được chia sẻ sau khi quản trị viên phê duyệt'
    }
}

def update_language_file(lang_code, translations_dict):
    """Update a language file with new translations"""
    filepath = f'lib/l10n/app_{lang_code}.arb'
    
    # Read existing file
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Add new translations
    added = 0
    for key, value in translations_dict.items():
        if key not in data:
            data[key] = value
            # Add metadata
            data[f'@{key}'] = {
                'description': f'Localized string for {key}'
            }
            added += 1
    
    # Write back
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    if added > 0:
        print(f'[OK] Updated {lang_code}: added {added} translations')
    else:
        print(f'[INFO] {lang_code}: already complete')

# Apply remaining translations for 5-key languages
print('Adding remaining translations for European languages...')
for lang_code, trans_dict in remaining_5_keys.items():
    update_language_file(lang_code, trans_dict)

# Apply remaining translations for Spanish
print('Adding remaining translations for Spanish...')
update_language_file('es', remaining_es)

# Apply remaining translations for 15-key languages
print('Adding remaining translations for other languages...')
for lang_code, trans_dict in remaining_15_keys.items():
    update_language_file(lang_code, trans_dict)

print('\n[SUCCESS] All translations completed!')
print('Run "flutter gen-l10n" to regenerate localization files')