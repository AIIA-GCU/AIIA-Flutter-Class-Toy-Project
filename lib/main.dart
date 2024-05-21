import 'package:aiia_drive/config/color.dart';
import 'package:aiia_drive/firebase/firebase_options.dart';
import 'package:aiia_drive/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIIA Drive',
      theme: ThemeData(
        primaryColor: Palette.primaryColor,
        primaryColorDark: Palette.primaryDarkColor,
        primaryColorLight: Palette.primaryLightColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
        scaffoldBackgroundColor: Colors.white,
        dialogBackgroundColor: Colors.white,
        focusColor: Palette.primaryColor,
      ),
      home: const LoginPage(),
    );
  }
}