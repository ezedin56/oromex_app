// import 'package:flutter/material.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
// import 'package:provider/provider.dart';
// import '../../../../app/theme/colors.dart';
// import '../../../../app/theme/text_styles.dart';
// import '../../../shared/widgets/custom_button.dart';
// import '../widgets/timer_widget.dart';
// import '../widgets/question_widget.dart';
// import '../widgets/security_warning_dialog.dart';
// import '../../../shared/providers/exam_provider.dart';
// import '../../domain/models/exam_session_model.dart';
// import '../../domain/models/question_model.dart';

// class ExamPage extends StatefulWidget {
//   final String examId;
//   final String examTitle;

//   const ExamPage({super.key, required this.examId, required this.examTitle});

//   @override
//   State<ExamPage> createState() => _ExamPageState();
// }

// class _ExamPageState extends State<ExamPage> with WidgetsBindingObserver {
//   late ExamProvider _examProvider;
//   bool _securityEnabled = false;
//   bool _isInitializing = true;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _initializeExam();
//   }

//   Future<void> _initializeExam() async {
//     try {
//       _examProvider = Provider.of<ExamProvider>(context, listen: false);

//       // Show security warning
//       final shouldStart = await showDialog<bool>(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => const SecurityWarningDialog(),
//       );

//       if (shouldStart == true && mounted) {
//         await _enableSecurity();
//         await _examProvider.startExam(widget.examId);
//         if (mounted) {
//           setState(() {
//             _isInitializing = false;
//           });
//         }
//       } else if (mounted) {
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isInitializing = false;
//           _errorMessage = 'Failed to start exam: ${e.toString()}';
//         });
//       }
//     }
//   }

//   Future<void> _enableSecurity() async {
//     try {
//       // Prevent screenshots and screen recording
//       await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
//       if (mounted) {
//         setState(() {
//           _securityEnabled = true;
//         });
//       }
//     } catch (e) {
//       print('Failed to enable security: $e');
//       // Continue with exam even if security fails
//     }
//   }

//   Future<void> _disableSecurity() async {
//     try {
//       await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
//       if (mounted) {
//         setState(() {
//           _securityEnabled = false;
//         });
//       }
//     } catch (e) {
//       print('Failed to disable security: $e');
//     }
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (!_securityEnabled || !mounted) return;

//     if (state == AppLifecycleState.paused ||
//         state == AppLifecycleState.inactive) {
//       // Auto-submit if app goes to background
//       _submitExam('App backgrounded');
//     }
//   }

