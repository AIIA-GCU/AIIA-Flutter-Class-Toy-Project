import 'package:flutter/material.dart';
import '../config/font.dart';
import '../config/assets.dart';
import '../models/model_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _emailLoginController = TextEditingController();
  final _passwordLoginController = TextEditingController();
  final _emailRegisterController = TextEditingController();
  final _passwordRegisterController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  late TabController _tabController;
  double _sizeChange = 229;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      if (_tabController.index == 0) {
        _sizeChange = 180;
      } else {
        _sizeChange = 260;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    String email = _emailLoginController.text;
    String password = _passwordLoginController.text;

    FirebaseAuthProvider authProvider = FirebaseAuthProvider();
    AuthStatus status = await authProvider.loginWithEmail(email, password);

    if (status == AuthStatus.loginSuccess) {
      print('로그인 성공');
    } else {
      print('로그인 실패');
    }
  }

  Future<void> _register() async {
    String email = _emailRegisterController.text;
    String password = _passwordRegisterController.text;
    String passwordConfirm = _passwordConfirmController.text;

    if (password != passwordConfirm) {
      print('비밀번호가 일치하지 않습니다.');
      return;
    }

    FirebaseAuthProvider authProvider = FirebaseAuthProvider();
    AuthStatus status = await authProvider.registerWithEmail(email, password);

    if (status == AuthStatus.registerSuccess) {
      print('회원가입 성공');
    } else {
      print('회원가입 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 356,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImagePath.ellipse),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(27.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello world!',
                          style: Fonts.largeTitle,
                        ),
                        Text(
                          'AIIA 드라이브',
                          style: Fonts.title,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    color: Colors.white,
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: <Widget>[
                          Container(
                            constraints: BoxConstraints(maxHeight: 150.0),
                            child: Material(
                              color: Colors.white,
                              child: TabBar(
                                controller: _tabController,
                                tabs: [
                                  Tab(
                                    child: Text(
                                      'Log in',
                                      style: Fonts.parag1,
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      'Join in',
                                      style: Fonts.parag1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: _sizeChange,
                            child: TabBarView(
                              controller: _tabController,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        TextFormField(
                                          controller: _emailLoginController,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                            hintText: 'E-mail',
                                            hintStyle: TextStyle(color: Color(0xFF8B8B8B)),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide(color: Colors.black, width: 1),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        TextFormField(
                                          controller: _passwordLoginController,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                            hintText: 'PW',
                                            hintStyle: TextStyle(color: Color(0xFF8B8B8B)),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide(color: Colors.black, width: 1),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        TextFormField(
                                          controller: _emailRegisterController,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                            hintText: 'E-mail',
                                            hintStyle: TextStyle(color: Color(0xFF8B8B8B)),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide(color: Colors.black, width: 1),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        TextFormField(
                                          controller: _passwordRegisterController,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                            hintText: 'PW',
                                            hintStyle: TextStyle(color: Color(0xFF8B8B8B)),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide(color: Colors.black, width: 1),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        TextFormField(
                                          controller: _passwordConfirmController,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                            hintText: 'PW 확인',
                                            hintStyle: TextStyle(color: Color(0xFF8B8B8B)),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide(color: Colors.black, width: 1),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    width: 120,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFA4A4A4),
                      ),
                      onPressed: () {
                        if (_tabController.index == 0) {
                          _login();
                        } else {
                          _register();
                        }
                      },
                      child: Text('Enter', style: Fonts.parag1_w),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
