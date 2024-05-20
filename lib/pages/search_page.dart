import 'package:aiia_drive/config/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class search_page extends StatefulWidget {
  search_page({super.key});

  @override
  State<search_page> createState() => _search_pageState();
}

class _search_pageState extends State<search_page> {
  final searchcontroller = TextEditingController();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.circle),
        title: Text(
          "AIIA 드라이브",
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
                  controller: searchcontroller,
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
          Expanded(child: Placeholder(
            child: Placeholder(),
          )),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          iconSize: 32,
          backgroundColor: Color.fromRGBO(255, 235, 168, 1),
          selectedItemColor: Palette.primaryColor,
          unselectedItemColor: Color.fromRGBO(124, 124, 124, 1),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.folder), label: "내 폴더"),
            BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner), label: "마이 페이지"),
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

class Builder extends StatefulWidget {
  const Builder({super.key});

  @override
  State<Builder> createState() => _BuilderState();
}

class _BuilderState extends State<Builder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('drive').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (context, index) => Container()
                    );
        }
    );
  }
}
