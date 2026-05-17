// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker_web/image_picker_web.dart';
// import 'dart:convert';

// class WebImagePicker extends StatefulWidget {
//   final Function(String) onImageSelected;
//   final String? currentImageUrl;
//   final String? selectedImageName;
//   final bool isLoading;

//   const WebImagePicker({
//     Key? key,
//     required this.onImageSelected,
//     this.currentImageUrl,
//     this.selectedImageName,
//     this.isLoading = false,
//   }) : super(key: key);

//   @override
//   State<WebImagePicker> createState() => _WebImagePickerState();
// }

// class _WebImagePickerState extends State<WebImagePicker> {
//   bool _isPicking = false;

//   Future<void> _pickImage() async {
//     if (_isPicking) return;
    
//     setState(() {
//       _isPicking = true;
//     });

//     try {
//       final MediaInfo? mediaInfo = await ImagePickerWeb.getImageInfo;
//       if (mediaInfo == null) {
//         setState(() {
//           _isPicking = false;
//         });
//         return;
//       }

//       // Validate file type
//       final String? fileExtension = mediaInfo.fileName?.split('.').last.toLowerCase();
//       if (fileExtension == null || !['png', 'jpg', 'jpeg', 'svg'].contains(fileExtension)) {
//         Get.snackbar(
//           'Error',
//           'Please select a valid image file (PNG, JPG, JPEG, or SVG)',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         setState(() {
//           _isPicking = false;
//         });
//         return;
//       }

//       // Check file size (5MB limit)
//       if (mediaInfo.data != null && mediaInfo.data!.length > 5 * 1024 * 1024) {
//         Get.snackbar(
//           'Error',
//           'Image size must be less than 5MB',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         setState(() {
//           _isPicking = false;
//         });
//         return;
//       }

//       // Convert image to base64
//       if (mediaInfo.base64 != null) {
//         widget.onImageSelected(mediaInfo.base64!);
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to pick image: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       setState(() {
//         _isPicking = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (widget.currentImageUrl != null)
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.network(
//               widget.currentImageUrl!,
//               width: 200,
//               height: 200,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   width: 200,
//                   height: 200,
//                   color: Colors.grey[300],
//                   child: const Icon(Icons.error_outline),
//                 );
//               },
//             ),
//           ),
//         const SizedBox(height: 16),
//         if (widget.selectedImageName != null)
//           Text(
//             widget.selectedImageName!,
//             style: const TextStyle(fontSize: 14),
//           ),
//         const SizedBox(height: 16),
//         ElevatedButton(
//           onPressed: (widget.isLoading || _isPicking) ? null : _pickImage,
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           ),
//           child: (widget.isLoading || _isPicking)
//               ? const SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 )
//               : const Text('Select Image'),
//         ),
//       ],
//     );
//   }
// } 