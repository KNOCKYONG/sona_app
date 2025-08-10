/// 다국어 감정 사전
/// 
/// 각 언어별 감정 키워드를 관리하는 사전
class MultilingualEmotionDictionary {
  // 싱글톤 패턴
  static final MultilingualEmotionDictionary _instance = 
      MultilingualEmotionDictionary._internal();
  factory MultilingualEmotionDictionary() => _instance;
  MultilingualEmotionDictionary._internal();

  /// 기쁨/행복 관련 키워드
  static const Map<String, List<String>> happyKeywords = {
    'ko': ['기뻐', '기쁘', '기쁜', '행복', '즐거', '즐겁', '신나', '좋아', '좋은', 
           '최고', '짱', '대박', '굿', '만족', '웃', '재밌', '재미있', '뿌듯', '상쾌'],
    'en': ['happy', 'joy', 'joyful', 'glad', 'pleased', 'delighted', 'cheerful',
           'excited', 'wonderful', 'great', 'awesome', 'fantastic', 'amazing',
           'good', 'nice', 'lovely', 'fun', 'enjoy', 'smile', 'laugh'],
    'es': ['feliz', 'alegre', 'contento', 'dichoso', 'gozoso', 'encantado',
           'genial', 'estupendo', 'maravilloso', 'bueno', 'excelente', 'sonrisa'],
    'fr': ['heureux', 'heureuse', 'joyeux', 'joyeuse', 'content', 'ravi',
           'enchanté', 'merveilleux', 'génial', 'super', 'formidable', 'bien'],
    'de': ['glücklich', 'froh', 'fröhlich', 'erfreut', 'zufrieden', 'heiter',
           'wunderbar', 'großartig', 'toll', 'super', 'gut', 'schön'],
    'ja': ['嬉しい', '楽しい', '幸せ', '喜ぶ', '最高', 'ハッピー', '笑顔', '笑う'],
    'zh': ['开心', '快乐', '高兴', '幸福', '愉快', '欢喜', '欢乐', '笑', '棒'],
    'pt': ['feliz', 'alegre', 'contente', 'satisfeito', 'animado', 'ótimo', 'bom'],
    'it': ['felice', 'allegro', 'contento', 'gioioso', 'lieto', 'soddisfatto'],
    'ru': ['счастливый', 'радостный', 'веселый', 'довольный', 'хорошо', 'отлично'],
    'ar': ['سعيد', 'فرح', 'مسرور', 'مبتهج', 'رائع', 'ممتاز'],
  };

  /// 슬픔 관련 키워드
  static const Map<String, List<String>> sadKeywords = {
    'ko': ['슬퍼', '슬프', '슬픈', '우울', '눈물', '울', '울어', '울고', '힘들', '힘든',
           '외로', '외롭', '쓸쓸', '그리워', '그립', '보고싶', '서러', '서럽', '아프'],
    'en': ['sad', 'unhappy', 'depressed', 'down', 'blue', 'melancholy', 'gloomy',
           'miserable', 'sorrowful', 'tearful', 'cry', 'crying', 'tears', 'lonely',
           'miss', 'heartbroken', 'disappointed', 'hurt', 'pain'],
    'es': ['triste', 'infeliz', 'deprimido', 'melancólico', 'llorar', 'lágrimas',
           'solo', 'solitario', 'dolor', 'pena', 'desanimado', 'abatido'],
    'fr': ['triste', 'malheureux', 'déprimé', 'mélancolique', 'pleurer', 'larmes',
           'seul', 'solitaire', 'douleur', 'peine', 'chagrin', 'déçu'],
    'de': ['traurig', 'unglücklich', 'deprimiert', 'niedergeschlagen', 'weinen',
           'Tränen', 'einsam', 'allein', 'Schmerz', 'Kummer', 'enttäuscht'],
    'ja': ['悲しい', '寂しい', '辛い', '泣く', '涙', '孤独', '憂鬱', '痛い'],
    'zh': ['伤心', '难过', '悲伤', '忧郁', '哭', '眼泪', '孤独', '寂寞', '痛苦'],
    'pt': ['triste', 'infeliz', 'deprimido', 'chorando', 'lágrimas', 'sozinho'],
    'it': ['triste', 'infelice', 'depresso', 'malinconico', 'piangere', 'solo'],
    'ru': ['грустный', 'печальный', 'депрессия', 'плакать', 'слезы', 'одинокий'],
    'ar': ['حزين', 'كئيب', 'وحيد', 'دموع', 'يبكي', 'ألم'],
  };

