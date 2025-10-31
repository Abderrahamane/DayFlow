// lib/pages/onboarding/question_flow_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/routes.dart';
import 'question_flow_widgets/robot_character.dart';
import 'question_flow_widgets/speech_bubble.dart';
import 'question_flow_widgets/answer_button.dart';
import 'question_flow_widgets/progress_dots_widget.dart';
import 'question_flow_widgets/completion_screen.dart';
import 'question_flow_widgets/floating_background.dart';

class QuestionFlowPage extends StatefulWidget {
  const QuestionFlowPage({super.key});

  @override
  State<QuestionFlowPage> createState() => _QuestionFlowPageState();
}

class _QuestionFlowPageState extends State<QuestionFlowPage>
    with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  final List<List<String>> _selectedAnswers = [[], [], [], []];
  bool _isTransitioning = false;
  String _robotMessage = "";
  RobotGesture _robotGesture = RobotGesture.wave;

  late AnimationController _pageTransitionController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<QuestionData> _questions = [
    QuestionData(
      question: "What's your biggest productivity challenge?",
      answers: [
        "📋 Too many tasks to manage",
        "🎯 Staying focused",
        "⏰ Time management",
        "🧠 Remembering everything",
      ],
      allowMultiple: true,
      responses: [
        "Got it, noted! 📝",
        "You're my kind of planner!",
        "That tells me a lot!",
        "Wow, you've got range! 🎯",
      ],
    ),
    QuestionData(
      question: "When do you work best?",
      answers: [
        "🌅 Early morning",
        "☀️ Afternoon",
        "🌆 Evening",
        "🌙 Late night",
      ],
      allowMultiple: true,
      responses: [
        "Interesting choice! ⏰",
        "I can work with that!",
        "Nice, flexibility is key! 🌟",
        "You're versatile! Love it!",
      ],
    ),
    QuestionData(
      question: "What's your main goal with DayFlow?",
      answers: [
        "✨ Get organized",
        "💪 Build better habits",
        "✅ Track all my tasks",
        "💡 Remember everything",
      ],
      allowMultiple: true,
      responses: [
        "You're going to love DayFlow for that! 🚀",
        "Perfect! We've got you covered!",
        "That's exactly what we do best! ⭐",
        "Ambitious! I like it! 💯",
      ],
    ),
    QuestionData(
      question: "How do you prefer to plan?",
      answers: [
        "📅 Day by day",
        "📆 Week ahead",
        "🗓️ Monthly view",
        "🌊 Go with the flow",
      ],
      allowMultiple: true,
      responses: [
        "Smart approach! 🎯",
        "I see your planning style!",
        "Mix and match, nice! 🌈",
        "You're adaptable! Perfect! ✨",
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();

    _pageTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageTransitionController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pageTransitionController,
        curve: Curves.easeIn,
      ),
    );

    _pageTransitionController.forward();

    // Initial greeting
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _robotMessage = "Hi there! Let's get to know you! 👋";
          _robotGesture = RobotGesture.wave;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageTransitionController.dispose();
    super.dispose();
  }

  void _toggleAnswer(String answer) {
    if (_isTransitioning) return;

    setState(() {
      final currentAnswers = _selectedAnswers[_currentQuestionIndex];

      if (currentAnswers.contains(answer)) {
        currentAnswers.remove(answer);
      } else {
        if (!_questions[_currentQuestionIndex].allowMultiple) {
          currentAnswers.clear();
        }
        currentAnswers.add(answer);
      }

      // Robot takes notes and responds
      if (currentAnswers.isNotEmpty) {
        _robotGesture = RobotGesture.takeNotes;
        final responses = _questions[_currentQuestionIndex].responses;

        if (currentAnswers.length > 1) {
          _robotMessage = responses.last; // Special message for multiple selections
        } else {
          _robotMessage = responses[currentAnswers.length - 1];
        }
      }
    });
  }

  Future<void> _nextQuestion() async {
    if (_isTransitioning) return;
    if (_selectedAnswers[_currentQuestionIndex].isEmpty) return;

    setState(() {
      _isTransitioning = true;
      _robotGesture = RobotGesture.thinking;
    });

    await _pageTransitionController.reverse();
    await Future.delayed(const Duration(milliseconds: 100));

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _isTransitioning = false;
        _robotMessage = "";
      });

      _pageTransitionController.reset();
      await _pageTransitionController.forward();

      // Robot greets new question
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _robotGesture = RobotGesture.wave;
            _robotMessage = "Next question! 🎯";
          });
        }
      });
    } else {
      await _completeQuestionFlow();
    }
  }

  Future<void> _completeQuestionFlow() async {
    setState(() {
      _robotGesture = RobotGesture.celebrate;
      _robotMessage = "Perfect! You're all set! 🎉";
    });

    await Future.delayed(const Duration(milliseconds: 800));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedQuestionFlow', true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
        const CompletionScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasSelection = _selectedAnswers[_currentQuestionIndex].isNotEmpty;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Animated background
          const FloatingBackground(),

          SafeArea(
            child: Column(
              children: [
                // Progress dots
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 8),
                  child: ProgressDotsWidget(
                    currentIndex: _currentQuestionIndex,
                    totalQuestions: _questions.length,
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          // Robot character with speech bubble
                          Column(
                            children: [
                              RobotCharacter(
                                gesture: _robotGesture,
                                key: ValueKey<RobotGesture>(_robotGesture),
                              ),

                              if (_robotMessage.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                SpeechBubble(
                                  message: _robotMessage,
                                  key: ValueKey<String>(_robotMessage),
                                ),
                              ],
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Question text
                          SlideTransition(
                            position: _slideAnimation,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: _AnimatedQuestionText(
                                text: question.question,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Answer buttons
                          SlideTransition(
                            position: _slideAnimation,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Column(
                                children: question.answers.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final answer = entry.value;
                                  final isSelected = _selectedAnswers[_currentQuestionIndex]
                                      .contains(answer);

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: AnswerButton(
                                      text: answer,
                                      isSelected: isSelected,
                                      onTap: () => _toggleAnswer(answer),
                                      delay: index * 100,
                                      isDisabled: _isTransitioning,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),

                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Next button (floating at bottom)
          if (hasSelection)
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: _NextButton(
                onPressed: _nextQuestion,
                isLastQuestion: _currentQuestionIndex == _questions.length - 1,
              ),
            ),
        ],
      ),
    );
  }
}

// Animated question text
class _AnimatedQuestionText extends StatefulWidget {
  final String text;

  const _AnimatedQuestionText({required this.text});

  @override
  State<_AnimatedQuestionText> createState() => _AnimatedQuestionTextState();
}

class _AnimatedQuestionTextState extends State<_AnimatedQuestionText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 30 * widget.text.length),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final visibleLength = (_controller.value * widget.text.length).round();

        return Text(
          widget.text.substring(0, visibleLength),
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}

// Next button
class _NextButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLastQuestion;

  const _NextButton({
    required this.onPressed,
    required this.isLastQuestion,
  });

  @override
  State<_NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<_NextButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.isLastQuestion ? "Finish" : "Next",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    widget.isLastQuestion ? Icons.check : Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Question data model
class QuestionData {
  final String question;
  final List<String> answers;
  final bool allowMultiple;
  final List<String> responses;

  QuestionData({
    required this.question,
    required this.answers,
    this.allowMultiple = false,
    required this.responses,
  });
}