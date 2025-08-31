#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Multi-language Translation Script for SONA App
Creates Spanish, French, German, Russian, Portuguese, and Italian translations
"""

import json
from pathlib import Path

def create_spanish_translation(ko_data, l10n_dir):
    """Create Spanish translation"""
    es_translations = {
        "appName": "SONA",
        "loading": "Cargando...",
        "error": "Error",
        "retry": "Reintentar",
        "cancel": "Cancelar",
        "confirm": "Confirmar",
        "next": "Siguiente",
        "skip": "Omitir",
        "done": "Hecho",
        "save": "Guardar",
        "delete": "Eliminar",
        "edit": "Editar",
        "close": "Cerrar",
        "search": "Buscar",
        "filter": "Filtrar",
        "sort": "Ordenar",
        "refresh": "Actualizar",
        "yes": "Sí",
        "no": "No",
        "you": "Tú",
        "login": "Iniciar sesión",
        "signup": "Registrarse",
        "meetAIPersonas": "Conoce a las Personas IA",
        "welcomeMessage": "¡Bienvenido!💕",
        "loginSignup": "Iniciar sesión/Registrarse",
        "logout": "Cerrar sesión",
        "email": "Correo electrónico",
        "password": "Contraseña",
        "confirmPassword": "Confirmar contraseña",
        "nickname": "Apodo",
        "forgotPassword": "¿Olvidaste tu contraseña?",
        "alreadyHaveAccount": "¿Ya tienes cuenta?",
        "dontHaveAccount": "¿No tienes cuenta?",
        "continueWithGoogle": "Continuar con Google",
        "continueWithApple": "Continuar con Apple",
        "or": "o",
        "termsOfService": "Términos de servicio",
        "privacyPolicy": "Política de privacidad",
        "agreeToTerms": "Al registrarte, aceptas nuestros {terms} y {privacy}",
        "emailRequired": "Por favor ingresa el correo",
        "passwordRequired": "Por favor ingresa la contraseña",
        "nicknameRequired": "Por favor ingresa el apodo",
        "invalidEmail": "Correo inválido",
        "passwordTooShort": "La contraseña debe tener al menos 6 caracteres",
        "passwordMismatch": "Las contraseñas no coinciden",
        "loginFailed": "Error al iniciar sesión",
        "signupFailed": "Error al registrarse",
        "emailAlreadyInUse": "El correo ya está en uso",
        "weakPassword": "Contraseña muy débil",
        "userNotFound": "Usuario no encontrado",
        "wrongPassword": "Contraseña incorrecta",
        "networkError": "Error de red",
        "unknownError": "Error desconocido",
        "profile": "Perfil",
        "settings": "Configuración",
        "notifications": "Notificaciones",
        "language": "Idioma",
        "theme": "Tema",
        "darkMode": "Modo oscuro",
        "lightMode": "Modo claro",
        "systemDefault": "Predeterminado del sistema",
        "about": "Acerca de",
        "version": "Versión",
        "contactUs": "Contáctanos",
        "reportBug": "Reportar error",
        "rateApp": "Calificar aplicación",
        "shareApp": "Compartir aplicación",
        "chat": "Chat",
        "personas": "Personas",
        "store": "Tienda",
        "heart": "Corazón",
        "hearts": "Corazones",
        "coin": "Moneda",
        "coins": "Monedas",
        "level": "Nivel",
        "experience": "Experiencia",
        "achievement": "Logro",
        "achievements": "Logros",
        "reward": "Recompensa",
        "rewards": "Recompensas",
        "daily": "Diario",
        "weekly": "Semanal",
        "monthly": "Mensual",
        "newMessage": "Nuevo mensaje",
        "typeMessage": "Escribe un mensaje...",
        "send": "Enviar",
        "sending": "Enviando...",
        "sent": "Enviado",
        "delivered": "Entregado",
        "read": "Leído",
        "online": "En línea",
        "offline": "Desconectado",
        "lastSeen": "Última vez visto",
        "typing": "Escribiendo...",
        "recording": "Grabando...",
        "photo": "Foto",
        "camera": "Cámara",
        "gallery": "Galería",
        "file": "Archivo",
        "location": "Ubicación",
        "voice": "Voz",
        "video": "Video",
        "monday": "Lunes",
        "tuesday": "Martes",
        "wednesday": "Miércoles",
        "thursday": "Jueves",
        "friday": "Viernes",
        "saturday": "Sábado",
        "sunday": "Domingo",
        "january": "Enero",
        "february": "Febrero",
        "march": "Marzo",
        "april": "Abril",
        "may": "Mayo",
        "june": "Junio",
        "july": "Julio",
        "august": "Agosto",
        "september": "Septiembre",
        "october": "Octubre",
        "november": "Noviembre",
        "december": "Diciembre",
        "today": "Hoy",
        "yesterday": "Ayer",
        "tomorrow": "Mañana",
        "now": "Ahora",
        "justNow": "Justo ahora",
        "minutesAgo": "Hace {count} minutos",
        "hoursAgo": "Hace {count} horas",
        "daysAgo": "Hace {count} días",
        "weeksAgo": "Hace {count} semanas",
        "monthsAgo": "Hace {count} meses",
        "yearsAgo": "Hace {count} años",
    }
    
    # Create Spanish ARB
    es_data = {"@@locale": "es"}
    for key, value in ko_data.items():
        if key.startswith("@@"):
            if key == "@@locale":
                es_data[key] = "es"
            else:
                es_data[key] = value
        elif key.startswith("@"):
            es_data[key] = value
        else:
            es_data[key] = es_translations.get(key, value)
    
    # Write Spanish ARB
    es_arb_path = l10n_dir / "app_es.arb"
    with open(es_arb_path, 'w', encoding='utf-8') as f:
        json.dump(es_data, f, ensure_ascii=False, indent=2)
    
    print(f"[OK] Spanish ARB created: {es_arb_path}")
    return es_arb_path

def create_french_translation(ko_data, l10n_dir):
    """Create French translation"""
    fr_translations = {
        "appName": "SONA",
        "loading": "Chargement...",
        "error": "Erreur",
        "retry": "Réessayer",
        "cancel": "Annuler",
        "confirm": "Confirmer",
        "next": "Suivant",
        "skip": "Passer",
        "done": "Terminé",
        "save": "Enregistrer",
        "delete": "Supprimer",
        "edit": "Modifier",
        "close": "Fermer",
        "search": "Rechercher",
        "filter": "Filtrer",
        "sort": "Trier",
        "refresh": "Actualiser",
        "yes": "Oui",
        "no": "Non",
        "you": "Vous",
        "login": "Connexion",
        "signup": "Inscription",
        "logout": "Déconnexion",
        "email": "E-mail",
        "password": "Mot de passe",
        "profile": "Profil",
        "settings": "Paramètres",
        "notifications": "Notifications",
        "language": "Langue",
        "theme": "Thème",
        "chat": "Chat",
        "send": "Envoyer",
        "today": "Aujourd'hui",
        "yesterday": "Hier",
        "tomorrow": "Demain",
    }
    
    # Create French ARB
    fr_data = {"@@locale": "fr"}
    for key, value in ko_data.items():
        if key.startswith("@@"):
            if key == "@@locale":
                fr_data[key] = "fr"
            else:
                fr_data[key] = value
        elif key.startswith("@"):
            fr_data[key] = value
        else:
            fr_data[key] = fr_translations.get(key, value)
    
    # Write French ARB
    fr_arb_path = l10n_dir / "app_fr.arb"
    with open(fr_arb_path, 'w', encoding='utf-8') as f:
        json.dump(fr_data, f, ensure_ascii=False, indent=2)
    
    print(f"[OK] French ARB created: {fr_arb_path}")
    return fr_arb_path

def create_german_translation(ko_data, l10n_dir):
    """Create German translation"""
    de_translations = {
        "appName": "SONA",
        "loading": "Lädt...",
        "error": "Fehler",
        "retry": "Wiederholen",
        "cancel": "Abbrechen",
        "confirm": "Bestätigen",
        "next": "Weiter",
        "skip": "Überspringen",
        "done": "Fertig",
        "save": "Speichern",
        "delete": "Löschen",
        "edit": "Bearbeiten",
        "close": "Schließen",
        "search": "Suchen",
        "yes": "Ja",
        "no": "Nein",
        "login": "Anmelden",
        "signup": "Registrieren",
        "logout": "Abmelden",
        "profile": "Profil",
        "settings": "Einstellungen",
        "language": "Sprache",
    }
    
    # Create German ARB
    de_data = {"@@locale": "de"}
    for key, value in ko_data.items():
        if key.startswith("@@"):
            if key == "@@locale":
                de_data[key] = "de"
            else:
                de_data[key] = value
        elif key.startswith("@"):
            de_data[key] = value
        else:
            de_data[key] = de_translations.get(key, value)
    
    # Write German ARB
    de_arb_path = l10n_dir / "app_de.arb"
    with open(de_arb_path, 'w', encoding='utf-8') as f:
        json.dump(de_data, f, ensure_ascii=False, indent=2)
    
    print(f"[OK] German ARB created: {de_arb_path}")
    return de_arb_path

def create_russian_translation(ko_data, l10n_dir):
    """Create Russian translation"""
    ru_translations = {
        "appName": "SONA",
        "loading": "Загрузка...",
        "error": "Ошибка",
        "retry": "Повторить",
        "cancel": "Отмена",
        "confirm": "Подтвердить",
        "next": "Далее",
        "skip": "Пропустить",
        "done": "Готово",
        "save": "Сохранить",
        "delete": "Удалить",
        "edit": "Редактировать",
        "close": "Закрыть",
        "search": "Поиск",
        "yes": "Да",
        "no": "Нет",
        "login": "Войти",
        "signup": "Регистрация",
        "logout": "Выйти",
        "profile": "Профиль",
        "settings": "Настройки",
        "language": "Язык",
    }
    
    # Create Russian ARB
    ru_data = {"@@locale": "ru"}
    for key, value in ko_data.items():
        if key.startswith("@@"):
            if key == "@@locale":
                ru_data[key] = "ru"
            else:
                ru_data[key] = value
        elif key.startswith("@"):
            ru_data[key] = value
        else:
            ru_data[key] = ru_translations.get(key, value)
    
    # Write Russian ARB
    ru_arb_path = l10n_dir / "app_ru.arb"
    with open(ru_arb_path, 'w', encoding='utf-8') as f:
        json.dump(ru_data, f, ensure_ascii=False, indent=2)
    
    print(f"[OK] Russian ARB created: {ru_arb_path}")
    return ru_arb_path

def create_portuguese_translation(ko_data, l10n_dir):
    """Create Portuguese translation"""
    pt_translations = {
        "appName": "SONA",
        "loading": "Carregando...",
        "error": "Erro",
        "retry": "Tentar novamente",
        "cancel": "Cancelar",
        "confirm": "Confirmar",
        "next": "Próximo",
        "skip": "Pular",
        "done": "Concluído",
        "save": "Salvar",
        "delete": "Excluir",
        "edit": "Editar",
        "close": "Fechar",
        "search": "Pesquisar",
        "yes": "Sim",
        "no": "Não",
        "login": "Entrar",
        "signup": "Cadastrar",
        "logout": "Sair",
        "profile": "Perfil",
        "settings": "Configurações",
        "language": "Idioma",
    }
    
    # Create Portuguese ARB
    pt_data = {"@@locale": "pt"}
    for key, value in ko_data.items():
        if key.startswith("@@"):
            if key == "@@locale":
                pt_data[key] = "pt"
            else:
                pt_data[key] = value
        elif key.startswith("@"):
            pt_data[key] = value
        else:
            pt_data[key] = pt_translations.get(key, value)
    
    # Write Portuguese ARB
    pt_arb_path = l10n_dir / "app_pt.arb"
    with open(pt_arb_path, 'w', encoding='utf-8') as f:
        json.dump(pt_data, f, ensure_ascii=False, indent=2)
    
    print(f"[OK] Portuguese ARB created: {pt_arb_path}")
    return pt_arb_path

def create_italian_translation(ko_data, l10n_dir):
    """Create Italian translation"""
    it_translations = {
        "appName": "SONA",
        "loading": "Caricamento...",
        "error": "Errore",
        "retry": "Riprova",
        "cancel": "Annulla",
        "confirm": "Conferma",
        "next": "Avanti",
        "skip": "Salta",
        "done": "Fatto",
        "save": "Salva",
        "delete": "Elimina",
        "edit": "Modifica",
        "close": "Chiudi",
        "search": "Cerca",
        "yes": "Sì",
        "no": "No",
        "login": "Accedi",
        "signup": "Registrati",
        "logout": "Esci",
        "profile": "Profilo",
        "settings": "Impostazioni",
        "language": "Lingua",
    }
    
    # Create Italian ARB
    it_data = {"@@locale": "it"}
    for key, value in ko_data.items():
        if key.startswith("@@"):
            if key == "@@locale":
                it_data[key] = "it"
            else:
                it_data[key] = value
        elif key.startswith("@"):
            it_data[key] = value
        else:
            it_data[key] = it_translations.get(key, value)
    
    # Write Italian ARB
    it_arb_path = l10n_dir / "app_it.arb"
    with open(it_arb_path, 'w', encoding='utf-8') as f:
        json.dump(it_data, f, ensure_ascii=False, indent=2)
    
    print(f"[OK] Italian ARB created: {it_arb_path}")
    return it_arb_path

def main():
    """Create all language translations"""
    
    # Paths
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    l10n_dir = project_root / "sona_app" / "lib" / "l10n"
    
    ko_arb_path = l10n_dir / "app_ko.arb"
    
    # Read Korean ARB
    with open(ko_arb_path, 'r', encoding='utf-8') as f:
        ko_data = json.load(f)
    
    print("Creating language translations...")
    print("-" * 50)
    
    # Create all translations
    languages_created = []
    
    try:
        es_path = create_spanish_translation(ko_data, l10n_dir)
        languages_created.append("Spanish (es)")
    except Exception as e:
        print(f"[ERROR] Error creating Spanish: {e}")
    
    try:
        fr_path = create_french_translation(ko_data, l10n_dir)
        languages_created.append("French (fr)")
    except Exception as e:
        print(f"[ERROR] Error creating French: {e}")
    
    try:
        de_path = create_german_translation(ko_data, l10n_dir)
        languages_created.append("German (de)")
    except Exception as e:
        print(f"[ERROR] Error creating German: {e}")
    
    try:
        ru_path = create_russian_translation(ko_data, l10n_dir)
        languages_created.append("Russian (ru)")
    except Exception as e:
        print(f"[ERROR] Error creating Russian: {e}")
    
    try:
        pt_path = create_portuguese_translation(ko_data, l10n_dir)
        languages_created.append("Portuguese (pt)")
    except Exception as e:
        print(f"[ERROR] Error creating Portuguese: {e}")
    
    try:
        it_path = create_italian_translation(ko_data, l10n_dir)
        languages_created.append("Italian (it)")
    except Exception as e:
        print(f"[ERROR] Error creating Italian: {e}")
    
    print("-" * 50)
    print(f"\n[SUCCESS] Successfully created {len(languages_created)} language files:")
    for lang in languages_created:
        print(f"   - {lang}")
    
    print("\n[NOTE] Note: These are basic translations. Professional translation is recommended for production use.")
    
    return languages_created

if __name__ == "__main__":
    main()