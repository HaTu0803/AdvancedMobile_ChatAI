import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data_app/model/jarvis/upload_image_model.dart';
import '../../../data_app/repository/jarvis/upload_image_repository.dart';

class ImageUploader {
  static Future<void> pickAndUploadImage(
      BuildContext context, Function(File) onImageUploaded, Function(String) onImageUrlReceived) async {
    final ImagePicker picker = ImagePicker();

    final String? source = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'gallery');
              },
              child: const Text('Gallery'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'camera');
              },
              child: const Text('Camera'),
            ),
          ],
        );
      },
    );

    if (source != null) {
      final XFile? image = (source == 'camera')
          ? await picker.pickImage(source: ImageSource.camera)
          : await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final File imageFile = File(image.path);
        final String mimeType = _getMimeType(image.path);

        print("Image selected: ${imageFile.path.split('/').last}");

        final uploadRequest = UploadImage(
          filename: imageFile.path.split('/').last,
          mimetype: mimeType,
        );

        try {
          final response = await UploadImageRepository().uploadImage(uploadRequest);

          if (response != null && response.url != null) {
            await UploadImageRepository().uploadImageSuccess(uploadRequest);

            onImageUrlReceived(response.url);

            onImageUploaded(imageFile);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image uploaded successfully!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Upload failed!')),
            );
          }
        } catch (e) {
          print("Upload error: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('An error occurred during upload.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No source selected.')),
      );
    }
  }

  static String _getMimeType(String path) {
    final extension = path.split('.').last.toLowerCase();

    switch (extension) {
      case 'apng':
        return 'image/apng';
      case 'avif':
        return 'image/avif';
      case 'gif':
        return 'image/gif';
      case 'jpeg':
      case 'jpg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'svg':
        return 'image/svg+xml';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }
}
