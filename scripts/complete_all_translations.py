#!/usr/bin/env python3
"""
Complete translations for all languages in the SONA app.
This script provides comprehensive translations for all 13 supported languages.
"""

import json
import sys
from pathlib import Path

# Set UTF-8 encoding for Windows console
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

# Base translations that need to be applied to all languages
BASE_TRANSLATIONS = {
    "en": {
        # Already in English, no changes needed
    },
    "ko": {
        "hapticFeedback": "햅틱 피드백",
        "profileSettings": "프로필 설정",
        "profileSetup": "프로필 설정 중",
        "purchaseConfirmMessage": "{title}을(를) {price}에 구매하시겠습니까? {description}",
        "purchaseConfirmContent": "{product}을(를) {price}에 구매하시겠습니까?",
        "daysAgo": "{count}일 전",
        "hoursAgo": "{count}시간 전",
        "minutesAgo": "{count}분 전",
        "accountDeletedSuccess": "계정이 성공적으로 삭제되었습니다",
        "accountDeletionInfo": "계정 삭제 안내",
        "accountDeletionWarning1": "경고: 이 작업은 되돌릴 수 없습니다",
        "accountDeletionWarning2": "모든 데이터가 영구적으로 삭제됩니다",
        "accountDeletionWarning3": "모든 대화 기록에 접근할 수 없게 됩니다",
        "accountDeletionWarning4": "구매한 모든 콘텐츠가 포함됩니다",
        "weekdays": "일,월,화,수,목,금,토"
    },
    "ja": {
        "hapticFeedback": "触覚フィードバック",
        "profileSettings": "プロフィール設定",
        "profileSetup": "プロフィール設定中",
        "purchaseConfirmMessage": "{title}を{price}で購入しますか？{description}",
        "purchaseConfirmContent": "{product}を{price}で購入しますか？",
        "daysAgo": "{count}日前",
        "hoursAgo": "{count}時間前",
        "minutesAgo": "{count}分前",
        "accountDeletedSuccess": "アカウントが正常に削除されました",
        "accountDeletionInfo": "アカウント削除のご案内",
        "accountDeletionWarning1": "警告：この操作は元に戻せません",
        "accountDeletionWarning2": "すべてのデータが永久に削除されます",
        "accountDeletionWarning3": "すべての会話履歴にアクセスできなくなります",
        "accountDeletionWarning4": "購入したすべてのコンテンツが含まれます",
        "weekdays": "日,月,火,水,木,金,土"
    },
    "zh": {
        "hapticFeedback": "触觉反馈",
        "profileSettings": "个人资料设置",
        "profileSetup": "正在设置个人资料",
        "purchaseConfirmMessage": "确认以{price}购买{title}吗？{description}",
        "purchaseConfirmContent": "以{price}购买{product}吗？",
        "daysAgo": "{count}天前",
        "hoursAgo": "{count}小时前",
        "minutesAgo": "{count}分钟前",
        "accountDeletedSuccess": "账户已成功删除",
        "accountDeletionInfo": "账户删除信息",
        "accountDeletionWarning1": "警告：此操作无法撤消",
        "accountDeletionWarning2": "所有数据将被永久删除",
        "accountDeletionWarning3": "您将无法访问所有对话记录",
        "accountDeletionWarning4": "这包括所有购买的内容",
        "weekdays": "日,一,二,三,四,五,六"
    },
    "es": {
        "hapticFeedback": "Retroalimentación háptica",
        "profileSettings": "Configuración del perfil",
        "profileSetup": "Configurando perfil",
        "purchaseConfirmMessage": "¿Confirmar compra de {title} por {price}? {description}",
        "purchaseConfirmContent": "¿Comprar {product} por {price}?",
        "daysAgo": "hace {count} días",
        "hoursAgo": "hace {count} horas",
        "minutesAgo": "hace {count} minutos",
        "accountDeletedSuccess": "Cuenta eliminada exitosamente",
        "accountDeletionInfo": "Información de eliminación de cuenta",
        "accountDeletionWarning1": "Advertencia: Esta acción no se puede deshacer",
        "accountDeletionWarning2": "Todos tus datos serán eliminados permanentemente",
        "accountDeletionWarning3": "Perderás acceso a todas las conversaciones",
        "accountDeletionWarning4": "Esto incluye todo el contenido comprado",
        "weekdays": "Dom,Lun,Mar,Mié,Jue,Vie,Sáb"
    },
    "fr": {
        "hapticFeedback": "Retour haptique",
        "profileSettings": "Paramètres du profil",
        "profileSetup": "Configuration du profil",
        "purchaseConfirmMessage": "Confirmer l'achat de {title} pour {price}? {description}",
        "purchaseConfirmContent": "Acheter {product} pour {price}?",
        "daysAgo": "il y a {count} jours",
        "hoursAgo": "il y a {count} heures",
        "minutesAgo": "il y a {count} minutes",
        "accountDeletedSuccess": "Compte supprimé avec succès",
        "accountDeletionInfo": "Informations sur la suppression du compte",
        "accountDeletionWarning1": "Avertissement: Cette action ne peut pas être annulée",
        "accountDeletionWarning2": "Toutes vos données seront supprimées définitivement",
        "accountDeletionWarning3": "Vous perdrez l'accès à toutes les conversations",
        "accountDeletionWarning4": "Cela inclut tout le contenu acheté",
        "weekdays": "Dim,Lun,Mar,Mer,Jeu,Ven,Sam"
    },
    "de": {
        "hapticFeedback": "Haptisches Feedback",
        "profileSettings": "Profileinstellungen",
        "profileSetup": "Profil wird eingerichtet",
        "purchaseConfirmMessage": "Kauf von {title} für {price} bestätigen? {description}",
        "purchaseConfirmContent": "{product} für {price} kaufen?",
        "daysAgo": "vor {count} Tagen",
        "hoursAgo": "vor {count} Stunden",
        "minutesAgo": "vor {count} Minuten",
        "accountDeletedSuccess": "Konto erfolgreich gelöscht",
        "accountDeletionInfo": "Informationen zur Kontolöschung",
        "accountDeletionWarning1": "Warnung: Diese Aktion kann nicht rückgängig gemacht werden",
        "accountDeletionWarning2": "Alle Ihre Daten werden dauerhaft gelöscht",
        "accountDeletionWarning3": "Sie verlieren den Zugriff auf alle Unterhaltungen",
        "accountDeletionWarning4": "Dies umfasst alle gekauften Inhalte",
        "weekdays": "So,Mo,Di,Mi,Do,Fr,Sa"
    },
    "it": {
        "hapticFeedback": "Feedback aptico",
        "profileSettings": "Impostazioni profilo",
        "profileSetup": "Configurazione profilo",
        "purchaseConfirmMessage": "Confermare l'acquisto di {title} per {price}? {description}",
        "purchaseConfirmContent": "Acquistare {product} per {price}?",
        "daysAgo": "{count} giorni fa",
        "hoursAgo": "{count} ore fa",
        "minutesAgo": "{count} minuti fa",
        "accountDeletedSuccess": "Account eliminato con successo",
        "accountDeletionInfo": "Informazioni sull'eliminazione dell'account",
        "accountDeletionWarning1": "Attenzione: Questa azione non può essere annullata",
        "accountDeletionWarning2": "Tutti i tuoi dati saranno eliminati permanentemente",
        "accountDeletionWarning3": "Perderai l'accesso a tutte le conversazioni",
        "accountDeletionWarning4": "Questo include tutti i contenuti acquistati",
        "weekdays": "Dom,Lun,Mar,Mer,Gio,Ven,Sab"
    },
    "pt": {
        "hapticFeedback": "Feedback háptico",
        "profileSettings": "Configurações do perfil",
        "profileSetup": "Configurando perfil",
        "purchaseConfirmMessage": "Confirmar compra de {title} por {price}? {description}",
        "purchaseConfirmContent": "Comprar {product} por {price}?",
        "daysAgo": "{count} dias atrás",
        "hoursAgo": "{count} horas atrás",
        "minutesAgo": "{count} minutos atrás",
        "accountDeletedSuccess": "Conta excluída com sucesso",
        "accountDeletionInfo": "Informações sobre exclusão de conta",
        "accountDeletionWarning1": "Aviso: Esta ação não pode ser desfeita",
        "accountDeletionWarning2": "Todos os seus dados serão excluídos permanentemente",
        "accountDeletionWarning3": "Você perderá o acesso a todas as conversas",
        "accountDeletionWarning4": "Isso inclui todo o conteúdo comprado",
        "weekdays": "Dom,Seg,Ter,Qua,Qui,Sex,Sáb"
    },
    "ru": {
        "hapticFeedback": "Тактильная обратная связь",
        "profileSettings": "Настройки профиля",
        "profileSetup": "Настройка профиля",
        "purchaseConfirmMessage": "Подтвердить покупку {title} за {price}? {description}",
        "purchaseConfirmContent": "Купить {product} за {price}?",
        "daysAgo": "{count} дней назад",
        "hoursAgo": "{count} часов назад",
        "minutesAgo": "{count} минут назад",
        "accountDeletedSuccess": "Аккаунт успешно удален",
        "accountDeletionInfo": "Информация об удалении аккаунта",
        "accountDeletionWarning1": "Предупреждение: Это действие нельзя отменить",
        "accountDeletionWarning2": "Все ваши данные будут удалены навсегда",
        "accountDeletionWarning3": "Вы потеряете доступ ко всем разговорам",
        "accountDeletionWarning4": "Это включает весь купленный контент",
        "weekdays": "Вс,Пн,Вт,Ср,Чт,Пт,Сб"
    },
    "id": {
        "hapticFeedback": "Umpan balik haptik",
        "profileSettings": "Pengaturan profil",
        "profileSetup": "Menyiapkan profil",
        "purchaseConfirmMessage": "Konfirmasi pembelian {title} seharga {price}? {description}",
        "purchaseConfirmContent": "Beli {product} seharga {price}?",
        "daysAgo": "{count} hari yang lalu",
        "hoursAgo": "{count} jam yang lalu",
        "minutesAgo": "{count} menit yang lalu",
        "accountDeletedSuccess": "Akun berhasil dihapus",
        "accountDeletionInfo": "Informasi penghapusan akun",
        "accountDeletionWarning1": "Peringatan: Tindakan ini tidak dapat dibatalkan",
        "accountDeletionWarning2": "Semua data Anda akan dihapus permanen",
        "accountDeletionWarning3": "Anda akan kehilangan akses ke semua percakapan",
        "accountDeletionWarning4": "Ini termasuk semua konten yang dibeli",
        "weekdays": "Min,Sen,Sel,Rab,Kam,Jum,Sab"
    },
    "th": {
        "hapticFeedback": "การตอบสนองแบบสั่น",
        "profileSettings": "การตั้งค่าโปรไฟล์",
        "profileSetup": "กำลังตั้งค่าโปรไฟล์",
        "purchaseConfirmMessage": "ยืนยันการซื้อ {title} ในราคา {price}? {description}",
        "purchaseConfirmContent": "ซื้อ {product} ในราคา {price}?",
        "daysAgo": "{count} วันที่แล้ว",
        "hoursAgo": "{count} ชั่วโมงที่แล้ว",
        "minutesAgo": "{count} นาทีที่แล้ว",
        "accountDeletedSuccess": "ลบบัญชีสำเร็จแล้ว",
        "accountDeletionInfo": "ข้อมูลการลบบัญชี",
        "accountDeletionWarning1": "คำเตือน: การดำเนินการนี้ไม่สามารถยกเลิกได้",
        "accountDeletionWarning2": "ข้อมูลทั้งหมดของคุณจะถูกลบอย่างถาวร",
        "accountDeletionWarning3": "คุณจะสูญเสียการเข้าถึงบทสนทนาทั้งหมด",
        "accountDeletionWarning4": "รวมถึงเนื้อหาที่ซื้อทั้งหมด",
        "weekdays": "อา,จ,อ,พ,พฤ,ศ,ส"
    },
    "vi": {
        "hapticFeedback": "Phản hồi xúc giác",
        "profileSettings": "Cài đặt hồ sơ",
        "profileSetup": "Đang thiết lập hồ sơ",
        "purchaseConfirmMessage": "Xác nhận mua {title} với giá {price}? {description}",
        "purchaseConfirmContent": "Mua {product} với giá {price}?",
        "daysAgo": "{count} ngày trước",
        "hoursAgo": "{count} giờ trước",
        "minutesAgo": "{count} phút trước",
        "accountDeletedSuccess": "Tài khoản đã được xóa thành công",
        "accountDeletionInfo": "Thông tin xóa tài khoản",
        "accountDeletionWarning1": "Cảnh báo: Hành động này không thể hoàn tác",
        "accountDeletionWarning2": "Tất cả dữ liệu của bạn sẽ bị xóa vĩnh viễn",
        "accountDeletionWarning3": "Bạn sẽ mất quyền truy cập vào tất cả các cuộc trò chuyện",
        "accountDeletionWarning4": "Điều này bao gồm tất cả nội dung đã mua",
        "weekdays": "CN,T2,T3,T4,T5,T6,T7"
    }
}

