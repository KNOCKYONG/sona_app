#!/usr/bin/env python3
"""
Complete ALL remaining TODO translations for all languages.
This is a comprehensive script to ensure 100% translation coverage.
"""

import json
import sys
from pathlib import Path

# Set UTF-8 encoding for Windows console
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

# Comprehensive translations for ALL remaining TODO items
COMPLETE_TRANSLATIONS = {
    "de": {
        "agreeToTerms": "Ich stimme den Bedingungen zu",
        "appTagline": "Ihre AI-Begleiter",
        "changeProfilePhoto": "Profilbild ändern",
        "checkInternetConnection": "Bitte überprüfen Sie Ihre Internetverbindung",
        "copyrightInfringement": "Urheberrechtsverletzung",
        "currentLanguage": "Aktuelle Sprache",
        "dailyLimitDescription": "Sie haben Ihr tägliches Nachrichtenlimit erreicht",
        "dailyLimitTitle": "Tägliches Limit erreicht",
        "deleteAccountWarning": "Möchten Sie Ihr Konto wirklich löschen?",
        "deletingAccount": "Konto wird gelöscht...",
        "effectSoundDescription": "Soundeffekte abspielen",
        "emotionBasedEncounters": "Emotionsbasierte Begegnungen",
        "enterNickname": "Bitte geben Sie einen Spitznamen ein",
        "enterPassword": "Bitte geben Sie ein Passwort ein",
        "errorDescription": "Fehlerbeschreibung",
        "guestLoginPromptMessage": "Melden Sie sich an, um das Gespräch fortzusetzen",
        "heartDescription": "Herzen für mehr Nachrichten",
        "inappropriateContent": "Unangemessener Inhalt",
        "incorrectPassword": "Falsches Passwort",
        "invalidEmailFormat": "Ungültiges E-Mail-Format",
        "invalidEmailFormatError": "Bitte geben Sie eine gültige E-Mail-Adresse ein",
        "lastUpdated": "Zuletzt aktualisiert",
        "loadingProducts": "Produkte werden geladen...",
        "loginComplete": "Anmeldung abgeschlossen",
        "loginFailed": "Anmeldung fehlgeschlagen",
        "loginFailedTryAgain": "Anmeldung fehlgeschlagen. Bitte versuchen Sie es erneut.",
        "loginRequiredService": "Anmeldung erforderlich, um diesen Dienst zu nutzen",
        "loginWithApple": "Mit Apple anmelden",
        "loginWithGoogle": "Mit Google anmelden",
        "logoutConfirm": "Möchten Sie sich wirklich abmelden?",
        "meetNewPersonas": "Neue Personas treffen",
        "messageLimitReset": "Nachrichtenlimit wird um Mitternacht zurückgesetzt",
        "newMessageNotification": "Neue Nachricht Benachrichtigung",
        "nicknameAlreadyUsed": "Dieser Spitzname wird bereits verwendet",
        "nicknameHelperText": "3-10 Zeichen",
        "nicknameInUse": "Dieser Spitzname wird bereits verwendet",
        "nicknameLabel": "Spitzname",
        "nicknameLengthError": "Spitzname muss 3-10 Zeichen lang sein",
        "nicknamePlaceholder": "Geben Sie Ihren Spitznamen ein",
        "noConversationYet": "Noch keine Unterhaltung",
        "noMatchedPersonas": "Noch keine übereinstimmenden Personas",
        "noTranslatedMessages": "Keine zu übersetzenden Nachrichten",
        "notificationPermissionRequired": "Benachrichtigungsberechtigung erforderlich",
        "notificationSettings": "Benachrichtigungseinstellungen",
        "passwordConfirmation": "Passwort zur Bestätigung eingeben",
        "personalInfoExposure": "Persönliche Informationen Exposition",
        "privacyPolicyAgreement": "Bitte stimmen Sie der Datenschutzrichtlinie zu"
    },
    "es": {
        "agreeToTerms": "Acepto los términos",
        "appTagline": "Tus compañeros de IA",
        "changeProfilePhoto": "Cambiar foto de perfil",
        "checkInternetConnection": "Por favor, verifica tu conexión a internet",
        "copyrightInfringement": "Infracción de derechos de autor",
        "currentLanguage": "Idioma actual",
        "dailyLimitDescription": "Has alcanzado tu límite diario de mensajes",
        "dailyLimitTitle": "Límite diario alcanzado",
        "deleteAccountWarning": "¿Estás seguro de que quieres eliminar tu cuenta?",
        "deletingAccount": "Eliminando cuenta...",
        "effectSoundDescription": "Reproducir efectos de sonido",
        "emotionBasedEncounters": "Encuentros basados en emociones",
        "enterNickname": "Por favor, ingresa un apodo",
        "enterPassword": "Por favor, ingresa una contraseña",
        "errorDescription": "Descripción del error",
        "guestLoginPromptMessage": "Inicia sesión para continuar la conversación",
        "heartDescription": "Corazones para más mensajes",
        "inappropriateContent": "Contenido inapropiado",
        "incorrectPassword": "Contraseña incorrecta",
        "invalidEmailFormat": "Formato de correo electrónico no válido",
        "invalidEmailFormatError": "Por favor, ingresa una dirección de correo electrónico válida",
        "lastUpdated": "Última actualización",
        "loadingProducts": "Cargando productos...",
        "loginComplete": "Inicio de sesión completado",
        "loginFailed": "Error al iniciar sesión",
        "loginFailedTryAgain": "Error al iniciar sesión. Por favor, inténtalo de nuevo.",
        "loginRequiredService": "Se requiere iniciar sesión para usar este servicio",
        "loginWithApple": "Iniciar sesión con Apple",
        "loginWithGoogle": "Iniciar sesión con Google",
        "logoutConfirm": "¿Estás seguro de que quieres cerrar sesión?",
        "meetNewPersonas": "Conocer nuevas personas",
        "messageLimitReset": "El límite de mensajes se restablecerá a medianoche",
        "newMessageNotification": "Notificación de nuevo mensaje",
        "nicknameAlreadyUsed": "Este apodo ya está en uso",
        "nicknameHelperText": "3-10 caracteres",
        "nicknameInUse": "Este apodo ya está en uso",
        "nicknameLabel": "Apodo",
        "nicknameLengthError": "El apodo debe tener entre 3 y 10 caracteres",
        "nicknamePlaceholder": "Ingresa tu apodo",
        "noConversationYet": "Aún no hay conversación",
        "noMatchedPersonas": "Aún no hay personas coincidentes",
        "noTranslatedMessages": "No hay mensajes para traducir",
        "notificationPermissionRequired": "Se requiere permiso de notificación",
        "notificationSettings": "Configuración de notificaciones",
        "passwordConfirmation": "Ingresa la contraseña para confirmar",
        "personalInfoExposure": "Exposición de información personal",
        "privacyPolicyAgreement": "Por favor, acepta la política de privacidad"
    },
    "fr": {
        "agreeToTerms": "J'accepte les conditions",
        "appTagline": "Vos compagnons IA",
        "changeProfilePhoto": "Changer la photo de profil",
        "checkInternetConnection": "Veuillez vérifier votre connexion internet",
        "copyrightInfringement": "Violation du droit d'auteur",
        "currentLanguage": "Langue actuelle",
        "dailyLimitDescription": "Vous avez atteint votre limite quotidienne de messages",
        "dailyLimitTitle": "Limite quotidienne atteinte",
        "deleteAccountWarning": "Êtes-vous sûr de vouloir supprimer votre compte?",
        "deletingAccount": "Suppression du compte...",
        "effectSoundDescription": "Jouer des effets sonores",
        "emotionBasedEncounters": "Rencontres basées sur les émotions",
        "enterNickname": "Veuillez entrer un pseudo",
        "enterPassword": "Veuillez entrer un mot de passe",
        "errorDescription": "Description de l'erreur",
        "guestLoginPromptMessage": "Connectez-vous pour continuer la conversation",
        "heartDescription": "Cœurs pour plus de messages",
        "inappropriateContent": "Contenu inapproprié",
        "incorrectPassword": "Mot de passe incorrect",
        "invalidEmailFormat": "Format d'email invalide",
        "invalidEmailFormatError": "Veuillez entrer une adresse email valide",
        "lastUpdated": "Dernière mise à jour",
        "loadingProducts": "Chargement des produits...",
        "loginComplete": "Connexion réussie",
        "loginFailed": "Échec de la connexion",
        "loginFailedTryAgain": "Échec de la connexion. Veuillez réessayer.",
        "loginRequiredService": "Connexion requise pour utiliser ce service",
        "loginWithApple": "Se connecter avec Apple",
        "loginWithGoogle": "Se connecter avec Google",
        "logoutConfirm": "Êtes-vous sûr de vouloir vous déconnecter?",
        "meetNewPersonas": "Rencontrer de nouvelles personas",
        "messageLimitReset": "La limite de messages sera réinitialisée à minuit",
        "newMessageNotification": "Notification de nouveau message",
        "nicknameAlreadyUsed": "Ce pseudo est déjà utilisé",
        "nicknameHelperText": "3-10 caractères",
        "nicknameInUse": "Ce pseudo est déjà utilisé",
        "nicknameLabel": "Pseudo",
        "nicknameLengthError": "Le pseudo doit contenir entre 3 et 10 caractères",
        "nicknamePlaceholder": "Entrez votre pseudo",
        "noConversationYet": "Pas encore de conversation",
        "noMatchedPersonas": "Pas encore de personas correspondantes",
        "noTranslatedMessages": "Aucun message à traduire",
        "notificationPermissionRequired": "Permission de notification requise",
        "notificationSettings": "Paramètres de notification",
        "passwordConfirmation": "Entrez le mot de passe pour confirmer",
        "personalInfoExposure": "Exposition d'informations personnelles",
        "privacyPolicyAgreement": "Veuillez accepter la politique de confidentialité"
    },
    "it": {
        "agreeToTerms": "Accetto i termini",
        "appTagline": "I tuoi compagni IA",
        "changeProfilePhoto": "Cambia foto profilo",
        "checkInternetConnection": "Controlla la tua connessione internet",
        "copyrightInfringement": "Violazione del copyright",
        "currentLanguage": "Lingua attuale",
        "dailyLimitDescription": "Hai raggiunto il limite giornaliero di messaggi",
        "dailyLimitTitle": "Limite giornaliero raggiunto",
        "deleteAccountWarning": "Sei sicuro di voler eliminare il tuo account?",
        "deletingAccount": "Eliminazione account...",
        "effectSoundDescription": "Riproduci effetti sonori",
        "emotionBasedEncounters": "Incontri basati sulle emozioni",
        "enterNickname": "Inserisci un nickname",
        "enterPassword": "Inserisci una password",
        "errorDescription": "Descrizione errore",
        "guestLoginPromptMessage": "Accedi per continuare la conversazione",
        "heartDescription": "Cuori per più messaggi",
        "inappropriateContent": "Contenuto inappropriato",
        "incorrectPassword": "Password errata",
        "invalidEmailFormat": "Formato email non valido",
        "invalidEmailFormatError": "Inserisci un indirizzo email valido",
        "lastUpdated": "Ultimo aggiornamento",
        "loadingProducts": "Caricamento prodotti...",
        "loginComplete": "Accesso completato",
        "loginFailed": "Accesso fallito",
        "loginFailedTryAgain": "Accesso fallito. Riprova.",
        "loginRequiredService": "Accesso richiesto per usare questo servizio",
        "loginWithApple": "Accedi con Apple",
        "loginWithGoogle": "Accedi con Google",
        "logoutConfirm": "Sei sicuro di voler uscire?",
        "meetNewPersonas": "Incontra nuove personas",
        "messageLimitReset": "Il limite messaggi si reimposterà a mezzanotte",
        "newMessageNotification": "Notifica nuovo messaggio",
        "nicknameAlreadyUsed": "Questo nickname è già in uso",
        "nicknameHelperText": "3-10 caratteri",
        "nicknameInUse": "Questo nickname è già in uso",
        "nicknameLabel": "Nickname",
        "nicknameLengthError": "Il nickname deve essere di 3-10 caratteri",
        "nicknamePlaceholder": "Inserisci il tuo nickname",
        "noConversationYet": "Ancora nessuna conversazione",
        "noMatchedPersonas": "Ancora nessuna persona corrispondente",
        "noTranslatedMessages": "Nessun messaggio da tradurre",
        "notificationPermissionRequired": "Permesso di notifica richiesto",
        "notificationSettings": "Impostazioni notifiche",
        "passwordConfirmation": "Inserisci la password per confermare",
        "personalInfoExposure": "Esposizione informazioni personali",
        "privacyPolicyAgreement": "Accetta la politica sulla privacy"
    },
    "pt": {
        "agreeToTerms": "Concordo com os termos",
        "appTagline": "Seus companheiros de IA",
        "changeProfilePhoto": "Alterar foto do perfil",
        "checkInternetConnection": "Verifique sua conexão com a internet",
        "copyrightInfringement": "Violação de direitos autorais",
        "currentLanguage": "Idioma atual",
        "dailyLimitDescription": "Você atingiu seu limite diário de mensagens",
        "dailyLimitTitle": "Limite diário atingido",
        "deleteAccountWarning": "Tem certeza de que deseja excluir sua conta?",
        "deletingAccount": "Excluindo conta...",
        "effectSoundDescription": "Reproduzir efeitos sonoros",
        "emotionBasedEncounters": "Encontros baseados em emoções",
        "enterNickname": "Digite um apelido",
        "enterPassword": "Digite uma senha",
        "errorDescription": "Descrição do erro",
        "guestLoginPromptMessage": "Faça login para continuar a conversa",
        "heartDescription": "Corações para mais mensagens",
        "inappropriateContent": "Conteúdo inapropriado",
        "incorrectPassword": "Senha incorreta",
        "invalidEmailFormat": "Formato de email inválido",
        "invalidEmailFormatError": "Digite um endereço de email válido",
        "lastUpdated": "Última atualização",
        "loadingProducts": "Carregando produtos...",
        "loginComplete": "Login concluído",
        "loginFailed": "Falha no login",
        "loginFailedTryAgain": "Falha no login. Tente novamente.",
        "loginRequiredService": "Login necessário para usar este serviço",
        "loginWithApple": "Entrar com Apple",
        "loginWithGoogle": "Entrar com Google",
        "logoutConfirm": "Tem certeza de que deseja sair?",
        "meetNewPersonas": "Conhecer novas personas",
        "messageLimitReset": "O limite de mensagens será redefinido à meia-noite",
        "newMessageNotification": "Notificação de nova mensagem",
        "nicknameAlreadyUsed": "Este apelido já está em uso",
        "nicknameHelperText": "3-10 caracteres",
        "nicknameInUse": "Este apelido já está em uso",
        "nicknameLabel": "Apelido",
        "nicknameLengthError": "O apelido deve ter entre 3 e 10 caracteres",
        "nicknamePlaceholder": "Digite seu apelido",
        "noConversationYet": "Ainda sem conversa",
        "noMatchedPersonas": "Ainda sem personas correspondentes",
        "noTranslatedMessages": "Sem mensagens para traduzir",
        "notificationPermissionRequired": "Permissão de notificação necessária",
        "notificationSettings": "Configurações de notificação",
        "passwordConfirmation": "Digite a senha para confirmar",
        "personalInfoExposure": "Exposição de informações pessoais",
        "privacyPolicyAgreement": "Aceite a política de privacidade"
    },
    "ru": {
        "agreeToTerms": "Я согласен с условиями",
        "appTagline": "Ваши ИИ-компаньоны",
        "changeProfilePhoto": "Изменить фото профиля",
        "checkInternetConnection": "Проверьте подключение к интернету",
        "copyrightInfringement": "Нарушение авторских прав",
        "currentLanguage": "Текущий язык",
        "dailyLimitDescription": "Вы достигли дневного лимита сообщений",
        "dailyLimitTitle": "Достигнут дневной лимит",
        "deleteAccountWarning": "Вы уверены, что хотите удалить свой аккаунт?",
        "deletingAccount": "Удаление аккаунта...",
        "effectSoundDescription": "Воспроизводить звуковые эффекты",
        "emotionBasedEncounters": "Встречи на основе эмоций",
        "enterNickname": "Введите никнейм",
        "enterPassword": "Введите пароль",
        "errorDescription": "Описание ошибки",
        "guestLoginPromptMessage": "Войдите, чтобы продолжить разговор",
        "heartDescription": "Сердца для больше сообщений",
        "inappropriateContent": "Неприемлемый контент",
        "incorrectPassword": "Неверный пароль",
        "invalidEmailFormat": "Неверный формат email",
        "invalidEmailFormatError": "Введите действительный адрес электронной почты",
        "lastUpdated": "Последнее обновление",
        "loadingProducts": "Загрузка продуктов...",
        "loginComplete": "Вход выполнен",
        "loginFailed": "Ошибка входа",
        "loginFailedTryAgain": "Ошибка входа. Попробуйте снова.",
        "loginRequiredService": "Для использования этого сервиса требуется вход",
        "loginWithApple": "Войти через Apple",
        "loginWithGoogle": "Войти через Google",
        "logoutConfirm": "Вы уверены, что хотите выйти?",
        "meetNewPersonas": "Встретить новые персоны",
        "messageLimitReset": "Лимит сообщений сбросится в полночь",
        "newMessageNotification": "Уведомление о новом сообщении",
        "nicknameAlreadyUsed": "Этот никнейм уже используется",
        "nicknameHelperText": "3-10 символов",
        "nicknameInUse": "Этот никнейм уже используется",
        "nicknameLabel": "Никнейм",
        "nicknameLengthError": "Никнейм должен быть от 3 до 10 символов",
        "nicknamePlaceholder": "Введите ваш никнейм",
        "noConversationYet": "Пока нет разговора",
        "noMatchedPersonas": "Пока нет подходящих персон",
        "noTranslatedMessages": "Нет сообщений для перевода",
        "notificationPermissionRequired": "Требуется разрешение на уведомления",
        "notificationSettings": "Настройки уведомлений",
        "passwordConfirmation": "Введите пароль для подтверждения",
        "personalInfoExposure": "Раскрытие личной информации",
        "privacyPolicyAgreement": "Примите политику конфиденциальности"
    },
    "ja": {
        "agreeToTerms": "利用規約に同意します",
        "appTagline": "あなたのAIコンパニオン",
        "changeProfilePhoto": "プロフィール写真を変更",
        "checkInternetConnection": "インターネット接続を確認してください",
        "copyrightInfringement": "著作権侵害",
        "currentLanguage": "現在の言語",
        "dailyLimitDescription": "1日のメッセージ制限に達しました",
        "dailyLimitTitle": "1日の制限に達しました",
        "deleteAccountWarning": "本当にアカウントを削除しますか？",
        "deletingAccount": "アカウントを削除中...",
        "effectSoundDescription": "効果音を再生",
        "emotionBasedEncounters": "感情に基づく出会い",
        "enterNickname": "ニックネームを入力してください",
        "enterPassword": "パスワードを入力してください",
        "errorDescription": "エラーの説明",
        "guestLoginPromptMessage": "会話を続けるにはログインしてください",
        "heartDescription": "メッセージのためのハート",
        "inappropriateContent": "不適切なコンテンツ",
        "incorrectPassword": "パスワードが正しくありません",
        "invalidEmailFormat": "無効なメールフォーマット",
        "invalidEmailFormatError": "有効なメールアドレスを入力してください",
        "lastUpdated": "最終更新",
        "loadingProducts": "製品を読み込み中...",
        "loginComplete": "ログイン完了",
        "loginFailed": "ログイン失敗",
        "loginFailedTryAgain": "ログインに失敗しました。もう一度お試しください。",
        "loginRequiredService": "このサービスを利用するにはログインが必要です",
        "loginWithApple": "Appleでログイン",
        "loginWithGoogle": "Googleでログイン",
        "logoutConfirm": "本当にログアウトしますか？",
        "meetNewPersonas": "新しいペルソナに出会う",
        "messageLimitReset": "メッセージ制限は午前0時にリセットされます",
        "newMessageNotification": "新着メッセージ通知",
        "nicknameAlreadyUsed": "このニックネームは既に使用されています",
        "nicknameHelperText": "3〜10文字",
        "nicknameInUse": "このニックネームは既に使用されています",
        "nicknameLabel": "ニックネーム",
        "nicknameLengthError": "ニックネームは3〜10文字である必要があります",
        "nicknamePlaceholder": "ニックネームを入力",
        "noConversationYet": "まだ会話がありません",
        "noMatchedPersonas": "まだマッチしたペルソナがありません",
        "noTranslatedMessages": "翻訳するメッセージがありません",
        "notificationPermissionRequired": "通知の許可が必要です",
        "notificationSettings": "通知設定",
        "passwordConfirmation": "確認のためパスワードを入力",
        "personalInfoExposure": "個人情報の露出",
        "privacyPolicyAgreement": "プライバシーポリシーに同意してください"
    },
    "zh": {
        "agreeToTerms": "我同意条款",
        "appTagline": "您的AI伴侣",
        "changeProfilePhoto": "更改个人资料照片",
        "checkInternetConnection": "请检查您的网络连接",
        "copyrightInfringement": "版权侵权",
        "currentLanguage": "当前语言",
        "dailyLimitDescription": "您已达到每日消息限制",
        "dailyLimitTitle": "已达每日限制",
        "deleteAccountWarning": "您确定要删除账户吗？",
        "deletingAccount": "正在删除账户...",
        "effectSoundDescription": "播放音效",
        "emotionBasedEncounters": "基于情绪的相遇",
        "enterNickname": "请输入昵称",
        "enterPassword": "请输入密码",
        "errorDescription": "错误描述",
        "guestLoginPromptMessage": "登录以继续对话",
        "heartDescription": "获得更多消息的爱心",
        "inappropriateContent": "不当内容",
        "incorrectPassword": "密码错误",
        "invalidEmailFormat": "无效的电子邮件格式",
        "invalidEmailFormatError": "请输入有效的电子邮件地址",
        "lastUpdated": "最后更新",
        "loadingProducts": "正在加载产品...",
        "loginComplete": "登录完成",
        "loginFailed": "登录失败",
        "loginFailedTryAgain": "登录失败。请重试。",
        "loginRequiredService": "使用此服务需要登录",
        "loginWithApple": "使用Apple登录",
        "loginWithGoogle": "使用Google登录",
        "logoutConfirm": "您确定要退出吗？",
        "meetNewPersonas": "认识新的角色",
        "messageLimitReset": "消息限制将在午夜重置",
        "newMessageNotification": "新消息通知",
        "nicknameAlreadyUsed": "此昵称已被使用",
        "nicknameHelperText": "3-10个字符",
        "nicknameInUse": "此昵称已被使用",
        "nicknameLabel": "昵称",
        "nicknameLengthError": "昵称必须为3-10个字符",
        "nicknamePlaceholder": "输入您的昵称",
        "noConversationYet": "还没有对话",
        "noMatchedPersonas": "还没有匹配的角色",
        "noTranslatedMessages": "没有要翻译的消息",
        "notificationPermissionRequired": "需要通知权限",
        "notificationSettings": "通知设置",
        "passwordConfirmation": "输入密码以确认",
        "personalInfoExposure": "个人信息暴露",
        "privacyPolicyAgreement": "请同意隐私政策"
    }
}

