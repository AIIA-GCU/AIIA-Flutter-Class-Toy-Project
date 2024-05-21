import 'package:aiia_drive/pages/main/my_page.dart';
import 'package:aiia_drive/pages/main/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../config/assets.dart';
import '../../config/color.dart';
import '../../config/font.dart';
import '../../widgets/bottom_sheet.dart';

class MainFrame extends StatefulWidget {
  const MainFrame({super.key});

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  final pageController = PageController();

  int currentPageIndex = 0;

  bool needToLoad = true;

  @override
  void dispose() {
    FirebaseAuth.instance.signOut();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool temp = false;
    if (needToLoad) {
      temp = needToLoad;
      needToLoad = false;
    }

    return GestureDetector(
      onTap: () {
        if (MediaQuery.of(context).viewInsets.bottom > 0) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Image.asset(LogoPath.logoLight),
          ),
          title: Text(
              "AIIA 드라이브",
              style: Fonts.subtitle.copyWith(color: Palette.base5)
          ),
          titleSpacing: 4,
          centerTitle: false,
          forceMaterialTransparency: true,
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (index) => setState(() {
              currentPageIndex = index;
            }),
          children: [
            SearchPage(refresh: temp),
            const MyPage()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentPageIndex,
            onTap: (index) => setState(() {
              pageController.animateToPage(
                currentPageIndex = index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease
              );
            }),
            iconSize: 32,
            backgroundColor: Palette.secondaryLightColor,
            selectedItemColor: Palette.primaryColor,
            unselectedItemColor: Palette.base3,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.folder), label: "내 폴더"),
              BottomNavigationBarItem(icon: Icon(Icons.keyboard_command_key), label: "마이 페이지"),
            ]
        ),
        floatingActionButton: currentPageIndex == 1 ? null : FloatingActionButton(
          onPressed: () => showModalBottomSheet(
            context: context,
            builder: (context) => UploadBottomSheet(
              onUpload: (val) => setState(() => needToLoad = val),
            )
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
