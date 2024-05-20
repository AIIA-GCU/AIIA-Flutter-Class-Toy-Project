import 'package:aiia_drive/config/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class search_page extends StatelessWidget {
  const search_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.circle),
        title: Text(
          "AIIA Drive",
          style: TextStyle(
            color: Color(0xFF5A5A5A),
            fontSize: 18,
            fontFamily: 'Noto Sans KR',
            fontWeight: FontWeight.w700,
            height: 0.07,
            letterSpacing: 1.60,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.symmetric(vertical: 12)),
          Row(
            children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
              Container(
                width: 300,
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "이름",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 9, horizontal: 9),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 7)),
              Icon(
                Icons.search,
                size: 36,
              ),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 7.5)),
          Divider(
            indent: 12,
            endIndent: 8,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.looks_one),
          label: "1"
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.looks_two),
          label: "2"
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
          size: 42,
        ),
        backgroundColor: Palette.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.,
    );
  }
}
