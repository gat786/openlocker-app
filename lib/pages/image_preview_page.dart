import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreview extends StatelessWidget {
  final String imageUrl;
  const ImagePreview({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;

    if (arguments != null) print(arguments['imageUrl']);
    return Container(
      child: PhotoView(
        imageProvider: NetworkImage(imageUrl),
      ),
    );
  }
}