  /// 사랑/애정 관련 키워드
  static const Map<String, List<String>> loveKeywords = {
    'ko': ['사랑', '사랑해', '좋아해', '좋아', '애정', '마음', '설레', '설렘', '두근',
           '보고싶', '그리워', '소중', '귀여', '예뻐', '멋져', '최고'],
    'en': ['love', 'like', 'adore', 'fond', 'care', 'dear', 'sweet', 'cute',
           'heart', 'affection', 'passion', 'romantic', 'precious',
           'beautiful', 'handsome', 'attractive', 'charming'],
    'es': ['amor', 'amo', 'amar', 'querer', 'quiero', 'cariño', 'corazón', 'pasión', 
           'romántico', 'lindo', 'hermoso', 'precioso', 'querido', 'adorar', 
           'enamorado', 'te amo', 'te quiero'],
    'fr': ['amour', 'aimer', 'adorer', 'chéri', 'cœur', 'passion', 'romantique',
           'mignon', 'beau', 'belle', 'précieux', 'tendresse', 'affection'],
    'de': ['Liebe', 'lieben', 'mögen', 'Herz', 'Zuneigung', 'romantisch', 'süß',
           'hübsch', 'schön', 'liebevoll', 'zärtlich', 'vermissen'],
    'ja': ['愛', '愛してる', '好き', '大好き', '恋', '恋しい', 'ラブ', 'かわいい'],
    'zh': ['爱', '喜欢', '爱情', '心', '想念', '思念', '可爱', '美丽', '亲爱'],
    'pt': ['amor', 'amar', 'gostar', 'carinho', 'coração', 'paixão', 'querido'],
    'it': ['amore', 'amare', 'cuore', 'caro', 'passione', 'romantico', 'bello'],
    'ru': ['любовь', 'люблю', 'нравится', 'сердце', 'милый', 'дорогой'],
    'ar': ['حب', 'أحب', 'قلب', 'عزيز', 'جميل', 'رومانسي'],
  };

  /// 화남/분노 관련 키워드
  static const Map<String, List<String>> angryKeywords = {
    'ko': ['화나', '화났', '화가', '짜증', '빡치', '빡쳐', '열받', '싫어', '싫다',
           '미치', '답답', '억울', '분하', '어이없', '황당', '최악'],
    'en': ['angry', 'mad', 'furious', 'rage', 'annoyed', 'irritated', 'pissed',
           'frustrated', 'hate', 'disgusted', 'upset', 'outraged', 'indignant'],
    'es': ['enojado', 'enfadado', 'furioso', 'molesto', 'irritado', 'cabreado',
           'frustrado', 'odio', 'rabia', 'indignado', 'disgusto'],
    'fr': ['en colère', 'fâché', 'furieux', 'énervé', 'irrité', 'frustré',
           'détester', 'rage', 'indigné', 'mécontent', 'agacé'],
    'de': ['wütend', 'verärgert', 'zornig', 'sauer', 'genervt', 'frustriert',
           'hassen', 'empört', 'ärgerlich', 'aufgebracht'],
    'ja': ['怒る', '腹立つ', 'イライラ', 'ムカつく', '嫌い', '最悪', 'うざい'],
    'zh': ['生气', '愤怒', '烦', '讨厌', '恨', '火大', '郁闷', '糟糕'],
    'pt': ['bravo', 'irritado', 'furioso', 'zangado', 'frustrado', 'ódio'],
    'it': ['arrabbiato', 'furioso', 'irritato', 'frustrato', 'odio', 'infuriato'],
    'ru': ['злой', 'сердитый', 'разозлить', 'раздражен', 'ненавижу', 'бесит'],
    'ar': ['غاضب', 'غضب', 'منزعج', 'كراهية', 'محبط', 'متضايق'],
  };

