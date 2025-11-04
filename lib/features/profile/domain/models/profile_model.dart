class Profile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String region;
  final String? languageStream;
  final String grade;
  final String paymentStatus;
  final String? profilePhoto;
  final List<String> roles;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deviceFingerprint;
  final DateTime? deviceRegisteredAt;
  final ProfileStats? stats;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.region,
    required this.languageStream,
    required this.grade,
    required this.paymentStatus,
    this.profilePhoto,
    required this.roles,
    required this.createdAt,
    required this.updatedAt,
    this.deviceFingerprint,
    this.deviceRegisteredAt,
    this.stats,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      region: json['region'] ?? '',
      languageStream: json['language_stream'],
      grade: json['grade'] ?? '',
      paymentStatus: json['payment_status'] ?? 'free',
      profilePhoto: json['profile_photo'],
      roles: List<String>.from(json['roles'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deviceFingerprint: json['device_fingerprint'],
      deviceRegisteredAt: json['device_registered_at'] != null
          ? DateTime.parse(json['device_registered_at'])
          : null,
      stats: json['stats'] != null
          ? ProfileStats.fromJson(json['stats'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'region': region,
      'language_stream': languageStream,
      'grade': grade,
      'payment_status': paymentStatus,
      'profile_photo': profilePhoto,
      'roles': roles,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'device_fingerprint': deviceFingerprint,
      'device_registered_at': deviceRegisteredAt?.toIso8601String(),
      'stats': stats?.toJson(),
    };
  }

  bool get isPremium => paymentStatus == 'premium';
  bool get isPaymentPending => paymentStatus == 'pending';
  bool get isFree => paymentStatus == 'free';

  String get displayLanguage {
    if (region == 'Harar') return 'Harari';
    return languageStream ?? 'Not specified';
  }

  String get displayRegion {
    switch (region) {
      case 'Oromia':
        return 'Oromia';
      case 'Dire Dawa':
        return 'Dire Dawa';
      case 'Harar':
        return 'Harar';
      default:
        return region;
    }
  }

  String get initial => name.isNotEmpty ? name[0].toUpperCase() : 'S';

  Profile copyWith({
    String? name,
    String? email,
    String? phone,
    String? profilePhoto,
    String? paymentStatus,
    ProfileStats? stats,
  }) {
    return Profile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      region: region,
      languageStream: languageStream,
      grade: grade,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      roles: List.from(roles),
      createdAt: createdAt,
      updatedAt: updatedAt,
      deviceFingerprint: deviceFingerprint,
      deviceRegisteredAt: deviceRegisteredAt,
      stats: stats ?? this.stats,
    );
  }
}

class ProfileStats {
  final int totalExamsTaken;
  final double averageScore;
  final int examsThisWeek;
  final int examsThisMonth;
  final int totalStudyTime; // in minutes
  final Map<String, SubjectStats> subjectStats;
  final DateTime? lastActive;
  final int streakDays;

  ProfileStats({
    required this.totalExamsTaken,
    required this.averageScore,
    required this.examsThisWeek,
    required this.examsThisMonth,
    required this.totalStudyTime,
    required this.subjectStats,
    this.lastActive,
    required this.streakDays,
  });

  factory ProfileStats.fromJson(Map<String, dynamic> json) {
    final subjectStatsMap = <String, SubjectStats>{};
    if (json['subject_stats'] != null) {
      (json['subject_stats'] as Map<String, dynamic>).forEach((key, value) {
        subjectStatsMap[key] = SubjectStats.fromJson(value);
      });
    }

    return ProfileStats(
      totalExamsTaken: json['total_exams_taken'] ?? 0,
      averageScore: (json['average_score'] ?? 0.0).toDouble(),
      examsThisWeek: json['exams_this_week'] ?? 0,
      examsThisMonth: json['exams_this_month'] ?? 0,
      totalStudyTime: json['total_study_time'] ?? 0,
      subjectStats: subjectStatsMap,
      lastActive: json['last_active'] != null
          ? DateTime.parse(json['last_active'])
          : null,
      streakDays: json['streak_days'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final subjectStatsJson = <String, dynamic>{};
    subjectStats.forEach((key, value) {
      subjectStatsJson[key] = value.toJson();
    });

    return {
      'total_exams_taken': totalExamsTaken,
      'average_score': averageScore,
      'exams_this_week': examsThisWeek,
      'exams_this_month': examsThisMonth,
      'total_study_time': totalStudyTime,
      'subject_stats': subjectStatsJson,
      'last_active': lastActive?.toIso8601String(),
      'streak_days': streakDays,
    };
  }

  int get totalCorrectAnswers {
    return subjectStats.values.fold(
      0,
      (sum, stats) => sum + stats.correctAnswers,
    );
  }

  int get totalQuestionsAttempted {
    return subjectStats.values.fold(
      0,
      (sum, stats) => sum + stats.questionsAttempted,
    );
  }

  double get overallAccuracy {
    return totalQuestionsAttempted > 0
        ? (totalCorrectAnswers / totalQuestionsAttempted) * 100
        : 0.0;
  }

  String get formattedTotalStudyTime {
    final hours = totalStudyTime ~/ 60;
    final minutes = totalStudyTime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  bool get hasActiveStreak => streakDays > 0;
}

class SubjectStats {
  final String subject;
  final int examsTaken;
  final double averageScore;
  final int correctAnswers;
  final int questionsAttempted;
  final int totalStudyTime; // in minutes
  final DateTime? lastAttempt;

  SubjectStats({
    required this.subject,
    required this.examsTaken,
    required this.averageScore,
    required this.correctAnswers,
    required this.questionsAttempted,
    required this.totalStudyTime,
    this.lastAttempt,
  });

  factory SubjectStats.fromJson(Map<String, dynamic> json) {
    return SubjectStats(
      subject: json['subject'] ?? '',
      examsTaken: json['exams_taken'] ?? 0,
      averageScore: (json['average_score'] ?? 0.0).toDouble(),
      correctAnswers: json['correct_answers'] ?? 0,
      questionsAttempted: json['questions_attempted'] ?? 0,
      totalStudyTime: json['total_study_time'] ?? 0,
      lastAttempt: json['last_attempt'] != null
          ? DateTime.parse(json['last_attempt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'exams_taken': examsTaken,
      'average_score': averageScore,
      'correct_answers': correctAnswers,
      'questions_attempted': questionsAttempted,
      'total_study_time': totalStudyTime,
      'last_attempt': lastAttempt?.toIso8601String(),
    };
  }

  double get accuracy {
    return questionsAttempted > 0
        ? (correctAnswers / questionsAttempted) * 100
        : 0.0;
  }

  String get formattedStudyTime {
    final hours = totalStudyTime ~/ 60;
    final minutes = totalStudyTime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

class ProfileUpdateRequest {
  final String? name;
  final String? email;
  final String? phone;
  final String? profilePhoto;

  ProfileUpdateRequest({this.name, this.email, this.phone, this.profilePhoto});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    if (profilePhoto != null) data['profile_photo'] = profilePhoto;
    return data;
  }

  bool get hasChanges {
    return name != null ||
        email != null ||
        phone != null ||
        profilePhoto != null;
  }
}

class PasswordChangeRequest {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  PasswordChangeRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'current_password': currentPassword,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    };
  }

  bool get isValid {
    return newPassword == confirmPassword &&
        newPassword.length >= 8 &&
        newPassword.contains(RegExp(r'[A-Za-z]')) &&
        newPassword.contains(RegExp(r'[0-9]'));
  }
}
