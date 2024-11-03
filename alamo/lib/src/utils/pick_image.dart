import 'package:image_picker/image_picker.dart';
import 'dart:io';

Future<File?> pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Or use ImageSource.camera for camera
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}
