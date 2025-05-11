import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploader {
  static Future<String?> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    // Show a dialog to choose between gallery or camera
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
      // Pick image based on the source
      final XFile? image = (source == 'camera')
          ? await picker.pickImage(source: ImageSource.camera)
          : await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        return image.path;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected.')),
        );
        return null;
      }
    } else {
      return null;
    }
  }
}
