import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../controllers/services_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServicesView extends StatelessWidget {
  const ServicesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ServicesController controller = Get.put(ServicesController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Clinics'),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.services.length,
                itemBuilder: (context, index) {
                  final service = controller.services[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Icon(
                          Icons.medical_services,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(service.name),
                      subtitle: Text(service.category),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => controller.deleteService(service.id),
                      ),
                    ),
                  );
                },
              )),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchTableData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No data found.');
                }
                final data = snapshot.data!;
                return Expanded(
                  child: ListView(
                    children: data.map((row) => ListTile(
                      title: Text(row['some_field'].toString()),
                    )).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddServiceDialog(context, controller),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddServiceDialog(BuildContext context, ServicesController controller) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Service'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Service Name'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a category' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a price' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration (minutes)',
                    hintText: '60',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => controller.pickImage(),
                  icon: const Icon(Icons.upload),
                  label: const Text('Upload Image'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => controller.selectedImageName.isNotEmpty
                    ? Text(
                        'Selected: ${controller.selectedImageName}',
                        style: const TextStyle(color: Colors.green),
                      )
                    : const SizedBox()),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                controller.createService(
                  name: nameController.text,
                  category: categoryController.text,
                  description: descriptionController.text,
                  price: double.parse(priceController.text),
                  durationMinutes: int.tryParse(durationController.text) ?? 60,
                );
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Add Service'),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchDashboardBookings() async {
    final response = await Supabase.instance.client
        .from('bookings')
        .select('*, user:users(id, name, email, phone_number), address:addresses(*), service:services(category)')
        .order('created_at', ascending: false)
        .limit(20);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchTableData() async {
    final response = await Supabase.instance.client.from('bookings').select('*');
    return List<Map<String, dynamic>>.from(response);
  }
}