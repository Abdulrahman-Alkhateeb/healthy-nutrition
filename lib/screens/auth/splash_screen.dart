import 'package:flutter/material.dart';
import 'package:healthy_nutrition/providers/info.dart';
import 'package:healthy_nutrition/screens/auth/auth_screen.dart';
import 'package:healthy_nutrition/screens/diets/home_screen.dart';
import 'package:healthy_nutrition/screens/user/get_user_info.dart';
import 'package:healthy_nutrition/utils/color_palette.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _navigate() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String token = _prefs.getString('token');
    if (token != null) {
      String _username = _prefs.getString('username');
      String _password = _prefs.getString('password');
      await Provider.of<Info>(context, listen: false).login(
        username: _username,
        password: _password,
      );
      bool _goToHome = _prefs.getBool('goToHome') ?? false;
      if (_goToHome)
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        });
      else
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context)
              .pushReplacementNamed(GetUserInfoScreen.routeName);
        });
    } else
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
      });
  }

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.PRIMARY_COLOR,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(20),
          height: 200,
          width: 200,
          child: Image(
            height: 150,
            width: 150,
            image: AssetImage('assets/images/apple.png'),
          ),
        ),
      ),
    );
  }
}
