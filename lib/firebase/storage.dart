import 'dart:io';
import 'dart:typed_data';

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

  Future<void> deleteData(String path) async {
    try {
      await _firestore.child(path).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<String> getUrl(String path) async {
    try {
      return await _firestore.child(path).getDownloadURL();
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<Uint8List?> getFile(String name) async {
    try {
      return await _firestore.child(name).getData();
    } catch (e) {
      print(e);
      return null;
    }
  }
}