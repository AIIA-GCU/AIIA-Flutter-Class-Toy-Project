import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class DB {
  late final FirebaseFirestore _firestore;

  static const String collectionName = 'drive';

  DB() {
    _firestore = FirebaseFirestore.instance;
  }

  Future<int> addData(XFile file) async {
    try {
      Map<String, dynamic> rawData = {};
      rawData['name'] = file.name;
      rawData['path'] = file.path;
      rawData['type'] = file.path.split('.').last;
      rawData['size'] = File(file.path).lengthSync();

      await _firestore.collection(collectionName).add(rawData);
      return 200;
    } catch (e) {
      print(e);
      return 400;
    }
  }

  Future<List<Map<String, dynamic>>> getData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore.collection(collectionName).get();
      List<Map<String, dynamic>> data = [];
      querySnapshot.docs.forEach((element) {
        data.add(element.data());
      });
      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<int> deleteData(String path) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore.collection(collectionName).where('path', isEqualTo: path).get();
      querySnapshot.docs.forEach((element) {
        element.reference.delete();
      });
      return 200;
    } catch (e) {
      print(e);
      return 400;
    }
  }
}