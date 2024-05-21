import 'package:flutter/material.dart';

import '../dto/file_info.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key, required this.fileInfo});

  final FileInfo fileInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(fileInfo.name),
          centerTitle: false
      ),
      body: Center(
        child: Image.memory(
          fileInfo.data!,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
