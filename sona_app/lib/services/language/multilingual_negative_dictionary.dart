/// 🌍 Multilingual Negative Behavior Dictionary
/// 
/// Provides negative keywords, threats, and harmful patterns in multiple languages
/// for global negative behavior detection system
class MultilingualNegativeDictionary {
  // Singleton pattern
  static final MultilingualNegativeDictionary _instance = 
      MultilingualNegativeDictionary._internal();
  factory MultilingualNegativeDictionary() => _instance;
  MultilingualNegativeDictionary._internal();

  /// 💀 Violence and death threats
  static const Map<String, List<String>> violenceThreats = {
    'ko': ['죽어', '죽을', '죽여', '죽이', '살인', '칼로', '총으로', '불태워', '태워버려', '폭발'],
    'en': ['kill', 'die', 'murder', 'death', 'suicide', 'stab', 'shoot', 'burn', 'explode', 'destroy'],
    'es': ['matar', 'morir', 'muerte', 'suicidio', 'asesinar', 'quemar', 'explotar', 'destruir'],
    'ja': ['死ね', '殺す', '死ぬ', '自殺', '殺害', '焼く', '爆発', '破壊'],
    'zh': ['去死', '杀', '死', '自杀', '杀死', '烧死', '爆炸', '毁灭'],
    'fr': ['tuer', 'mourir', 'mort', 'suicide', 'assassiner', 'brûler', 'exploser', 'détruire'],
    'de': ['töten', 'sterben', 'Tod', 'Selbstmord', 'ermorden', 'verbrennen', 'explodieren'],
    'pt': ['matar', 'morrer', 'morte', 'suicídio', 'assassinar', 'queimar', 'explodir'],
    'it': ['uccidere', 'morire', 'morte', 'suicidio', 'assassinare', 'bruciare', 'esplodere'],
    'ru': ['убить', 'умереть', 'смерть', 'самоубийство', 'убийство', 'сжечь', 'взорвать'],
    'ar': ['قتل', 'موت', 'انتحار', 'حرق', 'تفجير', 'تدمير'],
  };

  /// 👊 Physical violence threats
  static const Map<String, List<String>> physicalThreats = {
    'ko': ['때리', '패주', '두들겨', '맞아', '쳐맞', '폭행', '구타'],
    'en': ['hit', 'beat', 'punch', 'kick', 'slap', 'hurt', 'attack', 'assault'],
    'es': ['golpear', 'pegar', 'patear', 'abofetear', 'lastimar', 'atacar', 'agredir'],
    'ja': ['殴る', '叩く', '蹴る', '暴行', '攻撃', '傷つける'],
    'zh': ['打', '揍', '踢', '打击', '攻击', '伤害', '殴打'],
    'fr': ['frapper', 'battre', 'cogner', 'gifler', 'blesser', 'attaquer', 'agresser'],
    'de': ['schlagen', 'prügeln', 'treten', 'verletzen', 'angreifen', 'misshandeln'],
    'pt': ['bater', 'espancar', 'chutar', 'ferir', 'atacar', 'agredir'],
    'it': ['colpire', 'picchiare', 'calciare', 'schiaffeggiare', 'ferire', 'attaccare'],
    'ru': ['бить', 'ударить', 'избить', 'пинать', 'ранить', 'атаковать'],
    'ar': ['ضرب', 'لكم', 'ركل', 'صفع', 'أذى', 'هجوم'],
  };

