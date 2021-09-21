import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatelessWidget {
  final String url;

  ImageViewScreen({required this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PhotoView(
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.contained * 10.0,
        heroAttributes: PhotoViewHeroAttributes(
          tag: url,
        ),
        imageProvider: NetworkImage(url),
      ),
    );
  }
}
