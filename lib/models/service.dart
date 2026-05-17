class Service {
  final String id;
  final String name;
  final String category;
  final String? description;
  final double price;
  final String? imageUrl;
  final int durationMinutes;
  final bool requiresEquipment;
  final List<String>? requiredProviderSpecializations;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Service({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    required this.price,
    this.imageUrl,
    required this.durationMinutes,
    this.requiresEquipment = false,
    this.requiredProviderSpecializations,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      price: json['price']?.toDouble() ?? 0.0,
      imageUrl: json['image_url'],
      durationMinutes: json['duration_minutes'] ?? 60,
      requiresEquipment: json['requires_equipment'] ?? false,
      requiredProviderSpecializations: json['required_provider_specializations'] != null 
          ? List<String>.from(json['required_provider_specializations']) 
          : null,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'description': description,
    'price': price,
    'image_url': imageUrl,
    'duration_minutes': durationMinutes,
    'requires_equipment': requiresEquipment,
    'required_provider_specializations': requiredProviderSpecializations,
    'is_active': isActive,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
} 