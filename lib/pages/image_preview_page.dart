import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;

class ImagePreview extends StatefulWidget {
  final String imageUrl;

  const ImagePreview({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  Uint8List? byteData;

  getImage() async {
    var response = await http.get(Uri.parse(widget.imageUrl));
    if(response.statusCode == 200) {
      setState(() {
        byteData = response.bodyBytes;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: (byteData != null) ? PhotoView(
        imageProvider: MemoryImage(byteData!),
      ): Container()
    );
  }
}