  /// 걱정/불안 관련 키워드
  static const Map<String, List<String>> concernedKeywords = {
    'ko': ['걱정', '불안', '무서', '두려', '긴장', '떨려', '떨린', '고민', '망설',
           '헷갈', '모르겠', '어떡해', '어떻게', '어쩌지', '큰일'],
    'en': ['worried', 'anxious', 'concerned', 'nervous', 'afraid', 'scared',
           'fearful', 'tense', 'stressed', 'uncertain', 'confused', 'hesitant'],
    'es': ['preocupado', 'ansioso', 'nervioso', 'asustado', 'temeroso', 'tenso',
           'estresado', 'confundido', 'inseguro', 'inquieto'],
    'fr': ['inquiet', 'anxieux', 'nerveux', 'effrayé', 'peur', 'tendu', 'stressé',
           'confus', 'incertain', 'soucieux', 'préoccupé'],
    'de': ['besorgt', 'ängstlich', 'nervös', 'verängstigt', 'angespannt',
           'gestresst', 'verwirrt', 'unsicher', 'unruhig'],
    'ja': ['心配', '不安', '怖い', '緊張', 'ストレス', '迷う', '困る', 'ドキドキ'],
    'zh': ['担心', '焦虑', '紧张', '害怕', '恐惧', '压力', '困惑', '不安'],
    'pt': ['preocupado', 'ansioso', 'nervoso', 'medo', 'tenso', 'estressado'],
    'it': ['preoccupato', 'ansioso', 'nervoso', 'paura', 'teso', 'stressato'],
    'ru': ['беспокоиться', 'тревога', 'нервный', 'страх', 'напряжен', 'стресс'],
    'ar': ['قلق', 'خائف', 'متوتر', 'خوف', 'مضطرب', 'محتار'],
  };

  /// 놀람 관련 키워드
  static const Map<String, List<String>> surprisedKeywords = {
    'ko': ['놀라', '놀랐', '깜짝', '대박', '헐', '와', '우와', '어머', '세상'],
    'en': ['surprised', 'amazed', 'astonished', 'shocked', 'wow', 'omg',
           'incredible', 'unbelievable', 'unexpected', 'stunning'],
    'es': ['sorprendido', 'asombrado', 'increíble', 'guau', 'impresionante'],
    'fr': ['surpris', 'étonné', 'stupéfait', 'incroyable', 'wow', 'impressionnant'],
    'de': ['überrascht', 'erstaunt', 'schockiert', 'unglaublich', 'wow'],
    'ja': ['びっくり', '驚く', 'すごい', 'まさか', 'えっ', 'わあ'],
    'zh': ['惊讶', '吃惊', '震惊', '哇', '天哪', '不可思议'],
    'pt': ['surpreso', 'espantado', 'chocado', 'incrível', 'uau'],
    'it': ['sorpreso', 'stupito', 'scioccato', 'incredibile', 'wow'],
    'ru': ['удивлен', 'поражен', 'шокирован', 'невероятно', 'вау'],
    'ar': ['مندهش', 'مذهول', 'صدمة', 'مذهل', 'واو'],
  };

  /// 언어와 감정 타입으로 키워드 가져오기
  List<String> getKeywords(String language, String emotionType) {
    switch (emotionType) {
      case 'happy':
        return happyKeywords[language] ?? happyKeywords['en']!;
      case 'sad':
        return sadKeywords[language] ?? sadKeywords['en']!;
      case 'love':
        return loveKeywords[language] ?? loveKeywords['en']!;
      case 'angry':
        return angryKeywords[language] ?? angryKeywords['en']!;
      case 'concerned':
        return concernedKeywords[language] ?? concernedKeywords['en']!;
      case 'surprised':
        return surprisedKeywords[language] ?? surprisedKeywords['en']!;
      default:
        return [];
    }
  }

  /// 모든 감정 타입 가져오기
  List<String> getEmotionTypes() {
    return ['happy', 'sad', 'love', 'angry', 'concerned', 'surprised'];
  }

  /// 지원되는 언어 목록
  List<String> getSupportedLanguages() {
    return happyKeywords.keys.toList();
  }
}