# Additional translations for common missing keys
ADDITIONAL_TRANSLATIONS = {
    "vi": {
        "agreeToTerms": "Tôi đồng ý với các điều khoản",
        "appTagline": "Người bạn AI của bạn",
        "changeProfilePhoto": "Thay đổi ảnh hồ sơ",
        "checkInternetConnection": "Vui lòng kiểm tra kết nối internet",
        "copyrightInfringement": "Vi phạm bản quyền",
        "currentLanguage": "Ngôn ngữ hiện tại",
        "dailyLimitDescription": "Bạn đã đạt giới hạn tin nhắn hàng ngày",
        "dailyLimitTitle": "Đã đạt giới hạn hàng ngày"
    },
    "th": {
        "agreeToTerms": "ฉันยอมรับเงื่อนไข",
        "appTagline": "เพื่อน AI ของคุณ",
        "changeProfilePhoto": "เปลี่ยนรูปโปรไฟล์",
        "checkInternetConnection": "โปรดตรวจสอบการเชื่อมต่ออินเทอร์เน็ต",
        "copyrightInfringement": "การละเมิดลิขสิทธิ์",
        "currentLanguage": "ภาษาปัจจุบัน",
        "dailyLimitDescription": "คุณถึงขีดจำกัดข้อความต่อวันแล้ว",
        "dailyLimitTitle": "ถึงขีดจำกัดรายวันแล้ว"
    },
    "id": {
        "agreeToTerms": "Saya setuju dengan persyaratan",
        "appTagline": "Teman AI Anda",
        "changeProfilePhoto": "Ubah Foto Profil",
        "checkInternetConnection": "Silakan periksa koneksi internet Anda",
        "copyrightInfringement": "Pelanggaran hak cipta",
        "currentLanguage": "Bahasa Saat Ini",
        "dailyLimitDescription": "Anda telah mencapai batas pesan harian",
        "dailyLimitTitle": "Batas Harian Tercapai"
    }
}

