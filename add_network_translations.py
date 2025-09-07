import json
import os

# Translation data for all 21 languages
translations = {
    'en': {
        'noInternetConnection': 'No Internet Connection',
        'internetRequiredMessage': 'An internet connection is required to use SONA. Please check your connection and try again.',
        'retryConnection': 'Retry',
        'openNetworkSettings': 'Open Settings',
        'checkingConnection': 'Checking connection...'
    },
    'ko': {
        'noInternetConnection': '인터넷 연결 없음',
        'internetRequiredMessage': 'SONA를 사용하려면 인터넷 연결이 필요합니다. 연결 상태를 확인하고 다시 시도해주세요.',
        'retryConnection': '재시도',
        'openNetworkSettings': '설정 열기',
        'checkingConnection': '연결 확인 중...'
    },
    'ja': {
        'noInternetConnection': 'インターネット接続なし',
        'internetRequiredMessage': 'SONAを使用するにはインターネット接続が必要です。接続を確認してもう一度お試しください。',
        'retryConnection': '再試行',
        'openNetworkSettings': '設定を開く',
        'checkingConnection': '接続を確認中...'
    },
    'zh': {
        'noInternetConnection': '无网络连接',
        'internetRequiredMessage': '使用SONA需要互联网连接。请检查您的连接并重试。',
        'retryConnection': '重试',
        'openNetworkSettings': '打开设置',
        'checkingConnection': '正在检查连接...'
    },
    'th': {
        'noInternetConnection': 'ไม่มีการเชื่อมต่ออินเทอร์เน็ต',
        'internetRequiredMessage': 'ต้องการการเชื่อมต่ออินเทอร์เน็ตเพื่อใช้ SONA กรุณาตรวจสอบการเชื่อมต่อและลองอีกครั้ง',
        'retryConnection': 'ลองใหม่',
        'openNetworkSettings': 'เปิดการตั้งค่า',
        'checkingConnection': 'กำลังตรวจสอบการเชื่อมต่อ...'
    },
    'vi': {
        'noInternetConnection': 'Không có kết nối Internet',
        'internetRequiredMessage': 'Cần có kết nối internet để sử dụng SONA. Vui lòng kiểm tra kết nối và thử lại.',
        'retryConnection': 'Thử lại',
        'openNetworkSettings': 'Mở Cài đặt',
        'checkingConnection': 'Đang kiểm tra kết nối...'
    },
    'id': {
        'noInternetConnection': 'Tidak Ada Koneksi Internet',
        'internetRequiredMessage': 'Koneksi internet diperlukan untuk menggunakan SONA. Silakan periksa koneksi Anda dan coba lagi.',
        'retryConnection': 'Coba Lagi',
        'openNetworkSettings': 'Buka Pengaturan',
        'checkingConnection': 'Memeriksa koneksi...'
    },
    'tl': {
        'noInternetConnection': 'Walang Koneksyon sa Internet',
        'internetRequiredMessage': 'Kailangan ng koneksyon sa internet para gamitin ang SONA. Pakisuri ang iyong koneksyon at subukan muli.',
        'retryConnection': 'Subukan Muli',
        'openNetworkSettings': 'Buksan ang Mga Setting',
        'checkingConnection': 'Sinusuri ang koneksyon...'
    },
    'es': {
        'noInternetConnection': 'Sin Conexión a Internet',
        'internetRequiredMessage': 'Se requiere una conexión a internet para usar SONA. Por favor, verifica tu conexión e intenta de nuevo.',
        'retryConnection': 'Reintentar',
        'openNetworkSettings': 'Abrir Configuración',
        'checkingConnection': 'Verificando conexión...'
    },
    'fr': {
        'noInternetConnection': 'Pas de Connexion Internet',
        'internetRequiredMessage': 'Une connexion internet est requise pour utiliser SONA. Veuillez vérifier votre connexion et réessayer.',
        'retryConnection': 'Réessayer',
        'openNetworkSettings': 'Ouvrir les Paramètres',
        'checkingConnection': 'Vérification de la connexion...'
    },
    'de': {
        'noInternetConnection': 'Keine Internetverbindung',
        'internetRequiredMessage': 'Eine Internetverbindung ist erforderlich, um SONA zu verwenden. Bitte überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.',
        'retryConnection': 'Erneut versuchen',
        'openNetworkSettings': 'Einstellungen öffnen',
        'checkingConnection': 'Verbindung wird überprüft...'
    },
    'ru': {
        'noInternetConnection': 'Нет подключения к Интернету',
        'internetRequiredMessage': 'Для использования SONA требуется подключение к интернету. Пожалуйста, проверьте ваше подключение и попробуйте снова.',
        'retryConnection': 'Повторить',
        'openNetworkSettings': 'Открыть настройки',
        'checkingConnection': 'Проверка подключения...'
    },
    'pt': {
        'noInternetConnection': 'Sem Conexão com a Internet',
        'internetRequiredMessage': 'É necessária uma conexão com a internet para usar o SONA. Por favor, verifique sua conexão e tente novamente.',
        'retryConnection': 'Tentar Novamente',
        'openNetworkSettings': 'Abrir Configurações',
        'checkingConnection': 'Verificando conexão...'
    },
    'it': {
        'noInternetConnection': 'Nessuna Connessione Internet',
        'internetRequiredMessage': 'È richiesta una connessione internet per utilizzare SONA. Controlla la tua connessione e riprova.',
        'retryConnection': 'Riprova',
        'openNetworkSettings': 'Apri Impostazioni',
        'checkingConnection': 'Controllo connessione...'
    },
    'nl': {
        'noInternetConnection': 'Geen Internetverbinding',
        'internetRequiredMessage': 'Een internetverbinding is vereist om SONA te gebruiken. Controleer uw verbinding en probeer het opnieuw.',
        'retryConnection': 'Opnieuw proberen',
        'openNetworkSettings': 'Instellingen openen',
        'checkingConnection': 'Verbinding controleren...'
    },
    'sv': {
        'noInternetConnection': 'Ingen Internetanslutning',
        'internetRequiredMessage': 'En internetanslutning krävs för att använda SONA. Kontrollera din anslutning och försök igen.',
        'retryConnection': 'Försök igen',
        'openNetworkSettings': 'Öppna Inställningar',
        'checkingConnection': 'Kontrollerar anslutning...'
    },
    'pl': {
        'noInternetConnection': 'Brak Połączenia z Internetem',
        'internetRequiredMessage': 'Do korzystania z SONA wymagane jest połączenie z internetem. Sprawdź swoje połączenie i spróbuj ponownie.',
        'retryConnection': 'Spróbuj ponownie',
        'openNetworkSettings': 'Otwórz Ustawienia',
        'checkingConnection': 'Sprawdzanie połączenia...'
    },
    'tr': {
        'noInternetConnection': 'İnternet Bağlantısı Yok',
        'internetRequiredMessage': 'SONA kullanmak için internet bağlantısı gereklidir. Lütfen bağlantınızı kontrol edin ve tekrar deneyin.',
        'retryConnection': 'Tekrar Dene',
        'openNetworkSettings': 'Ayarları Aç',
        'checkingConnection': 'Bağlantı kontrol ediliyor...'
    },
    'ar': {
        'noInternetConnection': 'لا يوجد اتصال بالإنترنت',
        'internetRequiredMessage': 'يتطلب استخدام SONA اتصالاً بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.',
        'retryConnection': 'إعادة المحاولة',
        'openNetworkSettings': 'فتح الإعدادات',
        'checkingConnection': 'جاري فحص الاتصال...'
    },
    'hi': {
        'noInternetConnection': 'इंटरनेट कनेक्शन नहीं है',
        'internetRequiredMessage': 'SONA का उपयोग करने के लिए इंटरनेट कनेक्शन की आवश्यकता है। कृपया अपना कनेक्शन जांचें और फिर से प्रयास करें।',
        'retryConnection': 'पुनः प्रयास करें',
        'openNetworkSettings': 'सेटिंग्स खोलें',
        'checkingConnection': 'कनेक्शन जांच रहे हैं...'
    },
    'ur': {
        'noInternetConnection': 'انٹرنیٹ کنکشن نہیں ہے',
        'internetRequiredMessage': 'SONA استعمال کرنے کے لیے انٹرنیٹ کنکشن کی ضرورت ہے۔ براہ کرم اپنا کنکشن چیک کریں اور دوبارہ کوشش کریں۔',
        'retryConnection': 'دوبارہ کوشش کریں',
        'openNetworkSettings': 'سیٹنگز کھولیں',
        'checkingConnection': 'کنکشن چیک کیا جا رہا ہے...'
    }
}

