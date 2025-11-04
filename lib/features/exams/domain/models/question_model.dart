class Question {
  final String id;
  final String examId;
  final String questionText;
  final List<String> options;
  final int correctOption;
  final String? explanation;
  final int points;
  final int timeLimit; // in seconds
  final DateTime createdAt;

  Question({
    required this.id,
    required this.examId,
    required this.questionText,
    required this.options,
    required this.correctOption,
    this.explanation,
    required this.points,
    required this.timeLimit,
    required this.createdAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      examId: json['exam_id'] ?? '',
      questionText: json['question_text'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctOption: json['correct_option'] ?? 0,
      explanation: json['explanation'],
      points: json['points'] ?? 1,
      timeLimit: json['time_limit'] ?? 60,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exam_id': examId,
      'question_text': questionText,
      'options': options,
      'correct_option': correctOption,
      'explanation': explanation,
      'points': points,
      'time_limit': timeLimit,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool isCorrect(int selectedOption) {
    return selectedOption == correctOption;
  }

  String get correctAnswerText {
    return options[correctOption];
  }
}
