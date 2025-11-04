// class ExamSession {
//   final String id;
//   final String userId;
//   final String examId;
//   final DateTime startTime; // Changed from startedAt to startTime
//   final DateTime? completedAt;
//   final Map<String, String>
//       answers; // Changed from int to String to match your ExamPage
//   final int score;
//   final int totalPoints;
//   final Duration duration; // Added this property
//   final int timeTaken; // in seconds
//   final List<String> securityBreaches;
//   final String submissionReason;
//   final bool isCompleted;

//   ExamSession({
//     required this.id,
//     required this.userId,
//     required this.examId,
//     required this.startTime, // Changed from startedAt
//     this.completedAt,
//     required this.answers,
//     required this.score,
//     required this.totalPoints,
//     required this.duration, // Added this
//     required this.timeTaken,
//     required this.securityBreaches,
//     required this.submissionReason,
//     required this.isCompleted,
//   });

//   factory ExamSession.fromJson(Map<String, dynamic> json) {
//     return ExamSession(
//       id: json['id'] ?? '',
//       userId: json['user_id'] ?? '',
//       examId: json['exam_id'] ?? '',
//       startTime: DateTime.parse(json['start_time'] ??
//           json['started_at'] ??
//           DateTime.now().toIso8601String()),
//       completedAt: json['completed_at'] != null
//           ? DateTime.parse(json['completed_at'])
//           : null,
//       answers:
//           Map<String, String>.from(json['answers'] ?? {}), // Changed to String
//       score: json['score'] ?? 0,
//       totalPoints: json['total_points'] ?? 0,
//       duration: Duration(minutes: json['duration'] ?? 60), // Added this
//       timeTaken: json['time_taken'] ?? 0,
//       securityBreaches: List<String>.from(json['security_breaches'] ?? []),
//       submissionReason: json['submission_reason'] ?? 'completed',
//       isCompleted: json['is_completed'] ?? false,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'user_id': userId,
//       'exam_id': examId,
//       'start_time': startTime.toIso8601String(), // Changed from started_at
//       'completed_at': completedAt?.toIso8601String(),
//       'answers': answers,
//       'score': score,
//       'total_points': totalPoints,
//       'duration': duration.inMinutes, // Added this
//       'time_taken': timeTaken,
//       'security_breaches': securityBreaches,
//       'submission_reason': submissionReason,
//       'is_completed': isCompleted,
//     };
//   }

//   // Fixed remainingTime calculation
//   int get remainingTime {
//     final elapsed = DateTime.now().difference(startTime);
//     final remaining = duration - elapsed;
//     return remaining.inMinutes.clamp(0, duration.inMinutes);
//   }

//   int get percentageScore => totalPoints > 0 ? (score * 100 ~/ totalPoints) : 0;
//   int get correctAnswers =>
//       answers.values.where((answer) => answer.isNotEmpty).length;
//   int get totalQuestions => answers.length;

//   double get progress =>
//       totalQuestions > 0 ? answers.length / totalQuestions : 0.0;

//   String get status {
//     if (!isCompleted) return 'In Progress';
//     if (percentageScore >= 80) return 'Excellent';
//     if (percentageScore >= 60) return 'Good';
//     if (percentageScore >= 40) return 'Average';
//     return 'Needs Improvement';
//   }
// }

class ExamSession {
  final String id;
  final String examId;
  final String userId;
  final DateTime startTime;
  final Map<String, String> answers;
  final int score;
  final int totalPoints;
  final Duration duration;
  final int timeTaken;
  final List<String> securityBreaches;
  final String submissionReason;
  final bool isCompleted;

  const ExamSession({
    required this.id,
    required this.examId,
    required this.userId,
    required this.startTime,
    required this.answers,
    required this.score,
    required this.totalPoints,
    required this.duration,
    required this.timeTaken,
    required this.securityBreaches,
    required this.submissionReason,
    required this.isCompleted,
  });

  ExamSession copyWith({
    String? id,
    String? examId,
    String? userId,
    DateTime? startTime,
    Map<String, String>? answers,
    int? score,
    int? totalPoints,
    Duration? duration,
    int? timeTaken,
    List<String>? securityBreaches,
    String? submissionReason,
    bool? isCompleted,
  }) {
    return ExamSession(
      id: id ?? this.id,
      examId: examId ?? this.examId,
      userId: userId ?? this.userId,
      startTime: startTime ?? this.startTime,
      answers: answers ?? this.answers,
      score: score ?? this.score,
      totalPoints: totalPoints ?? this.totalPoints,
      duration: duration ?? this.duration,
      timeTaken: timeTaken ?? this.timeTaken,
      securityBreaches: securityBreaches ?? this.securityBreaches,
      submissionReason: submissionReason ?? this.submissionReason,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