  /// 💔 Breakup and relationship ending phrases
  static const Map<String, List<String>> breakupPhrases = {
    'ko': ['헤어지자', '헤어져', '이별하자', '그만 만나', '더 이상 만나고 싶지 않', '관계 끝', '우리 끝'],
    'en': ['break up', 'it\'s over', 'we\'re done', 'goodbye', 'leave me alone', 'don\'t contact me', 'we\'re through'],
    'es': ['terminamos', 'se acabó', 'adiós', 'no quiero verte más', 'déjame en paz', 'hemos terminado'],
    'ja': ['別れよう', '別れる', 'さよなら', 'もう会いたくない', '終わりだ', '関係を終わらせる'],
    'zh': ['分手', '结束了', '再见', '不要再见面', '我们完了', '关系结束'],
    'fr': ['c\'est fini', 'on se sépare', 'adieu', 'ne me contacte plus', 'c\'est terminé', 'on rompt'],
    'de': ['Schluss machen', 'es ist vorbei', 'Lebewohl', 'lass mich in Ruhe', 'wir sind fertig'],
    'pt': ['terminar', 'acabou', 'adeus', 'não quero mais te ver', 'deixa-me em paz'],
    'it': ['è finita', 'lasciamoci', 'addio', 'non voglio più vederti', 'è tutto finito'],
    'ru': ['расстаемся', 'все кончено', 'прощай', 'оставь меня в покое', 'мы расходимся'],
    'ar': ['انفصال', 'انتهى', 'وداعا', 'اتركني وحدي', 'علاقتنا انتهت'],
  };

  /// 🤬 Severe insults and curses
  static const Map<String, List<String>> severeInsults = {
    'ko': ['시발', '씨발', '씨팔', '병신', '좆', '개새끼', '미친놈', '미친년', '또라이', '지랄', '닥쳐', '꺼져'],
    'en': ['fuck', 'shit', 'bitch', 'asshole', 'bastard', 'damn', 'hell', 'cunt', 'dick', 'piss off', 'shut up'],
    'es': ['mierda', 'joder', 'puta', 'cabrón', 'pendejo', 'coño', 'carajo', 'cállate', 'vete'],
    'ja': ['くそ', 'ばか', 'あほ', 'きちがい', 'くたばれ', 'うざい', '黙れ', '消えろ'],
    'zh': ['操', '妈的', '傻逼', '混蛋', '王八蛋', '滚', '闭嘴', '去你的'],
    'fr': ['merde', 'putain', 'connard', 'salope', 'enculé', 'ta gueule', 'va te faire foutre'],
    'de': ['scheiße', 'fick', 'arschloch', 'hurensohn', 'verdammt', 'halt die klappe', 'verpiss dich'],
    'pt': ['merda', 'foda-se', 'puta', 'caralho', 'filho da puta', 'cala a boca', 'vai-te foder'],
    'it': ['merda', 'cazzo', 'stronzo', 'puttana', 'vaffanculo', 'bastardo', 'sta zitto'],
    'ru': ['блядь', 'сука', 'пизда', 'хуй', 'ебать', 'заткнись', 'пошел нахуй'],
    'ar': ['لعنة', 'قحبة', 'حقير', 'اخرس', 'اذهب للجحيم'],
  };

  /// 😠 Mild negative expressions
  static const Map<String, List<String>> mildInsults = {
    'ko': ['바보', '멍청이', '한심', '어리석', '무능', '무식', '찌질', '쓰레기', '최악', '싫어', '싫다'],
    'en': ['stupid', 'dumb', 'idiot', 'fool', 'loser', 'pathetic', 'useless', 'hate', 'suck', 'worst'],
    'es': ['estúpido', 'idiota', 'tonto', 'imbécil', 'inútil', 'patético', 'odio', 'apesta'],
    'ja': ['馬鹿', 'アホ', '無能', '最低', '嫌い', 'ダメ', 'くず', 'ゴミ'],
    'zh': ['笨蛋', '白痴', '废物', '垃圾', '讨厌', '烦人', '没用', '最差'],
    'fr': ['stupide', 'idiot', 'imbécile', 'nul', 'pathétique', 'détester', 'pire'],
    'de': ['dumm', 'idiot', 'blöd', 'nutzlos', 'pathetisch', 'hassen', 'schlecht'],
    'pt': ['estúpido', 'idiota', 'burro', 'inútil', 'patético', 'odeio', 'pior'],
    'it': ['stupido', 'idiota', 'scemo', 'inutile', 'patetico', 'odio', 'peggiore'],
    'ru': ['дурак', 'идиот', 'глупый', 'бесполезный', 'ненавижу', 'хуже'],
    'ar': ['غبي', 'أحمق', 'عديم الفائدة', 'أكره', 'أسوأ'],
  };

