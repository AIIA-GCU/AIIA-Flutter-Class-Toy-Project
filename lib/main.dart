import 'package:aiia_drive/firebase/firebase_options.dart';
import 'package:aiia_drive/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(home: LoginPage()));
}
