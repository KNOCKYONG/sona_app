/// 다국어 키워드 감지 시스템
/// 각 언어별로 감정, 주제, 시간 등의 키워드를 정의
class MultilingualKeywords {
  /// 감정 감지 키워드
  static Map<String, List<String>> getEmotionKeywords(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return {
          'sad': ['슬퍼', '슬프', '우울', 'ㅠㅠ', '😭'],
          'happy': ['좋아', '기뻐', '행복', 'ㅋㅋ', '😄', '좋네'],
          'angry': ['화나', '짜증', '빡치', '열받'],
          'excited': ['대박', '미쳤', '신나', '!!', '오'],
          'anxious': ['불안', '걱정', '초조'],
          'love': ['사랑', '좋아해'],
          'grateful': ['고마워', '감사', '고맙'],
          'sorry': ['미안', '죄송'],
          'stressed': ['스트레스', '짜증', '욕', '열받'],
          'jealous': ['질투', '부러워', '샘'],
        };
      case 'en':
        return {
          'sad': ['sad', 'unhappy', 'depressed', 'crying', '😭'],
          'happy': ['happy', 'good', 'glad', 'nice', '😄', 'great'],
          'angry': ['angry', 'mad', 'frustrated', 'annoyed'],
          'excited': ['awesome', 'amazing', 'excited', '!!', 'wow'],
          'anxious': ['anxious', 'worried', 'nervous'],
          'love': ['love', 'like'],
          'grateful': ['thanks', 'thank you', 'grateful'],
          'sorry': ['sorry', 'apologize'],
          'stressed': ['stressed', 'stress', 'frustrated', 'overwhelmed'],
          'jealous': ['jealous', 'envious', 'envy'],
        };
      case 'ja':
        return {
          'sad': ['悲しい', '辛い', '泣', '😭'],
          'happy': ['嬉しい', '楽しい', 'いいね', '😄', 'よかった'],
          'angry': ['怒', 'イライラ', 'ムカつく'],
          'excited': ['すごい', 'やばい', '最高', '!!'],
          'anxious': ['不安', '心配', '緊張'],
          'love': ['愛', '好き', '大好き'],
          'grateful': ['ありがとう', '感謝'],
          'sorry': ['ごめん', 'すみません', '申し訳'],
        };
      case 'zh':
        return {
          'sad': ['难过', '伤心', '悲伤', '哭', '😭'],
          'happy': ['开心', '高兴', '快乐', '好', '😄', '不错'],
          'angry': ['生气', '愤怒', '烦', '讨厌'],
          'excited': ['厉害', '牛', '太棒了', '!!', '哇'],
          'anxious': ['焦虑', '担心', '紧张'],
          'love': ['爱', '喜欢'],
          'grateful': ['谢谢', '感谢', '多谢'],
          'sorry': ['对不起', '抱歉', '不好意思'],
        };
      case 'th':
        return {
          'sad': ['เศร้า', 'เสียใจ', 'ร้องไห้', '😭'],
          'happy': ['ดีใจ', 'มีความสุข', 'ดี', '😄', 'เยี่ยม'],
          'angry': ['โกรธ', 'หงุดหงิด', 'รำคาญ'],
          'excited': ['เจ๋ง', 'สุดยอด', 'ตื่นเต้น', '!!', 'ว้าว'],
          'anxious': ['กังวล', 'กลัว', 'ตื่นเต้น'],
          'love': ['รัก', 'ชอบ'],
          'grateful': ['ขอบคุณ', 'ขอบใจ'],
          'sorry': ['ขอโทษ', 'เสียใจ'],
        };
      case 'vi':
        return {
          'sad': ['buồn', 'tủi', 'khóc', '😭'],
          'happy': ['vui', 'hạnh phúc', 'tốt', '😄', 'hay'],
          'angry': ['giận', 'tức', 'bực'],
          'excited': ['tuyệt', 'hay quá', 'phấn khích', '!!', 'wow'],
          'anxious': ['lo lắng', 'lo', 'căng thẳng'],
          'love': ['yêu', 'thích'],
          'grateful': ['cảm ơn', 'cám ơn', 'biết ơn'],
          'sorry': ['xin lỗi', 'lỗi'],
        };
      case 'id':
        return {
          'sad': ['sedih', 'murung', 'menangis', '😭'],
          'happy': ['senang', 'bahagia', 'bagus', '😄', 'hebat'],
          'angry': ['marah', 'kesal', 'jengkel'],
          'excited': ['keren', 'hebat', 'seru', '!!', 'wow'],
          'anxious': ['cemas', 'khawatir', 'gugup'],
          'love': ['cinta', 'suka', 'sayang'],
          'grateful': ['terima kasih', 'makasih'],
          'sorry': ['maaf', 'minta maaf'],
        };
      case 'es':
        return {
          'sad': ['triste', 'deprimido', 'llorar', '😭'],
          'happy': ['feliz', 'contento', 'bien', '😄', 'genial'],
          'angry': ['enojado', 'molesto', 'furioso'],
          'excited': ['increíble', 'genial', 'emocionado', '!!', 'wow'],
          'anxious': ['ansioso', 'preocupado', 'nervioso'],
          'love': ['amor', 'querer', 'amar'],
          'grateful': ['gracias', 'agradecido'],
          'sorry': ['perdón', 'disculpa', 'lo siento'],
        };
      case 'fr':
        return {
          'sad': ['triste', 'déprimé', 'pleurer', '😭'],
          'happy': ['heureux', 'content', 'bien', '😄', 'super'],
          'angry': ['fâché', 'énervé', 'en colère'],
          'excited': ['génial', 'super', 'excité', '!!', 'wow'],
          'anxious': ['anxieux', 'inquiet', 'nerveux'],
          'love': ['amour', 'aimer'],
          'grateful': ['merci', 'reconnaissant'],
          'sorry': ['pardon', 'désolé', 'excusez-moi'],
        };
      case 'de':
        return {
          'sad': ['traurig', 'deprimiert', 'weinen', '😭'],
          'happy': ['glücklich', 'froh', 'gut', '😄', 'toll'],
          'angry': ['wütend', 'verärgert', 'sauer'],
          'excited': ['toll', 'super', 'aufgeregt', '!!', 'wow'],
          'anxious': ['ängstlich', 'besorgt', 'nervös'],
          'love': ['liebe', 'mögen'],
          'grateful': ['danke', 'dankbar'],
          'sorry': ['entschuldigung', 'tut mir leid'],
        };
      case 'ru':
        return {
          'sad': ['грустный', 'печальный', 'плакать', '😭'],
          'happy': ['счастливый', 'радостный', 'хорошо', '😄', 'отлично'],
          'angry': ['злой', 'раздраженный', 'сердитый'],
          'excited': ['круто', 'супер', 'взволнованный', '!!', 'вау'],
          'anxious': ['тревожный', 'беспокойный', 'нервный'],
          'love': ['любовь', 'любить', 'нравится'],
          'grateful': ['спасибо', 'благодарен'],
          'sorry': ['извините', 'простите', 'прошу прощения'],
        };
      case 'pt':
        return {
          'sad': ['triste', 'deprimido', 'chorar', '😭'],
          'happy': ['feliz', 'contente', 'bom', '😄', 'ótimo'],
          'angry': ['bravo', 'irritado', 'furioso'],
          'excited': ['incrível', 'ótimo', 'animado', '!!', 'uau'],
          'anxious': ['ansioso', 'preocupado', 'nervoso'],
          'love': ['amor', 'amar', 'gostar'],
          'grateful': ['obrigado', 'grato', 'agradecer'],
          'sorry': ['desculpa', 'perdão', 'sinto muito'],
        };
      case 'it':
        return {
          'sad': ['triste', 'depresso', 'piangere', '😭'],
          'happy': ['felice', 'contento', 'bene', '😄', 'fantastico'],
          'angry': ['arrabbiato', 'irritato', 'furioso'],
          'excited': ['fantastico', 'super', 'eccitato', '!!', 'wow'],
          'anxious': ['ansioso', 'preoccupato', 'nervoso'],
          'love': ['amore', 'amare', 'piacere'],
          'grateful': ['grazie', 'grato'],
          'sorry': ['scusa', 'mi dispiace', 'perdono'],
        };
      default:
        return getEmotionKeywords('en'); // Fallback to English
    }
  }

  /// 주제/토픽 감지 키워드
  static Map<String, List<String>> getTopicKeywords(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return {
          'family': ['가족', '엄마', '아빠', '부모', '형', '누나', '동생', '언니', '오빠'],
          'friends': ['친구', '친구들', '동료'],
          'work': ['일', '직장', '회사', '상사', '부장', '팀장', '과장', '대리'],
          'hobby': ['취미', '좋아하는'],
          'hobbies': ['취미', '좋아하는'],
          'dreams': ['꿈', '목표', '희망'],
          'dating': ['데이트', '만나', '연애'],
          'stress': ['스트레스', '짜증', '열받'],
          'first_time': ['첫', '처음', '최초'],
          'promise': ['약속', '함께', '평생'],
          'love': ['사랑', '연애', '애인'],
        };
      case 'en':
        return {
          'family': ['family', 'mom', 'dad', 'mother', 'father', 'brother', 'sister', 'parents'],
          'friends': ['friend', 'friends', 'buddy', 'pal'],
          'work': ['work', 'job', 'office', 'boss', 'manager', 'colleague', 'coworker'],
          'hobby': ['hobby', 'favorite', 'like to'],
          'hobbies': ['hobby', 'hobbies', 'interests'],
          'dreams': ['dream', 'goal', 'hope', 'aspiration'],
          'dating': ['date', 'dating', 'meet', 'relationship'],
          'stress': ['stress', 'frustrated', 'annoyed'],
          'first_time': ['first', 'initial', 'beginning'],
          'promise': ['promise', 'together', 'forever'],
          'love': ['love', 'romance', 'relationship'],
        };
      case 'ja':
        return {
          'family': ['家族', 'お母さん', 'お父さん', '両親', '兄', '姉', '弟', '妹'],
          'friends': ['友達', '友人', '仲間'],
          'work': ['仕事', '会社', '職場', '上司', '部長', '課長'],
          'hobby': ['趣味', '好きな'],
          'hobbies': ['趣味', '好きなこと'],
          'dreams': ['夢', '目標', '希望'],
          'dating': ['デート', '会う', '恋愛'],
          'stress': ['ストレス', 'イライラ'],
          'first_time': ['初', '初めて', '最初'],
          'promise': ['約束', '一緒', '一生'],
          'love': ['愛', '恋愛', '恋人'],
        };
      case 'zh':
        return {
          'family': ['家人', '妈妈', '爸爸', '父母', '哥哥', '姐姐', '弟弟', '妹妹'],
          'friends': ['朋友', '同事', '伙伴'],
          'work': ['工作', '公司', '老板', '经理', '同事'],
          'hobby': ['爱好', '喜欢'],
          'hobbies': ['爱好', '兴趣'],
          'dreams': ['梦想', '目标', '希望'],
          'dating': ['约会', '见面', '恋爱'],
          'stress': ['压力', '烦恼', '生气'],
          'first_time': ['第一', '首次', '初次'],
          'promise': ['承诺', '一起', '一生'],
          'love': ['爱情', '恋爱', '恋人'],
        };
      // Add other languages as needed...
      default:
        return getTopicKeywords('en');
    }
  }

  /// 시간 참조 키워드
  static Map<String, List<String>> getTimeKeywords(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return {
          'today': ['오늘', '지금', '방금'],
          'tomorrow': ['내일', '다음날'],
          'yesterday': ['어제', '전날'],
          'past': ['저번에', '예전에', '그때', '그 때'],
          'recent': ['최근', '요즘', '요새'],
        };
      case 'en':
        return {
          'today': ['today', 'now', 'just now'],
          'tomorrow': ['tomorrow', 'next day'],
          'yesterday': ['yesterday', 'previous day'],
          'past': ['before', 'last time', 'that time'],
          'recent': ['recently', 'lately', 'these days'],
        };
      case 'ja':
        return {
          'today': ['今日', '今', 'さっき'],
          'tomorrow': ['明日', '次の日'],
          'yesterday': ['昨日', '前日'],
          'past': ['前に', 'あの時', 'その時'],
          'recent': ['最近', 'この頃'],
        };
      case 'zh':
        return {
          'today': ['今天', '现在', '刚才'],
          'tomorrow': ['明天', '第二天'],
          'yesterday': ['昨天', '前一天'],
          'past': ['之前', '那时', '以前'],
          'recent': ['最近', '近来'],
        };
      // Add other languages as needed...
      default:
        return getTimeKeywords('en');
    }
  }

  /// 인과관계 키워드
  static Map<String, List<String>> getCausalKeywords(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return {
          'because': ['때문에', '라서', '해서', '니까', '으니까'],
          'so': ['그래서', '그러니까', '따라서'],
        };
      case 'en':
        return {
          'because': ['because', 'since', 'as', 'due to'],
          'so': ['so', 'therefore', 'thus', 'hence'],
        };
      case 'ja':
        return {
          'because': ['から', 'ので', 'ため'],
          'so': ['だから', 'それで', 'したがって'],
        };
      case 'zh':
        return {
          'because': ['因为', '由于'],
          'so': ['所以', '因此', '于是'],
        };
      default:
        return getCausalKeywords('en');
    }
  }

  /// 질문 타입 키워드
  static Map<String, List<String>> getQuestionKeywords(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return {
          'what_doing': ['뭐해', '뭐하고', '뭐하니'],
          'why': ['왜', '이유', '어째서'],
          'how': ['어때', '어떻게', '괜찮'],
          'where': ['어디', '어디야', '어디에'],
          'who': ['누구', '누가'],
          'when': ['언제', '몇시'],
        };
      case 'en':
        return {
          'what_doing': ['what doing', 'what are you doing', 'doing what'],
          'why': ['why', 'reason', 'how come'],
          'how': ['how', 'how about', 'what about'],
          'where': ['where', 'where are you'],
          'who': ['who', 'whom'],
          'when': ['when', 'what time'],
        };
      case 'ja':
        return {
          'what_doing': ['何してる', '何をして'],
          'why': ['なぜ', 'どうして', '理由'],
          'how': ['どう', 'どうですか'],
          'where': ['どこ', 'どこに'],
          'who': ['誰', 'だれ'],
          'when': ['いつ', '何時'],
        };
      case 'zh':
        return {
          'what_doing': ['在做什么', '干什么', '做什么'],
          'why': ['为什么', '为何', '怎么'],
          'how': ['怎么样', '如何'],
          'where': ['哪里', '在哪', '哪儿'],
          'who': ['谁', '哪位'],
          'when': ['什么时候', '几点'],
        };
      default:
        return getQuestionKeywords('en');
    }
  }

  /// 페르소나 타입 키워드
  static Map<String, List<String>> getPersonaTypeKeywords(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return {
          'teacher': ['선생님', '교수', '강사'],
          'friend': ['친구', '동료'],
          'senior': ['선배', '멘토'],
          'counselor': ['상담사', '심리'],
        };
      case 'en':
        return {
          'teacher': ['teacher', 'professor', 'instructor'],
          'friend': ['friend', 'buddy', 'pal'],
          'senior': ['senior', 'mentor'],
          'counselor': ['counselor', 'therapist'],
        };
      case 'ja':
        return {
          'teacher': ['先生', '教授', '講師'],
          'friend': ['友達', '友人'],
          'senior': ['先輩', 'メンター'],
          'counselor': ['カウンセラー', '相談員'],
        };
      case 'zh':
        return {
          'teacher': ['老师', '教授', '讲师'],
          'friend': ['朋友', '伙伴'],
          'senior': ['前辈', '导师'],
          'counselor': ['咨询师', '心理医生'],
        };
      default:
        return getPersonaTypeKeywords('en');
    }
  }

  /// Helper method to check if text contains any keyword from a list
  static bool containsAnyKeyword(String text, List<String> keywords) {
    final lowerText = text.toLowerCase();
    return keywords.any((keyword) => lowerText.contains(keyword.toLowerCase()));
  }

  /// Helper method to detect emotion from text
  static String? detectEmotion(String text, String languageCode) {
    final emotions = getEmotionKeywords(languageCode);
    for (var entry in emotions.entries) {
      if (containsAnyKeyword(text, entry.value)) {
        return entry.key;
      }
    }
    return null;
  }

  /// Helper method to detect topics from text
  static List<String> detectTopics(String text, String languageCode) {
    final topics = getTopicKeywords(languageCode);
    final detectedTopics = <String>[];
    
    for (var entry in topics.entries) {
      if (containsAnyKeyword(text, entry.value)) {
        detectedTopics.add(entry.key);
      }
    }
    
    return detectedTopics;
  }

  /// Get relationship keywords for a specific language
  static List<String> getRelationshipKeywords(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return ['사랑', '좋아해', '연인', '사귀', '결혼', '평생', '함께', 
                '데이트', '미안', '죄송', '화해', '용서', '고마워', '감사', 
                '질투', '화나', '싫어', '이별', '헤어져', '그만', '첫', 
                '처음', '기념', '특별', '중요', '소중'];
      case 'en':
        return ['love', 'like', 'lover', 'dating', 'marry', 'forever', 'together',
                'date', 'sorry', 'apologize', 'reconcile', 'forgive', 'thank', 'grateful',
                'jealous', 'angry', 'hate', 'breakup', 'separate', 'stop', 'first',
                'initial', 'anniversary', 'special', 'important', 'precious'];
      case 'ja':
        return ['愛', '好き', '恋人', '付き合う', '結婚', '一生', '一緒',
                'デート', 'ごめん', 'すみません', '和解', '許す', 'ありがとう', '感謝',
                '嫉妬', '怒る', '嫌い', '別れ', '別れる', 'やめる', '初',
                '初めて', '記念', '特別', '大切', '貴重'];
      case 'zh':
        return ['爱', '喜欢', '恋人', '交往', '结婚', '一生', '一起',
                '约会', '对不起', '抱歉', '和解', '原谅', '谢谢', '感谢',
                '嫉妒', '生气', '讨厌', '分手', '分开', '停止', '第一',
                '初次', '纪念', '特别', '重要', '珍贵'];
      default:
        return getRelationshipKeywords('en');
    }
  }

  /// Get personal keywords for a specific language
  static List<String> getPersonalKeywords(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return ['가족', '친구', '일', '직장', '학교', '취미', '꿈', '목표'];
      case 'en':
        return ['family', 'friend', 'work', 'office', 'school', 'hobby', 'dream', 'goal'];
      case 'ja':
        return ['家族', '友達', '仕事', '職場', '学校', '趣味', '夢', '目標'];
      case 'zh':
        return ['家人', '朋友', '工作', '公司', '学校', '爱好', '梦想', '目标'];
      default:
        return getPersonalKeywords('en');
    }
  }

  /// Get stop words for a specific language
  static Set<String> getStopWords(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return {'은', '는', '이', '가', '을', '를', '에', '에서', 
                '으로', '와', '과', '도', '만', '의', '로', '라', '고'};
      case 'en':
        return {'the', 'a', 'an', 'is', 'are', 'was', 'were', 'to', 
                'of', 'in', 'on', 'at', 'for', 'with', 'by', 'from'};
      case 'ja':
        return {'は', 'が', 'を', 'に', 'で', 'と', 'から', 'まで',
                'の', 'へ', 'や', 'も', 'か', 'な', 'だ', 'です'};
      case 'zh':
        return {'的', '了', '在', '是', '和', '就', '都', '而',
                '及', '与', '或', '但', '不', '也', '这', '那'};
      default:
        return getStopWords('en');
    }
  }

  /// Get question words for a specific language (flat list)
  static List<String> getQuestionWords(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return ['뭐', '어떤', '언제', '어디', '왜', '어떻게', '누구', '얼마'];
      case 'en':
        return ['what', 'which', 'when', 'where', 'why', 'how', 'who', 'how much'];
      case 'ja':
        return ['何', 'どれ', 'いつ', 'どこ', 'なぜ', 'どうやって', '誰', 'いくら'];
      case 'zh':
        return ['什么', '哪个', '什么时候', '哪里', '为什么', '怎么', '谁', '多少'];
      default:
        return getQuestionWords('en');
    }
  }

  /// Get time references for a specific language
  static Map<String, List<String>> getTimeReferences(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return {
          'today': ['오늘', '지금', '방금'],
          'tomorrow': ['내일', '다음날'],
          'yesterday': ['어제', '전날'],
          'past': ['저번에', '예전에', '그때', '그 때', '지난'],
          'recent': ['최근', '요즘', '요새'],
          'current': ['이번', '현재'],
          'future': ['다음', '앞으로', '나중에'],
        };
      case 'en':
        return {
          'today': ['today', 'now', 'just now'],
          'tomorrow': ['tomorrow', 'next day'],
          'yesterday': ['yesterday', 'previous day'],
          'past': ['before', 'last time', 'that time', 'ago'],
          'recent': ['recently', 'lately', 'these days'],
          'current': ['this', 'current'],
          'future': ['next', 'later', 'future'],
        };
      case 'ja':
        return {
          'today': ['今日', '今', 'さっき'],
          'tomorrow': ['明日', '次の日'],
          'yesterday': ['昨日', '前日'],
          'past': ['前に', 'あの時', 'その時', '過去'],
          'recent': ['最近', 'この頃'],
          'current': ['今回', '現在'],
          'future': ['次', '今後', '後で'],
        };
      case 'zh':
        return {
          'today': ['今天', '现在', '刚才'],
          'tomorrow': ['明天', '第二天'],
          'yesterday': ['昨天', '前一天'],
          'past': ['之前', '那时', '以前', '过去'],
          'recent': ['最近', '近来'],
          'current': ['这次', '当前'],
          'future': ['下次', '以后', '将来'],
        };
      default:
        return getTimeReferences('en');
    }
  }


  /// Get personal info extraction patterns for a specific language
  static Map<String, RegExp> getPersonalInfoPatterns(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return {
          'name': RegExp(r'내?\s*이름은?\s*([가-힣]+)'),
          'age': RegExp(r'(\d+)살|(\d+)세'),
          'job': RegExp(r'직업은?\s*([가-힣\s]+)'),
          'hobby': RegExp(r'취미는?\s*([가-힣\s]+)'),
          'location': RegExp(r'(\w+)에?\s*살'),
        };
      case 'en':
        return {
          'name': RegExp(r'my\s*name\s*is\s*(\w+)', caseSensitive: false),
          'age': RegExp(r'(\d+)\s*years?\s*old', caseSensitive: false),
          'job': RegExp(r'work\s*as\s*a?\s*([\w\s]+)', caseSensitive: false),
          'hobby': RegExp(r'hobby\s*is\s*([\w\s]+)', caseSensitive: false),
          'location': RegExp(r'live\s*in\s*([\w\s]+)', caseSensitive: false),
        };
      case 'ja':
        return {
          'name': RegExp(r'名前は([ぁ-んァ-ヶー一-龯]+)'),
          'age': RegExp(r'(\d+)歳'),
          'job': RegExp(r'仕事は([ぁ-んァ-ヶー一-龯\s]+)'),
          'hobby': RegExp(r'趣味は([ぁ-んァ-ヶー一-龯\s]+)'),
          'location': RegExp(r'([ぁ-んァ-ヶー一-龯]+)に住'),
        };
      case 'zh':
        return {
          'name': RegExp(r'我叫([\u4e00-\u9fa5]+)'),
          'age': RegExp(r'(\d+)岁'),
          'job': RegExp(r'职业是([\u4e00-\u9fa5\s]+)'),
          'hobby': RegExp(r'爱好是([\u4e00-\u9fa5\s]+)'),
          'location': RegExp(r'住在([\u4e00-\u9fa5]+)'),
        };
      default:
        // Return English patterns as fallback
        return getPersonalInfoPatterns('en');
    }
  }
}