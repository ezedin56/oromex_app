import 'package:flutter/foundation.dart';
import '../../exams/domain/models/exam_session_model.dart';
import '../../exams/domain/models/question_model.dart';
import '../../exams/domain/models/exam_model.dart';

class ExamProvider with ChangeNotifier {
  // Exam session properties
  ExamSession? _currentSession;
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;

  // Exam selection properties
  List<Exam> _availableExams = [];
  List<Exam> _filteredExams = [];
  bool _isLoading = false;

  // User progress tracking
  Map<String, Map<String, dynamic>> _userProgress =
      {}; // examId -> progress data

  // Getters for exam session
  ExamSession? get currentSession => _currentSession;
  Question? get currentQuestion =>
      _questions.isNotEmpty ? _questions[_currentQuestionIndex] : null;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get totalQuestions => _questions.length;
  bool get hasNextQuestion => _currentQuestionIndex < _questions.length - 1;
  bool get hasPreviousQuestion => _currentQuestionIndex > 0;
  bool get isExamActive =>
      _currentSession != null && !_currentSession!.isCompleted;

  // Getters for exam selection
  List<Exam> get availableExams =>
      _filteredExams.isNotEmpty ? _filteredExams : _availableExams;
  bool get isLoading => _isLoading;
  bool get hasExams => _availableExams.isNotEmpty;

  // Getters for user progress
  Map<String, Map<String, dynamic>> get userProgress => _userProgress;