//   Future<void> _submitExam(String reason) async {
//     try {
//       await _examProvider.submitExam(reason);
//       await _disableSecurity();
//       if (mounted) {
//         Navigator.pushReplacementNamed(
//           context,
//           '/results',
//           arguments: {'examId': widget.examId},
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to submit exam: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   Future<bool> _onWillPop() async {
//     final shouldExit = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Exit Exam?'),
//         content: const Text(
//           'Your progress will be lost if you exit the exam. Are you sure?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             child: const Text('Exit'),
//           ),
//         ],
//       ),
//     );

//     if (shouldExit == true && mounted) {
//       await _submitExam('User exited manually');
//       return true;
//     }
//     return false;
//   }

//   void _showSubmitConfirmation() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Submit Exam?'),
//         content: const Text(
//           'Are you sure you want to submit your exam? You cannot change your answers after submission.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Review Again'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _submitExam('User submitted');
//             },
//             child: const Text('Submit'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ExamProvider>(
//       builder: (context, examProvider, child) {
//         if (_isInitializing) {
//           return _buildLoadingScreen();
//         }

//         if (_errorMessage != null) {
//           return _buildErrorScreen();
//         }

//         final currentSession = examProvider.currentSession;
//         final currentQuestion = examProvider.currentQuestion;

//         if (currentSession == null || currentQuestion == null) {
//           return _buildErrorScreen(message: 'Exam session not available');
//         }

//         return _buildExamScreen(examProvider, currentSession, currentQuestion);
//       },
//     );
//   }

//   Widget _buildLoadingScreen() {
//     return Scaffold(
//       backgroundColor: AppColors.primaryBackground,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const CircularProgressIndicator(),
//             const SizedBox(height: 16),
//             Text(
//               'Setting up your exam...',
//               style: TextStyles.bodyMedium.copyWith(
//                 color: AppColors.primaryText,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Please wait',
//               style: TextStyles.bodySmall.copyWith(
//                 color: AppColors.primaryText.withOpacity(0.7),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorScreen({String? message}) {
//     return Scaffold(
//       backgroundColor: AppColors.primaryBackground,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.error_outline,
//                 size: 64,
//                 color: AppColors.accentColor,
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'Exam Error',
//                 style: TextStyles.headlineSmall.copyWith(
//                   color: AppColors.primaryText,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 message ?? _errorMessage ?? 'Something went wrong',
//                 textAlign: TextAlign.center,
//                 style: TextStyles.bodyMedium.copyWith(
//                   color: AppColors.primaryText.withOpacity(0.7),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               CustomButton(
//                 text: 'Go Back',
//                 onPressed: () {
//                   _disableSecurity();
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildExamScreen(
//     ExamProvider examProvider,
//     ExamSession currentSession,
//     Question currentQuestion,
//   ) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: AppColors.primaryBackground,
//         appBar: AppBar(
//           title: Text(
//             widget.examTitle,
//             style: TextStyles.bodyLarge.copyWith(
//               color: AppColors.primaryText,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           backgroundColor: AppColors.secondaryBackground,
//           elevation: 1,
//           leading: Container(), // Remove back button
//           actions: [
//             TimerWidget(
//               duration: currentSession.duration,
//               onTimeUp: () => _submitExam('Time expired'),
//             ),
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               // Question Progress
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Question ${examProvider.currentQuestionIndex + 1} of ${examProvider.totalQuestions}',
//                     style: TextStyles.bodyMedium.copyWith(
//                       color: AppColors.primaryText.withOpacity(0.7),
//                     ),
//                   ),
//                   Text(
//                     '${(examProvider.progress * 100).toStringAsFixed(0)}% Complete',
//                     style: TextStyles.bodyMedium.copyWith(
//                       color: AppColors.accentColor,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               LinearProgressIndicator(
//                 value: examProvider.progress,
//                 backgroundColor: AppColors.secondaryBackground,
//                 color: AppColors.accentColor,
//               ),
//               const SizedBox(height: 24),

//               // Question Widget
//               Expanded(
//                 child: QuestionWidget(
//                   question: currentQuestion,
//                   selectedAnswer: currentSession.answers[currentQuestion.id],
//                   onAnswerSelected: (answer) {
//                     examProvider.answerQuestion(currentQuestion.id, answer);
//                   },
//                 ),
//               ),

//               // Navigation Buttons
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   if (examProvider.hasPreviousQuestion)
//                     Expanded(
//                       child: CustomButton(
//                         text: 'Previous',
//                         variant: ButtonVariant.outlined,
//                         onPressed: examProvider.previousQuestion,
//                       ),
//                     ),
//                   if (examProvider.hasPreviousQuestion)
//                     const SizedBox(width: 12),
//                   Expanded(
//                     child: CustomButton(
//                       text: examProvider.currentQuestionIndex ==
//                               examProvider.totalQuestions - 1
//                           ? 'Submit Exam'
//                           : 'Next',
//                       onPressed: () {
//                         if (examProvider.currentQuestionIndex ==
//                             examProvider.totalQuestions - 1) {
//                           _showSubmitConfirmation();
//                         } else {
//                           examProvider.nextQuestion();
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _disableSecurity();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../shared/widgets/custom_button.dart';
import '../widgets/timer_widget.dart';
import '../widgets/question_widget.dart';
import '../widgets/security_warning_dialog.dart';
import '../../../shared/providers/exam_provider.dart';
import '../../domain/models/exam_session_model.dart';
import '../../domain/models/question_model.dart';

class ExamPage extends StatefulWidget {
  final String examId;
  final String examTitle;

  const ExamPage({super.key, required this.examId, required this.examTitle});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> with WidgetsBindingObserver {
  late ExamProvider _examProvider;
  bool _securityEnabled = false;
  bool _isInitializing = true;
  String? _errorMessage;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeExam();
  }

  Future<void> _initializeExam() async {
    try {
      _examProvider = Provider.of<ExamProvider>(context, listen: false);

      // Show security warning
      final shouldStart = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const SecurityWarningDialog(),
      );

      if (shouldStart == true && mounted) {
        await _enableSecurity();
        await _examProvider.startExam(widget.examId);
        if (mounted) {
          setState(() {
            _isInitializing = false;
          });
        }
      } else if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _errorMessage = 'Failed to start exam: ${e.toString()}';
        });
      }
    }
  }

  Future<void> _enableSecurity() async {
    try {
      // Prevent screenshots and screen recording
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      if (mounted) {
        setState(() {
          _securityEnabled = true;
        });
      }
    } catch (e) {
      print('Failed to enable security: $e');
      // Continue with exam even if security fails
    }
  }

  Future<void> _disableSecurity() async {
    try {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
      if (mounted) {
        setState(() {
          _securityEnabled = false;
        });
      }
    } catch (e) {
      print('Failed to disable security: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_securityEnabled || !mounted) return;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // Auto-submit if app goes to background
      _submitExam('App backgrounded');
    }
  }

  Future<void> _submitExam(String reason) async {
    if (_isSubmitting) return; // Prevent multiple submissions

    try {
      setState(() {
        _isSubmitting = true;
      });

      await _examProvider.submitExam(reason);
      await _disableSecurity();

      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/results',
          arguments: {'examId': widget.examId},
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit exam: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (_isSubmitting) return false; // Prevent exit during submission

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Exam?'),
        content: const Text(
          'Your progress will be lost if you exit the exam. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    if (shouldExit == true && mounted) {
      await _submitExam('User exited manually');
      return true;
    }
    return false;
  }

  void _showSubmitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Exam?'),
        content: const Text(
          'Are you sure you want to submit your exam? You cannot change your answers after submission.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Review Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _submitExam('User submitted');
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExamProvider>(
      builder: (context, examProvider, child) {
        if (_isInitializing) {
          return _buildLoadingScreen();
        }

        if (_errorMessage != null) {
          return _buildErrorScreen();
        }

        final currentSession = examProvider.currentSession;
        final currentQuestion = examProvider.currentQuestion;

        if (currentSession == null || currentQuestion == null) {
          return _buildErrorScreen(message: 'Exam session not available');
        }

        return _buildExamScreen(examProvider, currentSession, currentQuestion);
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Setting up your exam...',
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait',
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.primaryText.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen({String? message}) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.errorColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Exam Error',
                style: TextStyles.headline2.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message ?? _errorMessage ?? 'Something went wrong',
                textAlign: TextAlign.center,
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.primaryText.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Go Back',
                onPressed: () {
                  _disableSecurity();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExamScreen(
    ExamProvider examProvider,
    ExamSession currentSession,
    Question currentQuestion,
  ) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          title: Text(
            widget.examTitle,
            style: TextStyles.bodyLarge.copyWith(
              color: AppColors.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: AppColors.secondaryBackground,
          elevation: 1,
          leading: Container(), // Remove back button
          actions: [
            TimerWidget(
              duration: currentSession.duration,
              onTimeUp: () => _submitExam('Time expired'),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Question Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${examProvider.currentQuestionIndex + 1} of ${examProvider.totalQuestions}',
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryText.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    '${(examProvider.progress * 100).toStringAsFixed(0)}% Complete',
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: examProvider.progress,
                backgroundColor: AppColors.secondaryBackground,
                color: AppColors.accentColor,
              ),
              const SizedBox(height: 24),

              // Question Widget
              Expanded(
                child: QuestionWidget(
                  question: currentQuestion,
                  selectedAnswer: currentSession.answers[currentQuestion.id],
                  onAnswerSelected: (answer) {
                    examProvider.answerQuestion(currentQuestion.id, answer);
                  },
                ),
              ),

              // Navigation Buttons
              const SizedBox(height: 24),
              Row(
                children: [
                  if (examProvider.hasPreviousQuestion)
                    Expanded(
                      child: CustomButton(
                        text: 'Previous',
                        variant: ButtonVariant.outlined,
                        onPressed: _isSubmitting
                            ? null
                            : examProvider.previousQuestion,
                      ),
                    ),
                  if (examProvider.hasPreviousQuestion)
                    const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: examProvider.currentQuestionIndex ==
                              examProvider.totalQuestions - 1
                          ? _isSubmitting
                              ? 'Submitting...'
                              : 'Submit Exam'
                          : 'Next',
                      onPressed: _isSubmitting
                          ? null
                          : () {
                              if (examProvider.currentQuestionIndex ==
                                  examProvider.totalQuestions - 1) {
                                _showSubmitConfirmation();
                              } else {
                                examProvider.nextQuestion();
                              }
                            },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disableSecurity();
    super.dispose();
  }
}