def add_network_translations():
    """Add network-related translations to all language files"""
    
    base_dir = 'sona_app/lib/l10n'
    
    for lang_code, trans in translations.items():
        file_path = os.path.join(base_dir, f'app_{lang_code}.arb')
        
        if not os.path.exists(file_path):
            print(f"Warning: File not found: {file_path}")
            continue
            
        # Read the existing file
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        try:
            data = json.loads(content)
        except json.JSONDecodeError as e:
            print(f"Error parsing {file_path}: {e}")
            continue
        
        # Check if keys already exist
        needs_update = False
        for key in ['noInternetConnection', 'internetRequiredMessage', 'retryConnection', 'openNetworkSettings', 'checkingConnection']:
            if key not in data:
                needs_update = True
                break
        
        if not needs_update:
            print(f"[OK] {lang_code}: All network keys already exist")
            continue
            
        # Add translations
        data['noInternetConnection'] = trans['noInternetConnection']
        data['@noInternetConnection'] = {
            'description': 'Title for no internet connection dialog'
        }
        
        data['internetRequiredMessage'] = trans['internetRequiredMessage']
        data['@internetRequiredMessage'] = {
            'description': 'Message explaining that internet is required'
        }
        
        data['retryConnection'] = trans['retryConnection']
        data['@retryConnection'] = {
            'description': 'Button text to retry network connection'
        }
        
        data['openNetworkSettings'] = trans['openNetworkSettings']
        data['@openNetworkSettings'] = {
            'description': 'Button text to open network settings'
        }
        
        data['checkingConnection'] = trans['checkingConnection']
        data['@checkingConnection'] = {
            'description': 'Message shown while checking network connection'
        }
        
        # Write back
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            
        print(f"[ADDED] {lang_code}: Added network translations")

if __name__ == '__main__':
    add_network_translations()
    print("\n[COMPLETE] Network translations added to all language files!")
    print("Now run: flutter gen-l10n")