  // Exam session methods
  Future<void> startExam(String examId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Find the exam to get its actual duration
      final exam = _availableExams.firstWhere(
        (exam) => exam.id == examId,
        orElse: () => Exam(
          id: examId,
          subject: 'Unknown',
          year: 2024,
          unit: 0,
          grade: 'Unknown',
          region: 'Unknown',
          languageStream: 'Unknown',
          title: 'Unknown Exam',
          description: 'Unknown',
          duration: 60, // in minutes
          totalQuestions: 0,
          isPremium: false,
          isFree: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // Mock data for testing - replace with actual API call
      _questions = [
        Question(
          id: '1',
          examId: examId,
          questionText: 'Sample question 1',
          options: ['Option A', 'Option B', 'Option C', 'Option D'],
          correctOption: 0,
          explanation: 'Sample explanation',
          points: 1,
          timeLimit: 60,
          createdAt: DateTime.now(),
        ),
        Question(
          id: '2',
          examId: examId,
          questionText: 'Sample question 2',
          options: ['Option A', 'Option B', 'Option C', 'Option D'],
          correctOption: 1,
          explanation: 'Sample explanation',
          points: 1,
          timeLimit: 60,
          createdAt: DateTime.now(),
        ),
      ];

      _currentSession = ExamSession(
        id: 'session_${DateTime.now().millisecondsSinceEpoch}',
        examId: examId,
        userId: 'user_1', // Replace with actual user ID
        startTime: DateTime.now(),
        answers: <String, String>{},
        score: 0,
        totalPoints: _questions.length,
        duration:
            Duration(minutes: exam.duration), // Convert minutes to Duration
        timeTaken: 0,
        securityBreaches: [],
        submissionReason: '',
        isCompleted: false,
      );

      _currentQuestionIndex = 0;

      // Initialize progress for this exam
      _initializeExamProgress(examId, _questions.length);
    } catch (e) {
      throw Exception('Failed to start exam: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitExam(String reason) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Calculate score before submitting
      if (_currentSession != null) {
        int score = 0;
        for (var question in _questions) {
          final userAnswer = _currentSession!.answers[question.id];
          if (userAnswer != null &&
              int.tryParse(userAnswer) == question.correctOption) {
            score += question.points;
          }
        }

        final timeTaken =
            DateTime.now().difference(_currentSession!.startTime).inSeconds;

        _currentSession = _currentSession!.copyWith(
          score: score,
          submissionReason: reason,
          isCompleted: true,
          timeTaken: timeTaken,
        );

        // Update progress when exam is submitted
        _updateExamProgress(_currentSession!.examId, score, timeTaken);

        // Here you would typically save to API
        if (kDebugMode) {
          print(
              'Exam submitted: $reason. Score: $score/${_questions.length}. Time taken: ${timeTaken}s');
        }
      }

      reset();
    } catch (e) {
      throw Exception('Failed to submit exam: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void answerQuestion(String questionId, String answer) {
    if (_currentSession != null) {
      final updatedAnswers = Map<String, String>.from(_currentSession!.answers);
      updatedAnswers[questionId] = answer;

      _currentSession = _currentSession!.copyWith(
        answers: updatedAnswers,
      );

      // Update progress when answering a question
      _updateQuestionProgress(_currentSession!.examId);
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (hasNextQuestion) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (hasPreviousQuestion) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  void reset() {
    _currentSession = null;
    _questions = [];
    _currentQuestionIndex = 0;
    notifyListeners();
  }

  // Exam selection methods
  Future<void> loadAvailableExams({
    String? region,
    String? languageStream,
    String? grade,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Mock data for testing - replace with actual API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      _availableExams = [
        Exam(
          id: '1',
          subject: 'Mathematics',
          year: 2024,
          unit: 1,
          grade: '7',
          region: 'National',
          languageStream: 'English',
          title: 'Mathematics Grade 7 - Unit 1',
          description: 'Grade 7 Mathematics Exam - Algebra Basics',
          duration: 60, // in minutes
          totalQuestions: 30,
          isPremium: false,
          isFree: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Exam(
          id: '2',
          subject: 'English',
          year: 2024,
          unit: 2,
          grade: '8',
          region: 'National',
          languageStream: 'English',
          title: 'English Grade 8 - Unit 2',
          description: 'Grade 8 English Exam - Grammar and Composition',
          duration: 45, // in minutes
          totalQuestions: 25,
          isPremium: true,
          isFree: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Exam(
          id: '3',
          subject: 'Science',
          year: 2024,
          unit: 3,
          grade: '9',
          region: 'National',
          languageStream: 'English',
          title: 'Science Grade 9 - Unit 3',
          description: 'Grade 9 Science Exam - Physics Fundamentals',
          duration: 90, // in minutes
          totalQuestions: 50,
          isPremium: false,
          isFree: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      _filteredExams = List.from(_availableExams);
    } catch (e) {
      throw Exception('Failed to load exams: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterExams({
    String? grade,
    int? year,
    int? unit,
    String? subject,
    String? region,
    String? languageStream,
    bool? isPremium,
  }) {
    _filteredExams = _availableExams.where((exam) {
      bool matchesGrade = grade == null || exam.grade == grade;
      bool matchesYear = year == null || exam.year == year;
      bool matchesUnit = unit == null || exam.unit == unit;
      bool matchesSubject = subject == null || exam.subject == subject;
      bool matchesRegion = region == null || exam.region == region;
      bool matchesLanguageStream =
          languageStream == null || exam.languageStream == languageStream;
      bool matchesPremium = isPremium == null || exam.isPremium == isPremium;

      return matchesGrade &&
          matchesYear &&
          matchesUnit &&
          matchesSubject &&
          matchesRegion &&
          matchesLanguageStream &&
          matchesPremium;
    }).toList();

    notifyListeners();
  }

  void clearFilters() {
    _filteredExams = List.from(_availableExams);
    notifyListeners();
  }

  // Time management methods
  Duration get remainingTime {
    if (_currentSession == null) return Duration.zero;

    final elapsed = DateTime.now().difference(_currentSession!.startTime);
    final remaining = _currentSession!.duration - elapsed;
    return remaining > Duration.zero ? remaining : Duration.zero;
  }

  bool get isTimeUp {
    if (_currentSession == null) return false;
    return DateTime.now().difference(_currentSession!.startTime) >=
        _currentSession!.duration;
  }

  double get timeProgress {
    if (_currentSession == null) return 0.0;

    final totalSeconds = _currentSession!.duration.inSeconds.toDouble();
    final elapsedSeconds = DateTime.now()
        .difference(_currentSession!.startTime)
        .inSeconds
        .toDouble();

    if (totalSeconds == 0) return 0.0;
    return (elapsedSeconds / totalSeconds).clamp(0.0, 1.0);
  }

  // Utility methods
  String? getAnswerForQuestion(String questionId) {
    return _currentSession?.answers[questionId];
  }

  bool isQuestionAnswered(String questionId) {
    return _currentSession?.answers.containsKey(questionId) ?? false;
  }

  int get answeredQuestionsCount {
    return _currentSession?.answers.length ?? 0;
  }

  double get progress {
    if (_questions.isEmpty) return 0.0;
    return (_currentQuestionIndex + 1) / _questions.length;
  }

  // Get exam by ID
  Exam? getExamById(String examId) {
    try {
      return _availableExams.firstWhere((exam) => exam.id == examId);
    } catch (e) {
      return null;
    }
  }

  // Check if user can access exam
  bool canAccessExam(Exam exam, bool isUserPremium) {
    return exam.isFree || (exam.isPremium && isUserPremium);
  }

  // User Progress Methods
  Map<String, dynamic>? getUserProgress(String examId) {
    return _userProgress[examId];
  }

  double getProgressForExam(String examId) {
    final progress = _userProgress[examId];
    if (progress == null) return 0.0;

    final totalQuestions = progress['totalQuestions'] ?? 0;
    final completedQuestions = progress['completedQuestions'] ?? 0;

    if (totalQuestions == 0) return 0.0;
    return (completedQuestions / totalQuestions).clamp(0.0, 1.0);
  }

  bool isExamCompleted(String examId) {
    return getProgressForExam(examId) >= 1.0;
  }

  // Private methods for progress tracking
  void _initializeExamProgress(String examId, int totalQuestions) {
    if (!_userProgress.containsKey(examId)) {
      _userProgress[examId] = {
        'totalQuestions': totalQuestions,
        'completedQuestions': 0,
        'score': 0,
        'timeSpent': 0,
        'lastAttempt': null,
        'progress': 0.0,
      };
    }
  }

  void _updateQuestionProgress(String examId) {
    final progress = _userProgress[examId];
    if (progress != null && _currentSession != null) {
      final completed = _currentSession!.answers.length;
      final total = progress['totalQuestions'] ?? 1;

      _userProgress[examId] = {
        ...progress,
        'completedQuestions': completed,
        'progress': completed / total,
      };
    }
  }

  void _updateExamProgress(String examId, int score, int timeTaken) {
    final progress = _userProgress[examId];
    if (progress != null) {
      _userProgress[examId] = {
        ...progress,
        'score': score,
        'timeSpent': timeTaken,
        'lastAttempt': DateTime.now(),
        'isCompleted': true,
      };
    }
  }

  // Method to manually update progress (useful for syncing with backend)
  void updateUserProgress({
    required String examId,
    required int totalQuestions,
    required int completedQuestions,
    int? score,
    int? timeSpent,
    DateTime? lastAttempt,
  }) {
    _userProgress[examId] = {
      'totalQuestions': totalQuestions,
      'completedQuestions': completedQuestions,
      'score': score,
      'timeSpent': timeSpent,
      'lastAttempt': lastAttempt ?? DateTime.now(),
      'progress': completedQuestions / totalQuestions,
      'isCompleted': completedQuestions >= totalQuestions,
    };
    notifyListeners();
  }
}
