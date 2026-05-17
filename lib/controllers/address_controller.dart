import 'package:get/get.dart';
import '../services/database_service.dart';

class AddressController extends GetxController {
  final _databaseService = Get.find<DatabaseService>();

  // Form controllers
  final street = ''.obs;
  final buildingNo = ''.obs;
  final apartmentNo = ''.obs;
  final city = ''.obs;
  final specialNotes = ''.obs;
  final addressType='normal'.obs;

  // State variables
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final addresses = RxList<Map<String, dynamic>>([]);

  final homeTypes = <String>['Apartment', 'Villa', 'House'];

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final userAddresses = await _databaseService.getUserAddresses();
      addresses.value =
          userAddresses.map((address) => address.toJson()).toList();

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to load addresses: $e';
      print('Error loading addresses: $e');
    }
  }

  Future<void> saveAddress() async {
    if (!validateForm()) return;
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final addressData = {
        'street': street.value,
        'building_no': buildingNo.value,
        'apartment_no': apartmentNo.value,
        'city': city.value,
        'special_notes': specialNotes.value,
        'is_default': true,
      };

      await _databaseService.saveAddress(addressData);
      await loadAddresses();

      resetForm();
      isLoading.value = false;
      addressType.value=='emergency'?
      Get.back()
          :
      Get.toNamed('/mainScreen');
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to save address: $e';
      print('Error saving address: $e');
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _databaseService.deleteAddress(addressId);
      await loadAddresses();

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to delete address: $e';
      print('Error deleting address: $e');
    }
  }

  void resetForm() {
    street.value = '';
    buildingNo.value = '';
    apartmentNo.value = '';
    city.value = '';
    specialNotes.value = '';
    errorMessage.value = '';
  }

  bool validateForm() {
    if (street.value.isEmpty) {
      errorMessage.value = 'Please enter street';
      return false;
    }
    if (buildingNo.value.isEmpty) {
      errorMessage.value = 'Please enter building number';
      return false;
    }
    return true;
  }
}
