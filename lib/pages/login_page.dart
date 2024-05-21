import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../config/color.dart';
import '../config/font.dart';
import '../firebase/auth.dart';

import 'main/frame.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  static const double maxFormHeight = 250;
  static const double minFormHeight = 180;

  final FirebaseAuthProvider authProvider = FirebaseAuthProvider();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  bool isToastShown = false;
  bool hasError = false;
  String errorMsg = "";

  late TabController _tabController;
  double _sizeChange = minFormHeight;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      if (_tabController.index == 0) {
        _sizeChange = minFormHeight;
      } else {
        _sizeChange = maxFormHeight;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double titleTop, formTop, buttonTop;
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      titleTop = 50;
      formTop = _sizeChange > 200 ? 150 : 200;
      buttonTop = formTop + _sizeChange + 80;
    } else {
      titleTop = 100;
      formTop = 350;
      buttonTop = formTop + _sizeChange + 80;
    }

    bool buttonStatus = isButtonActive();

    return GestureDetector(
      onTap: () {
        if (MediaQuery.of(context).viewInsets.bottom > 0) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            fit: StackFit.expand,
            children: [
              // 배경
              Positioned(
                left: -240,
                top: -350,
                child: Container(
                  width: 680,
                  height: 680,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(340),
                      gradient: const RadialGradient(
                          colors: [
                            Palette.primaryColor,
                            Palette.secondaryDarkColor
                          ]
                      )
                  ),
                ),
              ),

              // 타이틀
              AnimatedPositioned(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 150),
                left: 28,
                top: titleTop,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello world!', style: Fonts.largeTitle),
                    Text('AIIA 드라이브', style: Fonts.title),
                  ],
                ),
              ),

              // 입력폼
              AnimatedPositioned(
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 150),
                  top: formTop,
                  left: 15,
                  right: 15,
                  child: DefaultTabController(
                    length: 2,
                    child: Card(
                      elevation: 5,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TabBar(
                              controller: _tabController,
                              isScrollable: false,
                              indicatorColor: Palette.primaryColor,
                              labelColor: Palette.primaryColor,
                              splashFactory: NoSplash.splashFactory,
                              tabs: [
                                Tab(child: Text('Log in', style: Fonts.parag1)),
                                Tab(child: Text('Join in', style: Fonts.parag1)),
                              ],
                              onTap: (_) {
                                _emailController.clear();
                                _passwordController.clear();
                                _passwordConfirmController.clear();
                                setState(() {
                                  hasError = false;
                                  errorMsg = "";
                                });
                              },
                            ),
                            AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                height: _sizeChange,
                                child: TabBarView(
                                  controller: _tabController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: <Widget>[
                                    inputForm(isLogin: true),
                                    inputForm(isLogin: false),
                                  ],
                                )
                            )
                          ]
                      ),
                    ),
                  )
              ),

              // 버튼
              AnimatedPositioned(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 150),
                top: buttonTop,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: InkWell(
                    onTap: buttonStatus ? () {
                      if (_tabController.index == 0) {
                        _login(_emailController.text, _passwordController.text);
                      } else {
                        _register(_emailController.text, _passwordController.text, _passwordConfirmController.text);
                      }
                    } : null,
                    borderRadius: BorderRadius.circular(50),
                    child: Ink(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 36),
                      decoration: BoxDecoration(
                        color: buttonStatus ? Palette.primaryColor : Palette.base4,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text('Enter', style: Fonts.parag1_w),
                    ),
                  ),
                ),
              )
            ],
          )
      ),
    );
  }

  Future<void> _login(String email, String password) async {
    final entry = OverlayEntry(builder: (context) => progress());
    Overlay.of(context).insert(entry);

    AuthStatus status = await authProvider.loginWithEmail(email, password);
    if (status == AuthStatus.loginSuccess) {
      print('로그인 성공');
      entry.remove();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainFrame()));
    } else {
      print('로그인 실패');
      entry.remove();
    }

  }

  Future<void> _register(String email, String password, String passwordConfirm) async {
    if (password != passwordConfirm) {
      print('비밀번호가 일치하지 않습니다.');
      setState(() {
        hasError = true;
        errorMsg = '비밀번호가 일치하지 않습니다.';
      });
      return;
    }

    final entry = OverlayEntry(builder: (context) => progress());
    Overlay.of(context).insert(entry);

    final status = await authProvider.registerWithEmail(email, password);
    if (status == AuthStatus.registerSuccess) {
      print('회원가입 성공');
      toastMsg("회원가입 성공");
      _tabController.animateTo(0);
    } else {
      print('회원가입 실패');
      showDialog(
          context: context,
          barrierColor: Palette.base1.withOpacity(0.25),
          builder: (context) => AlertDialog(
            title: Text('회원가입 실패', style: Fonts.parag1),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('확인', style: Fonts.parag1),
              )
            ],
          )
      );
    }
    entry.remove();
  }

  bool isButtonActive() {
    if (_tabController.index == 0) {
      return _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    } else {
      return _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty
          && _passwordConfirmController.text.isNotEmpty;
    }
  }

  void toastMsg(String msg) {
    isToastShown = true;
    Future.delayed(const Duration(seconds: 2))
        .then((_) => isToastShown = false);

    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Palette.base1.withOpacity(0.6),
    );
  }

  Widget progress() => Container(
    width: double.infinity,
    height: double.infinity,
    alignment: Alignment.center,
    color: Palette.base1.withOpacity(0.25),
    child: const CircularProgressIndicator(),
  );

  Widget inputForm({required bool isLogin}) {
    List<Widget> children = [
      textField(_emailController, 'E-mail'), // textField(TextEditingController controller
      const SizedBox(height: 10),
      textField(_passwordController, 'PW (최소 6자리 이상)', isObscure: true), // textField(TextEditingController controller
      const SizedBox(height: 10),
    ];

    if (isLogin == false) {
      children.addAll([
        textField(_passwordConfirmController, 'PW 확인', isObscure: true), // textField(TextEditingController controller
        const SizedBox(height: 10)
      ]);
    }

    children.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Text(errorMsg, style: Fonts.label.copyWith(color: Palette.error)),
            const Spacer(),
            GestureDetector(
              onTap: () { if (!isToastShown) toastMsg("아직 준비되지 않은 기능입니다"); },
              child: Text("비밀번호 찾기", style: Fonts.label),
            )
          ]
        ),
      )
    );

    return OverflowBox(
      minHeight: minFormHeight,
      maxHeight: maxFormHeight,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children
          ),
        ),
      ),
    );
  }

  Widget textField(
      TextEditingController controller,
      String hint,
      {bool isObscure = false}
  ) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        hintText: hint,
        hintStyle: const TextStyle(color: Palette.base3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Palette.base1),
        ),
      ),
    );
  }
}