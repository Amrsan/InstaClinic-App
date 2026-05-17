// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// //import 'package:image_picker_web/image_picker_web.dart';
// import '../services/image_service.dart';
// import '../services/database_service.dart';

// class ImagePickerWidget extends StatefulWidget {
//   final String bucketName;
//   final String folderPath;
//   final String? currentImageUrl;
//   final Function(String) onImageSelected;
//   final String? entityId;
//   final String entityType; // 'service', 'provider', or 'user'

//   const ImagePickerWidget({
//     Key? key,
//     required this.bucketName,
//     required this.folderPath,
//     this.currentImageUrl,
//     required this.onImageSelected,
//     this.entityId,
//     required this.entityType,
//   }) : super(key: key);

//   @override
//   State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
// }

// class _ImagePickerWidgetState extends State<ImagePickerWidget> {
//   bool _isLoading = false;
//   String? _selectedImageName;

//   Future<void> _handleImageUpload() async {
//     if (_isLoading) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final ImageService imageService = Get.find<ImageService>();
//       final DatabaseService databaseService = Get.find<DatabaseService>();

//       // Use ImagePickerWeb for web platform
//       final MediaInfo? mediaInfo = await ImagePickerWeb.getImageInfo;
//       if (mediaInfo == null) {
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//       }

//       _selectedImageName = mediaInfo.fileName;
//       setState(() {});

//       final String? imageUrl = await imageService.pickAndUploadImage(
//         bucketName: widget.bucketName,
//         folderPath: widget.folderPath,
//       );

//       if (imageUrl != null) {
//         widget.onImageSelected(imageUrl);

//         if (widget.entityId != null) {
//           switch (widget.entityType) {
//             case 'service':
//               await databaseService.updateServiceImage(
//                 serviceId: widget.entityId!,
//                 imageUrl: imageUrl,
//               );
//               break;
//             case 'provider':
//               await databaseService.updateProviderImage(
//                 providerId: widget.entityId!,
//                 imageUrl: imageUrl,
//               );
//               break;
//             case 'user':
//               await databaseService.updateUserAvatar(
//                 userId: widget.entityId!,
//                 imageUrl: imageUrl,
//               );
//               break;
//           }
//         }

//         if (mounted) {
//           Get.snackbar(
//             'Success',
//             'Image uploaded successfully',
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.green,
//             colorText: Colors.white,
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         Get.snackbar(
//           'Error',
//           'Failed to upload image: ${e.toString()}',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
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
//               width: 100,
//               height: 100,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) => Container(
//                 width: 100,
//                 height: 100,
//                 color: Colors.grey[200],
//                 child: const Icon(Icons.error_outline),
//               ),
//             ),
//           ),
//         const SizedBox(height: 16),
//         MouseRegion(
//           cursor: _isLoading ? SystemMouseCursors.wait : SystemMouseCursors.click,
//           child: ElevatedButton.icon(
//             onPressed: _isLoading ? null : _handleImageUpload,
//             icon: _isLoading
//                 ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   )
//                 : const Icon(Icons.upload),
//             label: Text(_isLoading ? 'Uploading...' : 'Upload Image'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             ),
//           ),
//         ),
//         if (_selectedImageName != null)
//           Padding(
//             padding: const EdgeInsets.only(top: 8),
//             child: Text(
//               'Selected: $_selectedImageName',
//               style: const TextStyle(color: Colors.green),
//             ),
//           ),
//       ],
//     );
//   }
// } 