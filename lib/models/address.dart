class Address {
  final String id;
  final String userId;
  final String? government;
  final String? city;
  final String? street;
  final String? buildingNo;
  final String? apartmentNo;
  final String? floorNo;
  final String? homeType;
  final String? specialNotes;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  Address({
    required this.id,
    required this.userId,
    this.government,
    this.city,
    this.street,
    this.buildingNo,
    this.apartmentNo,
    this.floorNo,
    this.homeType,
    this.specialNotes,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      userId: json['user_id'],
      government: json['government'],
      city: json['city'],
      street: json['street'],
      buildingNo: json['building_no'],
      apartmentNo: json['apartment_no'],
      floorNo: json['floor_no'],
      homeType: json['home_type'],
      specialNotes: json['special_notes'],
      isDefault: json['is_default'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'government': government,
    'city': city,
    'street': street,
    'building_no': buildingNo,
    'apartment_no': apartmentNo,
    'floor_no': floorNo,
    'home_type': homeType,
    'special_notes': specialNotes,
    'is_default': isDefault,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}