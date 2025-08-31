import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/faq_data.dart';
import '../l10n/app_localizations.dart';
import '../services/ui/haptic_service.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<FAQItemWithCategory> _searchResults = [];
  String _searchQuery = '';
  
  // 카테고리별 확장 상태
  final Map<String, bool> _expandedCategories = {};
  
  // 즐겨찾기 FAQ (SharedPreferences에 저장 가능)
  final Set<String> _favoriteQuestions = {};
  
  // 애니메이션 컨트롤러
  late AnimationController _searchBarAnimationController;
  late Animation<double> _searchBarAnimation;
  
  bool _isSearching = false;
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    
    // 검색바 애니메이션 설정
    _searchBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _searchBarAnimation = CurvedAnimation(
      parent: _searchBarAnimationController,
      curve: Curves.easeInOut,
    );
    
    // 스크롤 리스너
    _scrollController.addListener(() {
      final showButton = _scrollController.offset > 200;
      if (showButton != _showScrollToTop) {
        setState(() {
          _showScrollToTop = showButton;
        });
      }
    });
    
    // 검색 리스너
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchBarAnimationController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query != _searchQuery) {
      setState(() {
        _searchQuery = query;
        _isSearching = query.isNotEmpty;
        final locale = Localizations.localeOf(context);
        _searchResults = FAQData.search(query, locale.languageCode == 'ko');
      });
      
      if (query.isNotEmpty) {
        _searchBarAnimationController.forward();
      } else {
        _searchBarAnimationController.reverse();
      }
    }
  }

  void _toggleCategory(String categoryId) {
    HapticService.lightImpact();
    setState(() {
      _expandedCategories[categoryId] = !(_expandedCategories[categoryId] ?? false);
    });
  }

  void _toggleFavorite(String questionKo) {
    HapticService.lightImpact();
    setState(() {
      if (_favoriteQuestions.contains(questionKo)) {
        _favoriteQuestions.remove(questionKo);
      } else {
        _favoriteQuestions.add(questionKo);
      }
    });
    // TODO: SharedPreferences에 저장
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // 앱바
              SliverAppBar(
                expandedHeight: 120,
                floating: true,
                pinned: true,
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    localizations.frequentlyAskedQuestions,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headlineSmall?.color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: true,
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              
              // 검색바
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: _buildSearchBar(isDarkMode),
                ),
              ),
              
              // 검색 중일 때 검색 결과 표시
              if (_isSearching) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      '${localizations.searchResults}: ${_searchResults.length}개',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final result = _searchResults[index];
                      return _buildSearchResultItem(result, isDarkMode);
                    },
                    childCount: _searchResults.length,
                  ),
                ),
              ] else ...[
                // 카테고리별 FAQ 표시
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final category = FAQData.categories[index];
                      return _buildCategorySection(category, isDarkMode);
                    },
                    childCount: FAQData.categories.length,
                  ),
                ),
              ],
              
              // 하단 여백
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          ),
          
          // Scroll to top 버튼
          if (_showScrollToTop)
            Positioned(
              bottom: 20,
              right: 20,
              child: AnimatedOpacity(
                opacity: _showScrollToTop ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onPressed: _scrollToTop,
                  child: const Icon(Icons.arrow_upward, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchFAQ,
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  onPressed: () {
                    _searchController.clear();
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCategorySection(FAQCategory category, bool isDarkMode) {
    final isExpanded = _expandedCategories[category.id] ?? false;
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isExpanded
              ? category.gradientColors
              : [
                  category.gradientColors[0].withOpacity(0.1),
                  category.gradientColors[1].withOpacity(0.1),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: category.gradientColors[0].withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: PageStorageKey(category.id),
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) => _toggleCategory(category.id),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isExpanded ? Colors.white.withOpacity(0.2) : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              category.icon,
              color: isExpanded ? Colors.white : category.gradientColors[0],
              size: 24,
            ),
          ),
          title: Text(
            category.getTitle(isKorean),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isExpanded ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          subtitle: Text(
            '${category.items.length}개 질문',
            style: TextStyle(
              fontSize: 14,
              color: isExpanded
                  ? Colors.white.withOpacity(0.8)
                  : Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          trailing: AnimatedRotation(
            turns: isExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.expand_more,
              color: isExpanded ? Colors.white : Theme.of(context).iconTheme.color,
            ),
          ),
          children: category.items.map((item) {
            return _buildFAQItem(item, category, isDarkMode, isExpanded);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFAQItem(FAQItem item, FAQCategory category, bool isDarkMode, bool categoryExpanded) {
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';
    final isFavorite = _favoriteQuestions.contains(item.questionKo);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: categoryExpanded
            ? Colors.white.withOpacity(0.95)
            : (isDarkMode ? Colors.grey[850] : Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 질문
          Row(
            children: [
              Expanded(
                child: Text(
                  'Q. ${item.getQuestion(isKorean)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: categoryExpanded ? Colors.black87 : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.amber : Colors.grey,
                  size: 20,
                ),
                onPressed: () => _toggleFavorite(item.questionKo),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // 답변
          Text(
            'A.\n${item.getAnswer(isKorean)}',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: categoryExpanded
                  ? Colors.black87.withOpacity(0.8)
                  : Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          
          // 관련 FAQ
          if (item.relatedIds != null && item.relatedIds!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            _buildRelatedItems(item, isKorean),
          ],
          
          // 도움이 되었나요?
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.wasHelpful,
                style: TextStyle(
                  fontSize: 12,
                  color: categoryExpanded
                      ? Colors.black54
                      : Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(width: 12),
              _buildFeedbackButton(Icons.thumb_up_outlined, true),
              const SizedBox(width: 8),
              _buildFeedbackButton(Icons.thumb_down_outlined, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultItem(FAQItemWithCategory result, bool isDarkMode) {
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';
    final isFavorite = _favoriteQuestions.contains(result.item.questionKo);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // 해당 카테고리로 스크롤하거나 상세 화면 표시
            HapticService.lightImpact();
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 카테고리 표시
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: result.category.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    result.category.getTitle(isKorean),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // 질문
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Q. ${result.item.getQuestion(isKorean)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                        color: isFavorite ? Colors.amber : Colors.grey,
                        size: 20,
                      ),
                      onPressed: () => _toggleFavorite(result.item.questionKo),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // 답변 (미리보기)
                Text(
                  'A.\n${result.item.getAnswer(isKorean)}',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRelatedItems(FAQItem item, bool isKorean) {
    final relatedItems = FAQData.getRelatedItems(item.relatedIds, item.questionKo);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.relatedFAQ,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 8),
        ...relatedItems.map((related) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: InkWell(
              onTap: () {
                // 관련 FAQ로 이동
                HapticService.lightImpact();
              },
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      related.item.getQuestion(isKorean),
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildFeedbackButton(IconData icon, bool isPositive) {
    return InkWell(
      onTap: () {
        HapticService.lightImpact();
        // TODO: 피드백 저장
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isPositive 
                  ? AppLocalizations.of(context)!.thanksFeedback
                  : AppLocalizations.of(context)!.sorryNotHelpful,
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}