import 'package:flutter_test/flutter_test.dart';
import 'package:sona_app/services/chat/localization/language_detector.dart';

void main() {
  group('Language Detection Tests', () {
    group('Script-based detection (Non-Latin)', () {
      test('Korean (KO) - Hangul', () {
        expect(LanguageDetector.detectLanguageFromText('안녕하세요'), equals('KO'));
        expect(LanguageDetector.detectLanguageFromText('오늘 날씨 어때?'), equals('KO'));
        expect(LanguageDetector.detectLanguageFromText('배고파'), equals('KO'));
      });
      
      test('Thai (TH) - Thai script', () {
        expect(LanguageDetector.detectLanguageFromText('สวัสดีครับ'), equals('TH'));
        expect(LanguageDetector.detectLanguageFromText('คุณสบายดีไหม'), equals('TH'));
        expect(LanguageDetector.detectLanguageFromText('ขอบคุณมาก'), equals('TH'));
      });
      
      test('Arabic (AR) - Arabic script', () {
        expect(LanguageDetector.detectLanguageFromText('مرحبا'), equals('AR'));
        expect(LanguageDetector.detectLanguageFromText('كيف حالك'), equals('AR'));
        expect(LanguageDetector.detectLanguageFromText('شكرا لك'), equals('AR'));
      });
      
      test('Hindi (HI) - Devanagari script', () {
        expect(LanguageDetector.detectLanguageFromText('नमस्ते'), equals('HI'));
        expect(LanguageDetector.detectLanguageFromText('आप कैसे हैं'), equals('HI'));
        expect(LanguageDetector.detectLanguageFromText('धन्यवाद'), equals('HI'));
      });
      
      test('Chinese (ZH) - Chinese characters', () {
        expect(LanguageDetector.detectLanguageFromText('你好'), equals('ZH'));
        expect(LanguageDetector.detectLanguageFromText('今天天气怎么样'), equals('ZH'));
        expect(LanguageDetector.detectLanguageFromText('谢谢你'), equals('ZH'));
      });
      
      test('Japanese (JA) - Hiragana/Katakana', () {
        expect(LanguageDetector.detectLanguageFromText('こんにちは'), equals('JA'));
        expect(LanguageDetector.detectLanguageFromText('ありがとう'), equals('JA'));
        expect(LanguageDetector.detectLanguageFromText('カタカナ'), equals('JA'));
        expect(LanguageDetector.detectLanguageFromText('おはよう'), equals('JA'));
      });
      
      test('Russian (RU) - Cyrillic script', () {
        expect(LanguageDetector.detectLanguageFromText('привет'), equals('RU'));
        expect(LanguageDetector.detectLanguageFromText('как дела'), equals('RU'));
        expect(LanguageDetector.detectLanguageFromText('спасибо'), equals('RU'));
      });
      
      test('Urdu (UR) - Arabic script with Urdu markers', () {
        expect(LanguageDetector.detectLanguageFromText('آپ کیا کر رہے ہیں'), equals('UR'));
        expect(LanguageDetector.detectLanguageFromText('میں ٹھیک ہوں'), equals('UR'));
        expect(LanguageDetector.detectLanguageFromText('شکریہ'), equals('UR'));
      });
    });
    
    group('Keyword-based detection (Latin script)', () {
      test('English (EN)', () {
        expect(LanguageDetector.detectLanguageFromText('hello how are you'), equals('EN'));
        expect(LanguageDetector.detectLanguageFromText('thanks for your help'), equals('EN'));
        expect(LanguageDetector.detectLanguageFromText('what time is it'), equals('EN'));
        expect(LanguageDetector.detectLanguageFromText('good morning'), equals('EN'));
      });
      
      test('Vietnamese (VI)', () {
        expect(LanguageDetector.detectLanguageFromText('xin chào'), equals('VI'));
        expect(LanguageDetector.detectLanguageFromText('cảm ơn bạn'), equals('VI'));
        expect(LanguageDetector.detectLanguageFromText('tôi mệt quá'), equals('VI'));
        expect(LanguageDetector.detectLanguageFromText('làm việc rồi'), equals('VI'));
      });
      
      test('Indonesian (ID)', () {
        expect(LanguageDetector.detectLanguageFromText('aku kerja lembur'), equals('ID'));
        expect(LanguageDetector.detectLanguageFromText('selamat pagi'), equals('ID'));
        expect(LanguageDetector.detectLanguageFromText('terima kasih banyak'), equals('ID'));
        expect(LanguageDetector.detectLanguageFromText('bagaimana kabar'), equals('ID'));
      });
      
      test('Malay (MS)', () {
        expect(LanguageDetector.detectLanguageFromText('hai apa khabar'), equals('MS'));
        expect(LanguageDetector.detectLanguageFromText('terima kasih'), equals('MS'));
        expect(LanguageDetector.detectLanguageFromText('saya penat'), equals('MS'));
        expect(LanguageDetector.detectLanguageFromText('awak kerja'), equals('MS'));
      });
      
      test('Spanish (ES)', () {
        expect(LanguageDetector.detectLanguageFromText('hola cómo estás'), equals('ES'));
        expect(LanguageDetector.detectLanguageFromText('gracias por todo'), equals('ES'));
        expect(LanguageDetector.detectLanguageFromText('estoy cansado'), equals('ES'));
        expect(LanguageDetector.detectLanguageFromText('buenos días'), equals('ES'));
      });
      
      test('French (FR)', () {
        expect(LanguageDetector.detectLanguageFromText('bonjour comment allez vous'), equals('FR'));
        expect(LanguageDetector.detectLanguageFromText('merci beaucoup'), equals('FR'));
        expect(LanguageDetector.detectLanguageFromText('je suis fatigué'), equals('FR'));
        expect(LanguageDetector.detectLanguageFromText('au travail'), equals('FR'));
      });
      
      test('German (DE)', () {
        expect(LanguageDetector.detectLanguageFromText('hallo wie geht es dir'), equals('DE'));
        expect(LanguageDetector.detectLanguageFromText('danke schön'), equals('DE'));
        expect(LanguageDetector.detectLanguageFromText('ich bin müde'), equals('DE'));
        expect(LanguageDetector.detectLanguageFromText('guten morgen'), equals('DE'));
      });
      
      test('Italian (IT)', () {
        expect(LanguageDetector.detectLanguageFromText('ciao come stai'), equals('IT'));
        expect(LanguageDetector.detectLanguageFromText('grazie mille'), equals('IT'));
        expect(LanguageDetector.detectLanguageFromText('sono stanco'), equals('IT'));
        expect(LanguageDetector.detectLanguageFromText('buon giorno'), equals('IT'));
      });
      
      test('Portuguese (PT)', () {
        expect(LanguageDetector.detectLanguageFromText('olá como está'), equals('PT'));
        expect(LanguageDetector.detectLanguageFromText('obrigado'), equals('PT'));
        expect(LanguageDetector.detectLanguageFromText('estou cansado'), equals('PT'));
        expect(LanguageDetector.detectLanguageFromText('bom dia'), equals('PT'));
      });
      
      test('Turkish (TR)', () {
        expect(LanguageDetector.detectLanguageFromText('merhaba nasılsın'), equals('TR'));
        expect(LanguageDetector.detectLanguageFromText('teşekkür ederim'), equals('TR'));
        expect(LanguageDetector.detectLanguageFromText('yorgunum'), equals('TR'));
        expect(LanguageDetector.detectLanguageFromText('günaydın'), equals('TR'));
      });
      
      test('Dutch (NL)', () {
        expect(LanguageDetector.detectLanguageFromText('hallo hoe gaat het'), equals('NL'));
        expect(LanguageDetector.detectLanguageFromText('bedankt'), equals('NL'));
        expect(LanguageDetector.detectLanguageFromText('ik ben moe'), equals('NL'));
        expect(LanguageDetector.detectLanguageFromText('goedemorgen'), equals('NL'));
      });
      
      test('Swedish (SV)', () {
        expect(LanguageDetector.detectLanguageFromText('hej hur mår du'), equals('SV'));
        expect(LanguageDetector.detectLanguageFromText('tack så mycket'), equals('SV'));
        expect(LanguageDetector.detectLanguageFromText('jag är trött'), equals('SV'));
        expect(LanguageDetector.detectLanguageFromText('god morgon'), equals('SV'));
      });
      
      test('Polish (PL)', () {
        expect(LanguageDetector.detectLanguageFromText('cześć jak się masz'), equals('PL'));
        expect(LanguageDetector.detectLanguageFromText('dziękuję bardzo'), equals('PL'));
        expect(LanguageDetector.detectLanguageFromText('jestem zmęczony'), equals('PL'));
        expect(LanguageDetector.detectLanguageFromText('dzień dobry'), equals('PL'));
      });
      
      test('Tagalog (TL)', () {
        expect(LanguageDetector.detectLanguageFromText('kumusta ka'), equals('TL'));
        expect(LanguageDetector.detectLanguageFromText('salamat'), equals('TL'));
        expect(LanguageDetector.detectLanguageFromText('pagod na ako'), equals('TL'));
        expect(LanguageDetector.detectLanguageFromText('magandang umaga'), equals('TL'));
      });
    });
    
    group('Edge cases', () {
      test('Empty string returns null', () {
        expect(LanguageDetector.detectLanguageFromText(''), isNull);
      });
      
      test('Single character returns null', () {
        expect(LanguageDetector.detectLanguageFromText('a'), isNull);
        expect(LanguageDetector.detectLanguageFromText('가'), isNull);
      });
      
      test('Mixed languages - detects dominant script', () {
        // Korean with English
        expect(LanguageDetector.detectLanguageFromText('안녕 hello'), equals('KO'));
        
        // Chinese with English
        expect(LanguageDetector.detectLanguageFromText('你好 world'), equals('ZH'));
        
        // Thai with numbers
        expect(LanguageDetector.detectLanguageFromText('สวัสดี 123'), equals('TH'));
      });
      
      test('Numbers and punctuation only returns null', () {
        expect(LanguageDetector.detectLanguageFromText('123 456'), isNull);
        expect(LanguageDetector.detectLanguageFromText('!@#\$%^'), isNull);
      });
    });
    
    group('Ambiguous keyword disambiguation', () {
      test('Indonesian vs Malay - distinguishes correctly', () {
        // Indonesian with unique keywords
        expect(LanguageDetector.detectLanguageFromText('aku sudah makan'), equals('ID'));
        expect(LanguageDetector.detectLanguageFromText('belum selesai'), equals('ID'));
        
        // Malay with unique keywords
        expect(LanguageDetector.detectLanguageFromText('awak dah makan'), equals('MS'));
        expect(LanguageDetector.detectLanguageFromText('macam mana ni'), equals('MS'));
        
        // Shared keywords - requires context
        expect(LanguageDetector.detectLanguageFromText('saya kerja di sini, aku sudah datang'), equals('ID'));
        expect(LanguageDetector.detectLanguageFromText('saya kerja di sini, awak boleh tak'), equals('MS'));
      });
      
      test('Spanish vs Portuguese - distinguishes correctly', () {
        // Spanish with unique keywords
        expect(LanguageDetector.detectLanguageFromText('hola qué tal estás'), equals('ES'));
        expect(LanguageDetector.detectLanguageFromText('buenos días amigo'), equals('ES'));
        
        // Portuguese with unique keywords
        expect(LanguageDetector.detectLanguageFromText('olá você está bem'), equals('PT'));
        expect(LanguageDetector.detectLanguageFromText('obrigado tchau'), equals('PT'));
      });
      
      test('German vs Dutch - distinguishes correctly', () {
        // German with unique keywords
        expect(LanguageDetector.detectLanguageFromText('danke schön wie geht es'), equals('DE'));
        expect(LanguageDetector.detectLanguageFromText('ich bin müde'), equals('DE'));
        
        // Dutch with unique keywords
        expect(LanguageDetector.detectLanguageFromText('bedankt hoe gaat het'), equals('NL'));
        expect(LanguageDetector.detectLanguageFromText('tot ziens alsjeblieft'), equals('NL'));
      });
      
      test('Special characters boost correct language', () {
        // Spanish ñ
        expect(LanguageDetector.detectLanguageFromText('año'), equals('ES'));
        
        // Portuguese ã
        expect(LanguageDetector.detectLanguageFromText('não'), equals('PT'));
        
        // German ü
        expect(LanguageDetector.detectLanguageFromText('müde'), equals('DE'));
        
        // Polish ł
        expect(LanguageDetector.detectLanguageFromText('dziękuję bardzo'), equals('PL'));
        
        // Turkish ş
        expect(LanguageDetector.detectLanguageFromText('teşekkür'), equals('TR'));
      });
      
      test('Requires minimum confidence - returns null for single generic word', () {
        // Single generic words should not be detected
        expect(LanguageDetector.detectLanguageFromText('work'), isNull);
        expect(LanguageDetector.detectLanguageFromText('good'), isNull);
        expect(LanguageDetector.detectLanguageFromText('hello'), isNull);
        expect(LanguageDetector.detectLanguageFromText('no'), isNull);
      });
      
      test('Detects with multiple keyword matches', () {
        // English with multiple keywords
        expect(LanguageDetector.detectLanguageFromText('hello how are you doing today'), equals('EN'));
        
        // Spanish with multiple keywords
        expect(LanguageDetector.detectLanguageFromText('hola gracias por qué'), equals('ES'));
      });
    });
  });
}