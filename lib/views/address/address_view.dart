import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/address_controller.dart';

class AddressView extends GetView<AddressController> {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).textScaleFactor;
    Get.put(AddressController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF55B7B6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Address Deliver To ',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              width: 350,
              child: Image.asset("assets/images/8611174_3929710 1.png"),
            ),
            SizedBox(height: 24 * scale),
            TextField(
              decoration: InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF55B7B6)),
                ),
              ),
              onChanged: (value) => controller.city.value = value,
            ),
            SizedBox(height: 24 * scale),
            TextField(
              decoration: InputDecoration(
                labelText: 'Resort ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF55B7B6)),
                ),
              ),
              onChanged: (value) => controller.street.value = value,
            ),
            SizedBox(height: 24 * scale),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Building No.',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF55B7B6)),
                      ),
                    ),
                    onChanged: (value) => controller.buildingNo.value = value,
                  ),
                ),
                SizedBox(width: 16 * scale),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Apartment No.',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF55B7B6)),
                      ),
                    ),
                    onChanged: (value) => controller.apartmentNo.value = value,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24 * scale),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Special Notes or location link(optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF55B7B6)),
                ),
              ),
              onChanged: (value) => controller.specialNotes.value = value,
            ),
            SizedBox(height: 32 * scale),
            SizedBox(
              height: 48 * scale,
              child: ElevatedButton(
                onPressed: () => controller.saveAddress(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF55B7B6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