def update_language_file(lang_code, translations):
    """Update a specific language ARB file with translations."""
    arb_file = Path(f"sona_app/lib/l10n/app_{lang_code}.arb")
    
    if not arb_file.exists():
        print(f"[SKIP] {arb_file} not found")
        return 0
    
    # Load the ARB file
    with open(arb_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    updated_count = 0
    
    # Update translations
    for key, value in translations.items():
        # Update if key exists and contains TODO or is in Korean when it shouldn't be
        if key in data:
            current_value = data[key]
            # Check if it needs updating
            if (f"[TODO-{lang_code.upper()}]" in str(current_value) or 
                (lang_code != 'ko' and key in ['hapticFeedback', 'profileSettings', 'profileSetup'] and 
                 any(korean_char in str(current_value) for korean_char in '가나다라마바사아자차카타파하'))):
                data[key] = value
                updated_count += 1
                print(f"  [{lang_code.upper()}] Updated: {key}")
    
    # Save the updated file
    if updated_count > 0:
        with open(arb_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        print(f"[OK] Updated {arb_file.name} with {updated_count} translations")
    
    return updated_count

def main():
    print("[Starting] Complete translation update for all languages...")
    print("="*60)
    
    total_updates = 0
    
    # Process each language
    for lang_code, translations in BASE_TRANSLATIONS.items():
        if lang_code == 'en':
            continue  # Skip English
        
        # Combine base and additional translations
        all_translations = translations.copy()
        if lang_code in ADDITIONAL_TRANSLATIONS:
            all_translations.update(ADDITIONAL_TRANSLATIONS[lang_code])
        
        print(f"\n[Processing] {lang_code.upper()}...")
        updates = update_language_file(lang_code, all_translations)
        total_updates += updates
    
    print("\n" + "="*60)
    print(f"[Summary] Total translations updated: {total_updates}")
    
    if total_updates > 0:
        # Regenerate localization files
        import os
        print("\n[Regenerating] Localization files...")
        result = os.system("cd sona_app && flutter gen-l10n")
        if result == 0:
            print("[OK] Localization files regenerated successfully")
        else:
            print("[WARNING] Error regenerating localization files")
    
    print("\n[Complete] All translations have been updated!")

if __name__ == "__main__":
    main()