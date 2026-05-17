import 'package:get/get.dart';
import '../services/database_service.dart';
import '../models/models.dart';

class ServiceController extends GetxController {
  final _databaseService = Get.find<DatabaseService>();
  
  final services = RxList<Service>([]);
  final selectedService = Rx<Service?>(null);
  final providers = RxList<MedicalProvider>([]);
  final selectedProvider = Rx<MedicalProvider?>(null);
  
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  
  final selectedCategory = ''.obs;
  final categories = ServiceCategories.getAll();
  
  // Booking form fields
  final selectedDate = Rx<DateTime?>(null);
  final selectedTime = ''.obs;
  final selectedAddressId = ''.obs;
  final patientName = ''.obs;
  final patientAge = ''.obs;
  final patientGender = ''.obs;
  final contactNumber = ''.obs;
  final medicalCondition = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadServices();
  }
  
  Future<void> loadServices({String? category}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final servicesList = await _databaseService.getServices(
        category: category ?? selectedCategory.value
      );
      
      services.value = servicesList;
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to load services: $e';
      print('Error loading services: $e');
    }
  }
  
  void selectService(Service service) {
    selectedService.value = service;
    selectedProvider.value = null;
    loadProviders(service.requiredProviderSpecializations?.first);
  }
  
  Future<void> loadProviders(String? specialization) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final providersList = await _databaseService.getProviders(
        specialization: specialization ?? ""
      );
      
      providers.value = providersList;
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to load providers: $e';
      print('Error loading providers: $e');
    }
  }
  
  void selectProvider(MedicalProvider provider) {
    selectedProvider.value = provider;
  }
  
  void setCategory(String category) {
    selectedCategory.value = category;
    loadServices(category: category);
  }
  
  void clearFilters() {
    selectedCategory.value = '';
    loadServices();
  }
  
  Future<bool> createBooking() async {
    if (!validateBookingForm()) return false;
    
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final bookingData = {
        'service_id': selectedService.value!.id,
        'provider_id': selectedProvider.value?.id,
        'address_id': selectedAddressId.value,
        'booking_date': selectedDate.value!.toIso8601String().split('T')[0],
        'booking_time': selectedTime.value,
        'fee': selectedService.value!.price,
        'patient_name': patientName.value,
        'patient_age': patientAge.value,
        'patient_gender': patientGender.value,
        'contact_number': contactNumber.value,
        'medical_condition': medicalCondition.value,
        'status': 'pending',
      };
      
      await _databaseService.createBooking(bookingData);
      
      resetBookingForm();
      isLoading.value = false;
      
      return true;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to create booking: $e';
      print('Error creating booking: $e');
      return false;
    }
  }
  
  bool validateBookingForm() {
    if (selectedService.value == null) {
      errorMessage.value = 'Please select a service';
      return false;
    }
    if (selectedAddressId.value.isEmpty) {
      errorMessage.value = 'Please select an address';
      return false;
    }
    if (selectedDate.value == null) {
      errorMessage.value = 'Please select a date';
      return false;
    }
    if (selectedTime.value.isEmpty) {
      errorMessage.value = 'Please select a time';
      return false;
    }
    if (contactNumber.value.isEmpty) {
      errorMessage.value = 'Please enter contact number';
      return false;
    }
    return true;
  }
  
  void resetBookingForm() {
    selectedService.value = null;
    selectedProvider.value = null;
    selectedDate.value = null;
    selectedTime.value = '';
    selectedAddressId.value = '';
    patientName.value = '';
    patientAge.value = '';
    patientGender.value = '';
    contactNumber.value = '';
    medicalCondition.value = '';
    errorMessage.value = '';
  }
} 