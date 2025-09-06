import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/persona/persona_creation_service.dart';
import '../services/persona/persona_service.dart';
import '../services/ui/haptic_service.dart';
import '../utils/permission_helper.dart';
import '../l10n/app_localizations.dart';

class CreatePersonaScreen extends StatefulWidget {
  const CreatePersonaScreen({Key? key}) : super(key: key);

  @override
  State<CreatePersonaScreen> createState() => _CreatePersonaScreenState();
}

class _CreatePersonaScreenState extends State<CreatePersonaScreen> {
  final PersonaCreationService _personaCreationService = PersonaCreationService();
  final PageController _pageController = PageController();
  
  int _currentStep = 0;
  bool _isCreating = false;
  
  // Step 1: 기본 정보
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedGender = 'female';
  
  // Step 2: 프로필 이미지
  File? _mainImage;
  List<File> _additionalImages = [];
  
  // Step 3: MBTI 질문 답변
  Map<int, String> _mbtiAnswers = {};
  
  // Step 4: 추가 성격 설정
  String _speechStyle = 'friendly';
  String _conversationStyle = 'empathetic';
  List<String> _selectedInterests = [];
  
  // Step 5: 공유 설정
  bool _isShare = false;
  
  List<String> get _availableInterests {
    final localizations = AppLocalizations.of(context)!;
    return [
      localizations.interestMusic,
      localizations.interestMovies,
      localizations.interestReading,
      localizations.interestTravel,
      localizations.interestExercise,
      localizations.interestGaming,
      localizations.interestCooking,
      localizations.interestFashion,
      localizations.interestArt,
      localizations.interestPhotography,
      localizations.interestTechnology,
      localizations.interestScience,
      localizations.interestHistory,
      localizations.interestPhilosophy,
      localizations.interestPolitics,
      localizations.interestEconomy,
      localizations.interestSports,
      localizations.interestAnimation,
      localizations.interestKpop,
      localizations.interestDrama
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          localizations.createPersona,
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineSmall?.color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(),
          
          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                _buildBasicInfoStep(),
                _buildImageUploadStep(),
                _buildMBTIStep(),
                _buildPersonalityStep(),
                _buildShareSettingsStep(),
              ],
            ),
          ),
          
          // Navigation Buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: List.generate(5, (index) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 4,
              decoration: BoxDecoration(
                color: index <= _currentStep
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    final localizations = AppLocalizations.of(context)!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.basicInfo,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.tellUsAboutYourPersona,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          // 이름 입력
          TextField(
            controller: _nameController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: localizations.personaName,
              hintText: localizations.personaNameHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 16),
          
          // 나이 입력
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: localizations.personaAge,
              hintText: '18 - 65',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.cake),
            ),
          ),
          const SizedBox(height: 16),
          
          // 성별 선택
          Text(
            localizations.gender,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildGenderChip('female', localizations.female),
              const SizedBox(width: 8),
              _buildGenderChip('male', localizations.male),
              const SizedBox(width: 8),
              _buildGenderChip('other', localizations.other),
            ],
          ),
          const SizedBox(height: 16),
          
          // 소개 입력
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            maxLength: 200,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: localizations.personaDescription,
              hintText: localizations.personaDescriptionHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderChip(String value, String label) {
    final isSelected = _selectedGender == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedGender = value;
        });
      },
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected 
            ? Theme.of(context).colorScheme.primary 
            : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildImageUploadStep() {
    final localizations = AppLocalizations.of(context)!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.profileImage,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.uploadPersonaImages,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          // 메인 이미지
          Row(
            children: [
              Text(
                localizations.mainImage,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${localizations.optional})',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: InkWell(
              onTap: () => _pickImage(true),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 240,  // Fixed width for portrait
                height: 320,  // 3:4 aspect ratio (portrait)
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _mainImage != null 
                        ? Theme.of(context).colorScheme.primary 
                        : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: _mainImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _mainImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            localizations.tapToUpload,
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // 추가 이미지
          Row(
            children: [
              Text(
                '${localizations.additionalImages} (${_additionalImages.length}/4)',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${localizations.optional})',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _additionalImages.length + (_additionalImages.length < 4 ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < _additionalImages.length) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _additionalImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _additionalImages.removeAt(index);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return InkWell(
                  onTap: () => _pickImage(false),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 32,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          localizations.addImage,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMBTIStep() {
    final localizations = AppLocalizations.of(context)!;
    final currentQuestionIndex = _mbtiAnswers.length;
    
    // Show description on first question
    if (currentQuestionIndex == 0 && !_mbtiAnswers.containsKey(1)) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Icon(
              Icons.psychology,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              localizations.mbtiTest,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              localizations.mbtiStepDescription,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _mbtiAnswers[1] = '';  // Start with question id 1
                });
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                localizations.startTest,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }
    
    // Check if all questions are answered
    if (_mbtiAnswers.length >= 4) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              localizations.mbtiComplete,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'MBTI: ${_personaCreationService.calculateMBTI(context, _mbtiAnswers)}',
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    
    // Find next unanswered question
    final mbtiQuestions = PersonaCreationService.getMBTIQuestions(context);
    late final MBTIQuestion question;
    bool foundQuestion = false;
    for (final q in mbtiQuestions) {
      if (!_mbtiAnswers.containsKey(q.id) || _mbtiAnswers[q.id]!.isEmpty) {
        question = q;
        foundQuestion = true;
        break;
      }
    }
    
    if (!foundQuestion) {
      // This shouldn't happen, but handle gracefully
      return const SizedBox.shrink();
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            '${localizations.mbtiQuestion} ${_mbtiAnswers.length}/4',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          
          // Option A
          InkWell(
            onTap: () async {
              await HapticService.selectionClick();
              setState(() {
                _mbtiAnswers[question.id] = 'A';
              });
              // Auto proceed to next question after a short delay
              // setState will automatically rebuild and show next question
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'A',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    question.optionA,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Option B
          InkWell(
            onTap: () async {
              await HapticService.selectionClick();
              setState(() {
                _mbtiAnswers[question.id] = 'B';
              });
              // Auto proceed to next question after a short delay
              // setState will automatically rebuild and show next question
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'B',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    question.optionB,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalityStep() {
    final localizations = AppLocalizations.of(context)!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.personalitySettings,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // 말투 선택
          Text(
            localizations.speechStyle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _buildStyleChip(localizations.speechStyleFriendly, _speechStyle == 'friendly', 
                (value) => setState(() => _speechStyle = 'friendly')),
              _buildStyleChip(localizations.speechStylePolite, _speechStyle == 'polite',
                (value) => setState(() => _speechStyle = 'polite')),
              _buildStyleChip(localizations.speechStyleChic, _speechStyle == 'chic',
                (value) => setState(() => _speechStyle = 'chic')),
              _buildStyleChip(localizations.speechStyleLively, _speechStyle == 'lively',
                (value) => setState(() => _speechStyle = 'lively')),
            ],
          ),
          const SizedBox(height: 24),
          
          // 대화 스타일 선택
          Text(
            localizations.conversationStyle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _buildStyleChip(localizations.conversationStyleTalkative, _conversationStyle == 'talkative',
                (value) => setState(() => _conversationStyle = 'talkative')),
              _buildStyleChip(localizations.conversationStyleQuiet, _conversationStyle == 'quiet',
                (value) => setState(() => _conversationStyle = 'quiet')),
              _buildStyleChip(localizations.conversationStyleEmpathetic, _conversationStyle == 'empathetic',
                (value) => setState(() => _conversationStyle = 'empathetic')),
              _buildStyleChip(localizations.conversationStyleLogical, _conversationStyle == 'logical',
                (value) => setState(() => _conversationStyle = 'logical')),
            ],
          ),
          const SizedBox(height: 24),
          
          // 관심 분야 선택
          Text(
            '${localizations.interests} (${localizations.maxFiveItems})',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableInterests.map((interest) {
              final isSelected = _selectedInterests.contains(interest);
              return FilterChip(
                label: Text(interest),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected && _selectedInterests.length < 5) {
                      _selectedInterests.add(interest);
                    } else if (!selected) {
                      _selectedInterests.remove(interest);
                    }
                  });
                },
                selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                checkmarkColor: Theme.of(context).colorScheme.primary,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleChip(String label, bool isSelected, Function(bool) onSelected) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected 
            ? Theme.of(context).colorScheme.primary 
            : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildShareSettingsStep() {
    final localizations = AppLocalizations.of(context)!;
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Spacer(),
          Icon(
            Icons.public,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            localizations.shareWithCommunity,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            localizations.shareDescription,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isShare
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isShare
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[700]!
                        : Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: SwitchListTile(
              value: _isShare,
              onChanged: (value) {
                setState(() {
                  _isShare = value;
                });
              },
              title: Text(
                localizations.sharePersona,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              subtitle: Text(
                _isShare 
                    ? localizations.willBeSharedAfterApproval
                    : localizations.privatePersonaDescription,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final localizations = AppLocalizations.of(context)!;
    final canProceed = _canProceedToNextStep();
    
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _isCreating ? null : () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(localizations.previous),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: (_isCreating || !canProceed) ? null : _handleNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: canProceed && !_isCreating
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[700]
                        : Colors.grey[400],
                foregroundColor: canProceed && !_isCreating
                    ? Colors.white
                    : Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[400]
                        : Colors.white,
                disabledBackgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[700]
                    : Colors.grey[400],
                disabledForegroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: canProceed && !_isCreating ? 2 : 0,
              ),
              child: _isCreating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _currentStep == 4
                          ? localizations.create
                          : (_currentStep == 2 && _mbtiAnswers.length < 4)
                              ? localizations.next
                              : localizations.next,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceedToNextStep() {
    switch (_currentStep) {
      case 0: // 기본 정보
        return _nameController.text.isNotEmpty &&
            _ageController.text.isNotEmpty &&
            _descriptionController.text.isNotEmpty &&
            _selectedGender.isNotEmpty &&
            int.tryParse(_ageController.text) != null &&
            int.parse(_ageController.text) >= 18 &&
            int.parse(_ageController.text) <= 65;
      case 1: // 이미지
        return true; // 이미지는 선택사항 (R2 설정 시에만 업로드)
      case 2: // MBTI
        return _mbtiAnswers.length >= 4; // 4개 질문 모두 답변 완료
      case 3: // 성격
        return _speechStyle.isNotEmpty && 
               _conversationStyle.isNotEmpty && 
               _selectedInterests.isNotEmpty;
      case 4: // 공유 설정
        return true;
      default:
        return false;
    }
  }

  Future<void> _handleNext() async {
    // Hide keyboard 
    FocusScope.of(context).unfocus();
    
    if (_currentStep == 2) {
      // MBTI 단계에서는 모든 질문 완료 확인
      if (_mbtiAnswers.length < 4) {
        return; // 아직 질문이 남음
      }
    }
    
    if (_currentStep < 4) {
      await HapticService.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // 생성 실행
      await _createPersona();
    }
  }

  Future<void> _pickImage(bool isMain) async {
    await HapticService.selectionClick();
    
    final imageFile = await PermissionHelper.requestAndPickImage(
      context: context,
      source: ImageSource.gallery,
    );
    
    if (imageFile != null) {
      setState(() {
        if (isMain) {
          _mainImage = imageFile;
        } else {
          if (_additionalImages.length < 4) {
            _additionalImages.add(imageFile);
          }
        }
      });
    }
  }

  Future<void> _createPersona() async {
    setState(() {
      _isCreating = true;
    });
    
    try {
      final personaId = await _personaCreationService.createCustomPersona(
        context: context,
        name: _nameController.text.trim(),
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        description: _descriptionController.text.trim(),
        mbtiAnswers: _mbtiAnswers,
        speechStyle: _speechStyle,
        interests: _selectedInterests,
        conversationStyle: _conversationStyle,
        mainImage: _mainImage,
        additionalImages: _additionalImages,
        isShare: _isShare,
      );
      
      if (personaId != null) {
        await HapticService.success();
        
        // Refresh PersonaService to include the newly created custom persona
        if (mounted) {
          final personaService = Provider.of<PersonaService>(context, listen: false);
          // Reinitialize to reload all personas including the new custom one
          await personaService.initialize(userId: personaService.currentUserId);
          debugPrint('✅ PersonaService refreshed after creating custom persona');
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.personaCreated),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      await HapticService.error();
      
      debugPrint('❌ Error creating persona: $e');
      
      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        String errorMessage = localizations.createFailed;
        
        // 더 구체적인 에러 메시지
        if (e.toString().contains('permission')) {
          errorMessage = AppLocalizations.of(context)!.firebasePermissionError;
        } else if (e.toString().contains('network')) {
          errorMessage = localizations.networkErrorCheckConnection;
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      setState(() {
        _isCreating = false;
      });
    }
  }
}