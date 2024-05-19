import 'package:flutter/material.dart';
import '../config/font.dart';
import '../config/assets.dart';

class ImagePath {
  static const String ellipse = 'assets/images/Ellipse1.png';
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 338.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImagePath.ellipse),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(27.0),
              child: Text(
                'Hello world',
                style: Fonts.largeTitle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
