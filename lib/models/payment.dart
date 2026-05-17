class Payment {
  final String id;
  final String bookingId;
  final String userId;
  final double amount;
  final String currency;
  final String paymentMethod;
  final String status;
  final String? transactionId;
  final DateTime paymentDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.amount,
    this.currency = 'EGP',
    required this.paymentMethod,
    this.status = 'pending',
    this.transactionId,
    required this.paymentDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      bookingId: json['booking_id'],
      userId: json['user_id'],
      amount: json['amount'].toDouble(),
      currency: json['currency'] ?? 'EGP',
      paymentMethod: json['payment_method'],
      status: json['status'] ?? 'pending',
      transactionId: json['transaction_id'],
      paymentDate: DateTime.parse(json['payment_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'booking_id': bookingId,
    'user_id': userId,
    'amount': amount,
    'currency': currency,
    'payment_method': paymentMethod,
    'status': status,
    'transaction_id': transactionId,
    'payment_date': paymentDate.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}