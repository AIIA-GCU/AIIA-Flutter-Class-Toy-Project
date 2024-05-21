import 'package:aiia_drive/config/color.dart';
import 'package:aiia_drive/config/font.dart';
import 'package:aiia_drive/firebase/auth.dart';
import 'package:flutter/material.dart';

import '../login_page.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Icon(Icons.person,
            size: 200,
            color: Palette.primaryColor
        ),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            children: [
              Text("이메일", style: Fonts.parag2),
              const SizedBox(width: 24),
              Text(user!.email!, style: Fonts.parag2)
            ],
          )
        ),

        const Divider(
          color: Palette.base3,
          thickness: 1,
          height: 40,
          indent: 30,
          endIndent: 30,
        ),

        InkWell(
          onTap: () async {
            OverlayEntry? entry = OverlayEntry(builder: (context) => progressCircle());
            Overlay.of(context).insert(entry);

            await FirebaseAuthProvider().logout();

            entry.remove();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage())
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 40),
            child: Row(
              children: [
                Text("로그아웃", style: Fonts.parag2),
                const Spacer(),
                const Icon(Icons.door_front_door, size: 16)
              ],
            )
          )
        )
      ],
    );
  }

  Widget progressCircle() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(0.25),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}
