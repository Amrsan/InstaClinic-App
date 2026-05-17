class Review {
  final String id;
  final String userId;
  final String bookingId;
  final String? providerId;
  final String? serviceId;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.userId,
    required this.bookingId,
    this.providerId,
    this.serviceId,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['user_id'],
      bookingId: json['booking_id'],
      providerId: json['provider_id'],
      serviceId: json['service_id'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'booking_id': bookingId,
    'provider_id': providerId,
    'service_id': serviceId,
    'rating': rating,
    'comment': comment,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}