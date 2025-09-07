import json
import os

# Define the translations for each language
translations = {
    'en': {
        'noHeartsLeft': 'No Hearts Left',
        'needHeartsToChat': 'You need hearts to start a conversation with this persona.',
        'goToStore': 'Go to Store'
    },
    'ko': {
        'noHeartsLeft': '하트가 없습니다',
        'needHeartsToChat': '이 페르소나와 대화를 시작하려면 하트가 필요합니다.',
        'goToStore': '스토어로 이동'
    },
    'ja': {
        'noHeartsLeft': 'ハートがありません',
        'needHeartsToChat': 'このペルソナと会話を始めるにはハートが必要です。',
        'goToStore': 'ストアへ移動'
    },
    'zh': {
        'noHeartsLeft': '没有爱心了',
        'needHeartsToChat': '您需要爱心才能与此角色开始对话。',
        'goToStore': '前往商店'
    },
    'th': {
        'noHeartsLeft': 'ไม่มีหัวใจเหลือ',
        'needHeartsToChat': 'คุณต้องมีหัวใจเพื่อเริ่มการสนทนากับเพอร์โซนานี้',
        'goToStore': 'ไปที่ร้านค้า'
    },
    'vi': {
        'noHeartsLeft': 'Hết tim',
        'needHeartsToChat': 'Bạn cần có tim để bắt đầu cuộc trò chuyện với nhân vật này.',
        'goToStore': 'Đến cửa hàng'
    },
    'id': {
        'noHeartsLeft': 'Tidak Ada Hati Tersisa',
        'needHeartsToChat': 'Anda memerlukan hati untuk memulai percakapan dengan persona ini.',
        'goToStore': 'Pergi ke Toko'
    },
    'tl': {
        'noHeartsLeft': 'Walang Natirang Puso',
        'needHeartsToChat': 'Kailangan mo ng mga puso para magsimula ng pag-uusap sa persona na ito.',
        'goToStore': 'Pumunta sa Tindahan'
    },
    'es': {
        'noHeartsLeft': 'Sin corazones',
        'needHeartsToChat': 'Necesitas corazones para iniciar una conversación con este personaje.',
        'goToStore': 'Ir a la tienda'
    },
    'fr': {
        'noHeartsLeft': 'Plus de cœurs',
        'needHeartsToChat': 'Vous avez besoin de cœurs pour commencer une conversation avec ce personnage.',
        'goToStore': 'Aller au magasin'
    },
    'de': {
        'noHeartsLeft': 'Keine Herzen mehr',
        'needHeartsToChat': 'Sie benötigen Herzen, um ein Gespräch mit dieser Persona zu beginnen.',
        'goToStore': 'Zum Shop gehen'
    },
    'ru': {
        'noHeartsLeft': 'Сердца закончились',
        'needHeartsToChat': 'Вам нужны сердца, чтобы начать разговор с этой персоной.',
        'goToStore': 'Перейти в магазин'
    },
    'pt': {
        'noHeartsLeft': 'Sem corações',
        'needHeartsToChat': 'Você precisa de corações para iniciar uma conversa com esta persona.',
        'goToStore': 'Ir para a loja'
    },
    'it': {
        'noHeartsLeft': 'Nessun cuore rimasto',
        'needHeartsToChat': 'Hai bisogno di cuori per iniziare una conversazione con questo personaggio.',
        'goToStore': 'Vai al negozio'
    },
    'nl': {
        'noHeartsLeft': 'Geen harten meer',
        'needHeartsToChat': 'Je hebt harten nodig om een gesprek met deze persona te beginnen.',
        'goToStore': 'Naar de winkel'
    },
    'sv': {
        'noHeartsLeft': 'Inga hjärtan kvar',
        'needHeartsToChat': 'Du behöver hjärtan för att starta en konversation med denna persona.',
        'goToStore': 'Gå till butiken'
    },
    'pl': {
        'noHeartsLeft': 'Brak serc',
        'needHeartsToChat': 'Potrzebujesz serc, aby rozpocząć rozmowę z tą personą.',
        'goToStore': 'Idź do sklepu'
    },
    'tr': {
        'noHeartsLeft': 'Kalp kalmadı',
        'needHeartsToChat': 'Bu kişilikle sohbet başlatmak için kalplere ihtiyacınız var.',
        'goToStore': 'Mağazaya git'
    },
    'ar': {
        'noHeartsLeft': 'لا توجد قلوب متبقية',
        'needHeartsToChat': 'تحتاج إلى قلوب لبدء محادثة مع هذه الشخصية.',
        'goToStore': 'الذهاب إلى المتجر'
    },
    'hi': {
        'noHeartsLeft': 'कोई दिल नहीं बचा',
        'needHeartsToChat': 'इस व्यक्तित्व के साथ बातचीत शुरू करने के लिए आपको दिलों की आवश्यकता है।',
        'goToStore': 'स्टोर पर जाएं'
    },
    'ur': {
        'noHeartsLeft': 'کوئی دل باقی نہیں',
        'needHeartsToChat': 'اس شخصیت کے ساتھ بات چیت شروع کرنے کے لیے آپ کو دلوں کی ضرورت ہے۔',
        'goToStore': 'اسٹور پر جائیں'
    }
}

# Path to the l10n directory
l10n_dir = r'sona_app\lib\l10n'

# Process each language file
for lang_code, trans in translations.items():
    file_path = os.path.join(l10n_dir, f'app_{lang_code}.arb')
    
    if os.path.exists(file_path):
        # Read the existing file
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Check if keys already exist
        keys_to_add = []
        for key in ['noHeartsLeft', 'needHeartsToChat', 'goToStore']:
            if key not in data:
                keys_to_add.append(key)
        
        if keys_to_add:
            # Find the position after insufficientHearts
            items = list(data.items())
            new_items = []
            added = False
            
            for key, value in items:
                new_items.append((key, value))
                
                # Add after insufficientHearts and its description
                if key == '@insufficientHearts' and not added:
                    # Add noHeartsLeft
                    if 'noHeartsLeft' in keys_to_add:
                        new_items.append(('noHeartsLeft', trans['noHeartsLeft']))
                        new_items.append(('@noHeartsLeft', {
                            'description': 'Message shown when user has no hearts left'
                        }))
                    
                    # Add needHeartsToChat
                    if 'needHeartsToChat' in keys_to_add:
                        new_items.append(('needHeartsToChat', trans['needHeartsToChat']))
                        new_items.append(('@needHeartsToChat', {
                            'description': 'Message explaining that hearts are needed to chat'
                        }))
                    
                    # Add goToStore
                    if 'goToStore' in keys_to_add:
                        new_items.append(('goToStore', trans['goToStore']))
                        new_items.append(('@goToStore', {
                            'description': 'Button text to navigate to store'
                        }))
                    
                    added = True
            
            # Convert back to dictionary
            new_data = dict(new_items)
            
            # Write the updated file
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(new_data, f, ensure_ascii=False, indent=2)
            
            print(f"[OK] Updated {lang_code}: Added {', '.join(keys_to_add)}")
        else:
            print(f"[INFO] {lang_code}: All keys already exist")
    else:
        print(f"[ERROR] File not found: {file_path}")

print("\n[OK] Translation update complete!")
print("Run 'flutter gen-l10n' in the sona_app directory to generate the Dart code.")