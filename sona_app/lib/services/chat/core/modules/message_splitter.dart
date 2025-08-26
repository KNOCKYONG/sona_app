import 'package:flutter/material.dart';

/// 메시지 분할 모듈
/// 긴 메시지를 자연스럽게 분할하는 기능 담당
class MessageSplitter {
  // 분할 설정
  static const int _normalMessageLimit = 150;
  static const int _expertMessageLimit = 200;
  static const int _minChunkSize = 30;
  static const int _maxChunkSize = 180;
  
  // 문장 종결 패턴
  static final RegExp _sentenceEndPattern = RegExp(
    r'[.!?。！？]+[\s]*|[\n]{2,}',
  );
  
  // 이모티콘 패턴
  static final RegExp _emoticonPattern = RegExp(
    r'[ㅋㅎㅠㅜ]{2,}|[~]{2,}',
  );
  
  /// 메시지 내용 분할
  List<String> splitMessageContent(
    String content, {
    bool isExpert = false,
    bool preserveEmoticons = true,
  }) {
    if (content.isEmpty) return [];
    
    // 짧은 메시지는 분할하지 않음
    final limit = isExpert ? _expertMessageLimit : _normalMessageLimit;
    if (content.length <= limit) {
      return [content];
    }
    
    // 문장 단위로 분할
    final sentences = splitIntoSentences(content);
    if (sentences.isEmpty) return [content];
    
    // 청크로 조합
    final chunks = <String>[];
    String currentChunk = '';
    
    for (final sentence in sentences) {
      // 단일 문장이 너무 긴 경우
      if (sentence.length > _maxChunkSize) {
        if (currentChunk.isNotEmpty) {
          chunks.add(currentChunk.trim());
          currentChunk = '';
        }
        chunks.addAll(_splitLongSentence(sentence));
        continue;
      }
      
      // 청크에 추가 가능한지 확인
      if (currentChunk.isEmpty) {
        currentChunk = sentence;
      } else if (currentChunk.length + sentence.length <= limit) {
        // 문장 결합 가능 여부 확인
        if (shouldCombineSentences(currentChunk, sentence)) {
          currentChunk += ' $sentence';
        } else {
          chunks.add(currentChunk.trim());
          currentChunk = sentence;
        }
      } else {
        // 현재 청크 저장하고 새 청크 시작
        chunks.add(currentChunk.trim());
        currentChunk = sentence;
      }
    }
    
    // 마지막 청크 추가
    if (currentChunk.isNotEmpty) {
      chunks.add(currentChunk.trim());
    }
    
    // 후처리: 너무 짧은 청크 병합
    return _mergeShortChunks(chunks);
  }
  
  /// 문장 단위로 분할
  List<String> splitIntoSentences(String text) {
    if (text.isEmpty) return [];
    
    final sentences = <String>[];
    String remaining = text;
    
    while (remaining.isNotEmpty) {
      final match = _sentenceEndPattern.firstMatch(remaining);
      
      if (match == null) {
        // 더 이상 문장 종결자가 없음
        sentences.add(remaining.trim());
        break;
      }
      
      // 문장 추출
      final sentence = remaining.substring(0, match.end).trim();
      if (sentence.isNotEmpty) {
        sentences.add(sentence);
      }
      
      // 나머지 텍스트
      remaining = remaining.substring(match.end).trim();
    }
    
    return sentences;
  }
  
  /// 긴 문장을 작은 청크로 분할
  List<String> _splitLongSentence(String sentence) {
    final chunks = <String>[];
    
    // 쉼표나 접속사로 분할 시도
    final subParts = sentence.split(RegExp(r'[,，、]|\s+(그리고|하지만|그래서|그런데)\s+'));
    
    String currentChunk = '';
    for (final part in subParts) {
      if (currentChunk.isEmpty) {
        currentChunk = part.trim();
      } else if (currentChunk.length + part.length <= _maxChunkSize) {
        currentChunk += ', ${part.trim()}';
      } else {
        chunks.add(currentChunk);
        currentChunk = part.trim();
      }
    }
    
    if (currentChunk.isNotEmpty) {
      chunks.add(currentChunk);
    }
    
    // 여전히 너무 긴 경우 강제 분할
    final finalChunks = <String>[];
    for (final chunk in chunks) {
      if (chunk.length > _maxChunkSize) {
        finalChunks.addAll(_forceSpiltLongText(chunk));
      } else {
        finalChunks.add(chunk);
      }
    }
    
    return finalChunks;
  }
  
