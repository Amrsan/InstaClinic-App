class Booking {
  final String id;
  final String userId;
  final String? providerId;
  final String serviceId;
  final String addressId;
  final DateTime bookingDate;
  final String bookingTime;
  final String status;
  final String contactNumber;
  final String? notes;
  final double? fee;
  final String? patientName;
  final String? patientAge;
  final String? patientGender;
  final String? medicalCondition;
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.userId,
    this.providerId,
    required this.serviceId,
    required this.addressId,
    required this.bookingDate,
    required this.bookingTime,
    this.status = 'pending',
    required this.contactNumber,
    this.notes,
    this.fee,
    this.patientName,
    this.patientAge,
    this.patientGender,
    this.medicalCondition,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      providerId: json['provider_id'],
      serviceId: json['service_id'] ?? '',
      addressId: json['address_id'],
      bookingDate: DateTime.parse(json['booking_date']),
      bookingTime: json['booking_time'],
      status: json['status'] ?? 'pending',
      contactNumber: json['contact_number'] ?? '',
      notes: json['notes'],
      fee: json['fee']?.toDouble(),
      patientName: json['patient_name'],
      patientAge: json['patient_age'],
      patientGender: json['patient_gender'],
      medicalCondition: json['medical_condition'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'provider_id': providerId,
    'service_id': serviceId,
    'address_id': addressId,
    'booking_date': bookingDate.toIso8601String().split('T')[0],
    'booking_time': bookingTime,
    'status': status,
    'contact_number': contactNumber,
    'notes': notes,
    'fee': fee,
    'patient_name': patientName,
    'patient_age': patientAge,
    'patient_gender': patientGender,
    'medical_condition': medicalCondition,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
} 