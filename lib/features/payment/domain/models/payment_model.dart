class Payment {
  final String id;
  final String userId;
  final double amount;
  final String method;
  final String status;
  String? transactionRef;
  final String? proofUrl;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    required this.id,
    required this.userId,
    required this.amount,
    required this.method,
    required this.status,
    this.transactionRef,
    this.proofUrl,
    this.verifiedBy,
    this.verifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      method: json['method'] ?? '',
      status: json['status'] ?? 'pending',
      transactionRef: json['transaction_ref'],
      proofUrl: json['proof_url'],
      verifiedBy: json['verified_by'],
      verifiedAt: json['verified_at'] != null
          ? DateTime.parse(json['verified_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'method': method,
      'status': status,
      'transaction_ref': transactionRef,
      'proof_url': proofUrl,
      'verified_by': verifiedBy,
      'verified_at': verifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
  bool get isVerified => isApproved;

  String get displayStatus {
    switch (status) {
      case 'pending':
        return 'Pending Review';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return status;
    }
  }

  String get displayMethod {
    switch (method) {
      case 'cbe':
        return 'CBE Birr';
      case 'telebirr':
        return 'Telebirr';
      case 'amole':
        return 'Amole';
      case 'hellocash':
        return 'HelloCash';
      default:
        return method;
    }
  }
}

class PaymentMethod {
  final String id;
  final String name;
  final String code;
  final String description;
  final String instructions;
  final bool isActive;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.instructions,
    required this.isActive,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      instructions: json['instructions'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'instructions': instructions,
      'is_active': isActive,
    };
  }
}
