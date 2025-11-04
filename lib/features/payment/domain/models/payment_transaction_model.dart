class PaymentTransaction {
  final String id;
  final String userId;
  final double amount;
  final String currency;
  final String method;
  final String status;
  final String? transactionId;
  final String? referenceNumber;
  final String? proofImageUrl;
  final DateTime createdAt;
  final DateTime? verifiedAt;
  final String? verifiedBy;
  final String? rejectionReason;

  PaymentTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.method,
    required this.status,
    this.transactionId,
    this.referenceNumber,
    this.proofImageUrl,
    required this.createdAt,
    this.verifiedAt,
    this.verifiedBy,
    this.rejectionReason,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'ETB',
      method: json['method'] ?? '',
      status: json['status'] ?? 'pending',
      transactionId: json['transaction_id'],
      referenceNumber: json['reference_number'],
      proofImageUrl: json['proof_image_url'],
      createdAt: DateTime.parse(json['created_at']),
      verifiedAt: json['verified_at'] != null
          ? DateTime.parse(json['verified_at'])
          : null,
      verifiedBy: json['verified_by'],
      rejectionReason: json['rejection_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'currency': currency,
      'method': method,
      'status': status,
      'transaction_id': transactionId,
      'reference_number': referenceNumber,
      'proof_image_url': proofImageUrl,
      'created_at': createdAt.toIso8601String(),
      'verified_at': verifiedAt?.toIso8601String(),
      'verified_by': verifiedBy,
      'rejection_reason': rejectionReason,
    };
  }

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
  bool get isProcessing => status == 'processing';

  String get displayStatus {
    switch (status) {
      case 'pending':
        return 'Pending Review';
      case 'processing':
        return 'Processing';
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
