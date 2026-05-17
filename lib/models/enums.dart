// Booking status
enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled
}

extension BookingStatusExtension on BookingStatus {
  String get value {
    switch (this) {
      case BookingStatus.pending:
        return 'pending';
      case BookingStatus.confirmed:
        return 'confirmed';
      case BookingStatus.completed:
        return 'completed';
      case BookingStatus.cancelled:
        return 'cancelled';
    }
  }
  
  static BookingStatus fromString(String status) {
    switch (status) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.pending;
    }
  }
}

// Payment methods
enum PaymentMethod {
  creditCard,
  debitCard,
  cash,
  insurance
}

extension PaymentMethodExtension on PaymentMethod {
  String get value {
    switch (this) {
      case PaymentMethod.creditCard:
        return 'credit_card';
      case PaymentMethod.debitCard:
        return 'debit_card';
      case PaymentMethod.cash:
        return 'cash';
      case PaymentMethod.insurance:
        return 'insurance';
    }
  }
  
  static PaymentMethod fromString(String method) {
    switch (method) {
      case 'credit_card':
        return PaymentMethod.creditCard;
      case 'debit_card':
        return PaymentMethod.debitCard;
      case 'cash':
        return PaymentMethod.cash;
      case 'insurance':
        return PaymentMethod.insurance;
      default:
        return PaymentMethod.creditCard;
    }
  }
}

// Payment status
enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded
}

extension PaymentStatusExtension on PaymentStatus {
  String get value {
    switch (this) {
      case PaymentStatus.pending:
        return 'pending';
      case PaymentStatus.completed:
        return 'completed';
      case PaymentStatus.failed:
        return 'failed';
      case PaymentStatus.refunded:
        return 'refunded';
    }
  }
  
  static PaymentStatus fromString(String status) {
    switch (status) {
      case 'pending':
        return PaymentStatus.pending;
      case 'completed':
        return PaymentStatus.completed;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }
}

// Service categories
class ServiceCategories {
  static const String generalCheckup = 'General Checkup';
  static const String bloodTest = 'Blood Test';
  static const String injection = 'Injection';
  static const String vaccination = 'Vaccination';
  static const String nursing = 'Nursing';
  static const String physiotherapy = 'Physiotherapy';
  static const String elderCare = 'Elder Care';
  static const String pediatricCare = 'Pediatric Care';
  static const String mentalHealth = 'Mental Health';
  
  static List<String> getAll() {
    return [
      generalCheckup,
      bloodTest,
      injection,
      vaccination,
      nursing,
      physiotherapy,
      elderCare,
      pediatricCare,
      mentalHealth,
    ];
  }
}

// Provider specializations
class ProviderSpecializations {
  static const String generalPractitioner = 'General Practitioner';
  static const String nurse = 'Nurse';
  static const String phlebotomist = 'Phlebotomist';
  static const String physiotherapist = 'Physiotherapist';
  static const String pediatrician = 'Pediatrician';
  static const String geriatrician = 'Geriatrician';
  static const String psychiatrist = 'Psychiatrist';
  static const String nutritionist = 'Nutritionist';
  
  static List<String> getAll() {
    return [
      generalPractitioner,
      nurse,
      phlebotomist,
      physiotherapist,
      pediatrician,
      geriatrician,
      psychiatrist,
      nutritionist,
    ];
  }
} 