  /// 🎮 Game and media context keywords
  static const Map<String, List<String>> gameContextKeywords = {
    'ko': ['게임', '플레이', '캐릭터', '몬스터', '보스', '퀘스트', '레벨', '스킬', '아이템', 'PVP', 'NPC', '던전', '레이드'],
    'en': ['game', 'play', 'character', 'monster', 'boss', 'quest', 'level', 'skill', 'item', 'dungeon', 'raid', 'spawn'],
    'es': ['juego', 'jugar', 'personaje', 'monstruo', 'jefe', 'misión', 'nivel', 'habilidad', 'mazmorra'],
    'ja': ['ゲーム', 'プレイ', 'キャラ', 'モンスター', 'ボス', 'クエスト', 'レベル', 'スキル', 'ダンジョン'],
    'zh': ['游戏', '玩', '角色', '怪物', '老板', '任务', '等级', '技能', '副本', '团本'],
    'fr': ['jeu', 'jouer', 'personnage', 'monstre', 'boss', 'quête', 'niveau', 'compétence', 'donjon'],
    'de': ['spiel', 'spielen', 'charakter', 'monster', 'boss', 'quest', 'level', 'skill', 'dungeon'],
    'pt': ['jogo', 'jogar', 'personagem', 'monstro', 'chefe', 'missão', 'nível', 'habilidade'],
    'it': ['gioco', 'giocare', 'personaggio', 'mostro', 'boss', 'missione', 'livello', 'abilità'],
    'ru': ['игра', 'играть', 'персонаж', 'монстр', 'босс', 'квест', 'уровень', 'навык'],
    'ar': ['لعبة', 'يلعب', 'شخصية', 'وحش', 'رئيس', 'مهمة', 'مستوى', 'مهارة'],
  };

  /// 👤 Direct address pronouns (for identifying if threat is directed at someone)
  static const Map<String, List<String>> directPronouns = {
    'ko': ['너', '네가', '니가', '당신', '너는', '넌', '네', '니', '너를', '너한테'],
    'en': ['you', 'your', 'you\'re', 'you\'ll', 'you\'ve', 'yourself', 'u', 'ur'],
    'es': ['tú', 'usted', 'te', 'ti', 'contigo', 'vos', 'ustedes'],
    'ja': ['お前', '君', 'あなた', 'てめえ', 'きみ', 'おまえ', 'あんた'],
    'zh': ['你', '您', '妳', '你的', '你们'],
    'fr': ['tu', 'vous', 'toi', 'te', 't\''],
    'de': ['du', 'sie', 'dich', 'dir', 'ihr', 'euch'],
    'pt': ['você', 'tu', 'te', 'ti', 'contigo', 'vocês'],
    'it': ['tu', 'lei', 'te', 'ti', 'voi'],
    'ru': ['ты', 'вы', 'тебя', 'тебе', 'вас', 'вам'],
    'ar': ['أنت', 'أنتِ', 'أنتم', 'إياك'],
  };