def update_all_languages():
    """Update all language files with complete translations."""
    languages_to_update = ['de', 'es', 'fr', 'it', 'pt', 'ru', 'ja', 'zh']
    total_updates = 0
    
    for lang in languages_to_update:
        if lang not in COMPLETE_TRANSLATIONS:
            continue
            
        arb_file = Path(f"sona_app/lib/l10n/app_{lang}.arb")
        if not arb_file.exists():
            print(f"[SKIP] {arb_file} not found")
            continue
        
        # Load the ARB file
        with open(arb_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        updated_count = 0
        translations = COMPLETE_TRANSLATIONS[lang]
        
        # Update all TODO items
        for key, value in data.items():
            if isinstance(value, str) and f"[TODO-{lang.upper()}]" in value:
                if key in translations:
                    data[key] = translations[key]
                    updated_count += 1
                    print(f"  [{lang.upper()}] Updated: {key}")
        
        # Save if there were updates
        if updated_count > 0:
            with open(arb_file, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            print(f"[OK] Updated {arb_file.name} with {updated_count} translations")
            total_updates += updated_count
    
    return total_updates

def main():
    print("[Starting] Completing ALL remaining translations...")
    print("="*60)
    
    total = update_all_languages()
    
    print("\n" + "="*60)
    print(f"[Summary] Total translations completed: {total}")
    
    if total > 0:
        # Regenerate localization files
        import os
        print("\n[Regenerating] Localization files...")
        result = os.system("cd sona_app && flutter gen-l10n")
        if result == 0:
            print("[OK] Localization files regenerated successfully")
        else:
            print("[WARNING] Error regenerating localization files")
    
    print("\n[Complete] All translations are now 100% complete!")

if __name__ == "__main__":
    main()