import 'package:flutter/material.dart';
import 'package:get/get.dart'; // If you use GetX for navigation
import '../../controllers/profile_controller.dart';
import '../../controllers/services_controller.dart';
import 'package:get/get.dart';
class ExtraServicesView extends StatelessWidget {
  const ExtraServicesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ServicesController servicesController = Get.find<ServicesController>();
    final ProfileController profileController=Get.find<ProfileController>();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(

            child:Container(
              height: double.infinity,
              width: double.infinity, 
            child: Image.asset(
              'assets/images/wave BG@2x.png',
              fit: BoxFit.cover,
            ),
          )
          ),
          SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Avatar, Hello, Logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                                child: Obx((){
                                  final isLoggedIn = profileController.isLoggedIn;
                                  final gender = profileController.gender.value;
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      isLoggedIn && gender=='Female'?
                                      "assets/images/female.jpeg"
                                          :
                                      'assets/images/male.jpeg'
                                      ,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                })
                            ),
                            const SizedBox(width: 12),
                             Text(
                              'Hello'.tr,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Container(

                          child: Image.asset(
                            'assets/images/horizontal color.png', // Your logo asset
                            height: 70,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                     Text(
                      'Extra Services'.tr,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Animal Care Card
                    Obx(() {
                      final animalCare = servicesController.extraServices.firstWhereOrNull(
                        (service) => service.name == 'Animal Care',
                      );
                      return GestureDetector(
                        onTap: animalCare == null
                            ? null
                            : () {
                                Navigator.pushNamed(context, '/booking', arguments: animalCare);
                              },
                        child: Container(
                          width: double.infinity,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 110,
                                height: 110,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF8FFEA),
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(32),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Image.asset(
                                    'assets/images/animal care@2x.png', // Your animal care icon
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 110,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFD6F24A),
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(32),
                                    ),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child:  Text(
                                    'Animal Care'.tr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            
          ),
        ],
      ),
    );
  }
}
