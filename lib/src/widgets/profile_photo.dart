import 'dart:io';

import 'package:alamo/src/utils/pick_image.dart';
import 'package:flutter/material.dart';

class ProfilePhoto extends StatefulWidget {
  final String userProfileUrl;
  final Function(File) onImageUploaded;

  const ProfilePhoto({
    required this.userProfileUrl,
    required this.onImageUploaded,
    super.key,
  });

  @override
  createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  String? _localImagePath;

  // Function to select and display image immediately, then upload
  Future<void> selectAndUploadImage() async {
    final imageFile = await pickImage();

    if (imageFile != null) {
      setState(() {
        _localImagePath = imageFile.path;
      });

      try {
        await widget.onImageUploaded(imageFile);
      } catch (e) {
        setState(() {
          _localImagePath = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 45,
          backgroundImage: _localImagePath != null ? FileImage(File(_localImagePath!)) as ImageProvider : NetworkImage(widget.userProfileUrl),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: selectAndUploadImage,
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.photo_camera_sharp,
                  size: 18,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
