import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Custom image widget that loads an image as a static asset or uses
/// [CachedNetworkImage] depending on the image url.
class CustomImage extends StatelessWidget {
  const CustomImage({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    // * For this widget to work correctly on web, we need to handle CORS:
    // * https://flutter.dev/docs/development/platform-integration/web-images
    return AspectRatio(
      aspectRatio: 1,
      child: imageUrl.startsWith('http') ? CachedNetworkImage(imageUrl: imageUrl) : Image.asset(imageUrl),
    );
  }
}

// Method for background decorative images
Widget buildDecorativeImages() {
  return Stack(
    children: [
      Positioned(
        top: 0,
        right: 0,
        child: Image.asset(
          'assets/images/top_leaf.png',
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        child: Image.asset(
          'assets/images/bottom_leaf.png',
        ),
      ),
    ],
  );
}
