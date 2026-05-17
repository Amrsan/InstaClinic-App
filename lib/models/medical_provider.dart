class MedicalProvider {
  final String id;
  final String firstName;
  final String lastName;
  final String specialization;
  final String? bio;
  final String? photoUrl;
  final int? yearsExperience;
  final double rating;
  final bool isActive;
  final double? visitFee;
  final List<String>? servicesOffered;
  final String? serviceArea;
  final DateTime createdAt;
  final DateTime updatedAt;

  MedicalProvider({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.specialization,
    this.bio,
    this.photoUrl,
    this.yearsExperience,
    this.rating = 0.0,
    this.isActive = true,
    this.visitFee,
    this.servicesOffered,
    this.serviceArea,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory MedicalProvider.fromJson(Map<String, dynamic> json) {
    return MedicalProvider(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      specialization: json['specialization'],
      bio: json['bio'],
      photoUrl: json['photo_url'],
      yearsExperience: json['years_experience'],
      rating: json['rating']?.toDouble() ?? 0.0,
      isActive: json['is_active'] ?? true,
      visitFee: json['visit_fee']?.toDouble(),
      servicesOffered: json['services_offered'] != null 
          ? List<String>.from(json['services_offered']) 
          : null,
      serviceArea: json['service_area'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'specialization': specialization,
    'bio': bio,
    'photo_url': photoUrl,
    'years_experience': yearsExperience,
    'rating': rating,
    'is_active': isActive,
    'visit_fee': visitFee,
    'services_offered': servicesOffered,
    'service_area': serviceArea,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
} 