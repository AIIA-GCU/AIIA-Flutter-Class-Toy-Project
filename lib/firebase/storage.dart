import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Storage {
  late final Reference _firestore;

  Storage() {
    _firestore = FirebaseStorage.instance.ref();
  }

  Future<int> addData(XFile file) async {
    try {
      await _firestore.child(file.name).putFile(File(file.path));
      return 200;
    } catch (e) {
      print(e);
      return 400;
    }
  }
}