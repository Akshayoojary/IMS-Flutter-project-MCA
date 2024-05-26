import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerWidget extends StatelessWidget {
  final Function(File) onImagePicked;

  const ImagePickerWidget({Key? key, required this.onImagePicked}) : super(key: key);

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      onImagePicked(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => _pickImage(ImageSource.camera),
          child: Text('Camera'),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _pickImage(ImageSource.gallery),
          child: Text('Gallery'),
        ),
      ],
    );
  }
}