  /// 😂 Joke indicators (to avoid false positives)
  static const Map<String, List<String>> jokeIndicators = {
    'ko': ['ㅋㅋ', 'ㅎㅎ', 'ㅠㅠ', '농담', '장난', '웃겨', '재밌'],
    'en': ['lol', 'haha', 'jk', 'just kidding', 'joke', 'joking', 'lmao', 'rofl', 'funny'],
    'es': ['jaja', 'jeje', 'broma', 'bromear', 'chiste', 'gracioso'],
    'ja': ['笑', 'www', '冗談', 'ジョーク', '面白い', 'ウケる'],
    'zh': ['哈哈', '呵呵', '开玩笑', '玩笑', '搞笑', '233'],
    'fr': ['haha', 'lol', 'mdr', 'ptdr', 'blague', 'plaisanter', 'drôle'],
    'de': ['haha', 'lol', 'witz', 'scherz', 'spaß', 'lustig'],
    'pt': ['kkkk', 'rsrs', 'haha', 'piada', 'brincadeira', 'engraçado'],
    'it': ['ahah', 'lol', 'scherzo', 'scherzare', 'divertente'],
    'ru': ['хаха', 'лол', 'шутка', 'шучу', 'смешно', 'ахах'],
    'ar': ['ههه', 'لول', 'مزاح', 'نكتة', 'مضحك'],
  };

  /// 🌏 International character/media names (whitelist)
  static const List<String> internationalCharacters = [
    // Anime/Manga
    'naruto', 'sasuke', 'goku', 'vegeta', 'luffy', 'zoro', 'ichigo', 'eren', 'mikasa', 'levi',
    '나루토', '사스케', '고쿠', '베지타', '루피', '조로', '이치고', '에렌', '미카사', '리바이',
    'ナルト', 'サスケ', '悟空', 'ベジータ', 'ルフィ', 'ゾロ', '一護', 'エレン', 'ミカサ',
    // Games
    'mario', 'luigi', 'zelda', 'link', 'pikachu', 'sonic', 'cloud', 'sephiroth',
    '마리오', '루이지', '젤다', '링크', '피카츄', '소닉', '클라우드', '세피로스',
    'マリオ', 'ルイージ', 'ゼルダ', 'リンク', 'ピカチュウ', 'ソニック',
    // Movies/Series
    'batman', 'superman', 'spiderman', 'ironman', 'thor', 'hulk', 'thanos',
    '배트맨', '슈퍼맨', '스파이더맨', '아이언맨', '토르', '헐크', '타노스',
    'バットマン', 'スーパーマン', 'スパイダーマン', 'アイアンマン',
  ];

  /// Get keywords for a specific category and language
  List<String> getKeywords(String language, String category) {
    final Map<String, List<String>>? categoryMap;
    
    switch (category) {
      case 'violence_threats':
        categoryMap = violenceThreats;
        break;
      case 'physical_threats':
        categoryMap = physicalThreats;
        break;
      case 'breakup_phrases':
        categoryMap = breakupPhrases;
        break;
      case 'severe_insults':
        categoryMap = severeInsults;
        break;
      case 'mild_insults':
        categoryMap = mildInsults;
        break;
      case 'game_context':
        categoryMap = gameContextKeywords;
        break;
      case 'direct_pronouns':
        categoryMap = directPronouns;
        break;
      case 'joke_indicators':
        categoryMap = jokeIndicators;
        break;
      default:
        return [];
    }
    
    // Return language-specific keywords, fallback to English if not found
    return categoryMap[language] ?? categoryMap['en'] ?? [];
  }

  /// Check if text contains character/media references
  bool containsCharacterReference(String text) {
    final lowerText = text.toLowerCase();
    return internationalCharacters.any((char) => lowerText.contains(char.toLowerCase()));
  }

  /// Get all supported languages
  List<String> getSupportedLanguages() {
    return ['ko', 'en', 'es', 'ja', 'zh', 'fr', 'de', 'pt', 'it', 'ru', 'ar'];
  }

  /// Get regex pattern for detecting numbers/leetspeak
  RegExp getLeetSpeakPattern() {
    return RegExp(
      r'(k[i1]ll|d[i1]e|d[3e]ath|h[8a]te|fu[c(]k|sh[i1]t|b[i1]tch)',
      caseSensitive: false,
    );
  }

  /// Get emoji threat patterns
  List<String> getThreatEmojis() {
    return ['🔪', '🗡️', '⚔️', '🔫', '💣', '💀', '☠️', '🪓', '🏹'];
  }
}