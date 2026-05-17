import 'package:get/get.dart';
import '../services/database_service.dart';
import '../models/models.dart';

class ClinicController extends GetxController {
  final _databaseService = Get.find<DatabaseService>();
  
  final services = RxList<Service>([]);
  final selectedService = Rx<Service?>(null);
  final providers = RxList<MedicalProvider>([]);
  final selectedProvider = Rx<MedicalProvider?>(null);
  
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  
  final selectedCategory = ''.obs;
  final categories = ServiceCategories.getAll();
  
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
        specialization: specialization??""
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
} 