  /// 강제 텍스트 분할
  List<String> _forceSpiltLongText(String text) {
    final chunks = <String>[];
    
    for (int i = 0; i < text.length; i += _maxChunkSize) {
      final end = (i + _maxChunkSize < text.length) 
          ? i + _maxChunkSize 
          : text.length;
      
      // 단어 중간이 아닌 곳에서 자르기
      int actualEnd = end;
      if (end < text.length) {
        // 공백 찾기
        final spaceIndex = text.lastIndexOf(' ', end);
        if (spaceIndex > i && spaceIndex > end - 20) {
          actualEnd = spaceIndex;
        }
      }
      
      chunks.add(text.substring(i, actualEnd).trim());
      i = actualEnd - _maxChunkSize; // 다음 시작점 조정
    }
    
    return chunks;
  }
  
  /// 짧은 청크 병합
  List<String> _mergeShortChunks(List<String> chunks) {
    if (chunks.length <= 1) return chunks;
    
    final merged = <String>[];
    String buffer = '';
    
    for (final chunk in chunks) {
      if (chunk.length < _minChunkSize && buffer.isNotEmpty) {
        // 짧은 청크는 이전 청크와 병합
        if (buffer.length + chunk.length <= _maxChunkSize) {
          buffer += ' $chunk';
        } else {
          merged.add(buffer);
          buffer = chunk;
        }
      } else if (buffer.isEmpty) {
        buffer = chunk;
      } else {
        merged.add(buffer);
        buffer = chunk;
      }
    }
    
    if (buffer.isNotEmpty) {
      merged.add(buffer);
    }
    
    return merged;
  }
  
  /// 두 문장을 결합해야 하는지 판단
  bool shouldCombineSentences(String first, String second) {
    // 첫 문장이 미완성인 경우
    if (isIncompleteSentence(first)) {
      return true;
    }
    
    // 두 번째 문장이 접속사로 시작하는 경우
    final connectives = ['그리고', '하지만', '그래서', '그런데', '또한', '게다가'];
    for (final conn in connectives) {
      if (second.startsWith(conn)) {
        return true;
      }
    }
    
    // 두 문장이 매우 짧은 경우
    if (first.length < 30 && second.length < 30) {
      return true;
    }
    
    // 이모티콘으로만 이루어진 경우
    if (_isOnlyEmoticon(second)) {
      return true;
    }
    
    return false;
  }
  
  /// 문장이 미완성인지 확인
  bool isIncompleteSentence(String text) {
    if (text.isEmpty) return false;
    
    final trimmed = text.trim();
    
    // 문장 종결어미가 없는 경우
    if (!RegExp(r'[.!?。！？ㅋㅎㅠㅜ~]+$').hasMatch(trimmed)) {
      // 명사로 끝나는 경우도 확인
      if (!RegExp(r'[가-힣]+[은는이가을를에서도만]+$').hasMatch(trimmed)) {
        return true;
      }
    }
    
    // 인용구가 열려있는 경우
    final openQuotes = '"\'「『'.split('');
    final closeQuotes = '"\'」』'.split('');
    
    int openCount = 0;
    int closeCount = 0;
    
    for (final char in trimmed.split('')) {
      if (openQuotes.contains(char)) openCount++;
      if (closeQuotes.contains(char)) closeCount++;
    }
    
    if (openCount > closeCount) {
      return true;
    }
    
    // 괄호가 열려있는 경우
    final openParens = trimmed.split('(').length - 1;
    final closeParens = trimmed.split(')').length - 1;
    
    if (openParens > closeParens) {
      return true;
    }
    
    return false;
  }
  
  /// 이모티콘만으로 이루어진 텍스트인지 확인
  bool _isOnlyEmoticon(String text) {
    final cleaned = text.replaceAll(RegExp(r'[\s]'), '');
    return _emoticonPattern.hasMatch(cleaned) && 
           cleaned.replaceAll(_emoticonPattern, '').isEmpty;
  }
  
  /// 메시지가 분할이 필요한지 확인
  bool needsSplitting(String content, {bool isExpert = false}) {
    final limit = isExpert ? _expertMessageLimit : _normalMessageLimit;
    return content.length > limit;
  }
  
  /// 예상 청크 수 계산
  int estimateChunkCount(String content, {bool isExpert = false}) {
    final limit = isExpert ? _expertMessageLimit : _normalMessageLimit;
    
    if (content.length <= limit) {
      return 1;
    }
    
    // 대략적인 계산
    return (content.length / limit).ceil();
  }
  
  /// 분할 미리보기 (디버깅용)
  Map<String, dynamic> previewSplit(String content, {bool isExpert = false}) {
    final chunks = splitMessageContent(content, isExpert: isExpert);
    
    return {
      'originalLength': content.length,
      'chunkCount': chunks.length,
      'chunks': chunks.asMap().map((index, chunk) => MapEntry(
        index.toString(),
        {
          'length': chunk.length,
          'preview': chunk.length > 50 
              ? '${chunk.substring(0, 50)}...'
              : chunk,
          'isComplete': !isIncompleteSentence(chunk),
        },
      )),
      'totalLength': chunks.fold(0, (sum, chunk) => sum + chunk.length),
    };
  }
}