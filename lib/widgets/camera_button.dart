// lib/widgets/camera_button.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraButton extends StatelessWidget {
  final Function(XFile) onImageSelected;

  CameraButton({required this.onImageSelected});

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      onImageSelected(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _pickImage,
      child: Text('Capture Photo'),
    );
  }
}
