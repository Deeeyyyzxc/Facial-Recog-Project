import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  final Function(List<int>) onImageSelected;

  ImagePickerWidget({required this.onImageSelected});

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      // Convert image to bytes
      final Uint8List imageBytes = await image.readAsBytes();
      onImageSelected(imageBytes.toList()); // Convert Uint8List to List<int>
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _pickImage(context),
      child: Text('Pick Image'),
    );
  }
}
