import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart' as fi;
import 'package:healthy_nutrition/providers/info.dart';
import 'package:healthy_nutrition/screens/diets/home_screen.dart';
import 'package:healthy_nutrition/screens/user/get_user_info.dart';
import 'package:healthy_nutrition/utils/color_palette.dart';
import 'package:healthy_nutrition/utils/enums.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = 'auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.Login;
  double _containerHeight;
  TextEditingController _password = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();
  double _height;
  bool _firstTime = true;
  Map<String, dynamic> _userInfo = {};
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int _submitCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;
      _containerHeight = 415;
      _firstTime = false;
    }
  }

  void _changeAuthMode() {
    setState(() {
      _submitCount = 0;
      if (_authMode == AuthMode.Login) {
        _authMode = AuthMode.SignUp;
        _containerHeight = 550;
      } else {
        _authMode = AuthMode.Login;
        _containerHeight = 415;
      }
    });
  }

  void _showSnackBar({
    @required String message,
    @required Color backgroundColor,
    @required Color textColor,
  }) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: backgroundColor,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: 17,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    _submitCount++;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      bool _isSignedUp = false, _isLoggedIn = false;
      if (_authMode == AuthMode.SignUp) {
        _isSignedUp = await Provider.of<Info>(
          context,
          listen: false,
        ).signUp(
          username: _userInfo['username'],
          password: _userInfo['password'],
          fullName: _userInfo['fullName'],
        );
        if (_isSignedUp) {
          _changeAuthMode();
          _showSnackBar(
            message: 'Your Account Was Created Successfully.',
            backgroundColor: Colors.blue,
            textColor: Colors.white,
          );
        } else {
          _showSnackBar(
            message: 'Something Went Wrong, Try Again Later.',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }
      if (_authMode == AuthMode.Login) {
        _isLoggedIn = await Provider.of<Info>(
          context,
          listen: false,
        ).login(
          username: _userInfo['username'],
          password: _userInfo['password'],
        );
        if (_isLoggedIn) {
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          bool _goToHome = _prefs.getBool('goToHome') ?? false;
          if (_goToHome)
            Navigator.of(context).pushNamedAndRemoveUntil(
              HomeScreen.routeName,
              (route) => false,
            );
          else
            Navigator.of(context).pushNamedAndRemoveUntil(
              GetUserInfoScreen.routeName,
              (route) => false,
            );
        } else {
          _showSnackBar(
            message: 'Something Went Wrong, Try Again Later.',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }
    } else {
      if (_submitCount == 1)
        setState(() {
          switch (_authMode) {
            case AuthMode.Login:
              _containerHeight += 50;
              break;
            case AuthMode.SignUp:
              _containerHeight += 90;
              break;
          }

          _submitCount = 1;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorPalette.PRIMARY_COLOR,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: _height / 10.846753246753247142857142857143,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(20),
                    height: _height / 5.061818181818182,
                    width: _height / 5.061818181818182,
                    child: Image(
                      height: _height / 5.061818181818182,
                      width: _height / 5.061818181818182,
                      image: AssetImage('assets/images/apple.png'),
                    ),
                  ),
                  SizedBox(
                    height: _height / 15.185454545454546,
                  ),
                  Card(
                    child: Container(
                      width: double.infinity,
                      height: _containerHeight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            SizedBox(
                              height: _height / 15.185454545454546,
                            ),
                            if (_authMode == AuthMode.SignUp)
                              Column(
                                children: [
                                  TextFormField(
                                    decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        fi.FlutterIcons.id_badge_faw5,
                                        color: ColorPalette.PRIMARY_COLOR,
                                      ),
                                      border: OutlineInputBorder(),
                                      labelText: 'Full Name',
                                    ),
                                    onSaved: (fullName) =>
                                        _userInfo['fullName'] = fullName,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return 'Please Enter Your Name';
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            TextFormField(
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  fi.FlutterIcons.user_ant,
                                  color: ColorPalette.PRIMARY_COLOR,
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'Username',
                              ),
                              onSaved: (username) =>
                                  _userInfo['username'] = username,
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Please Enter Your Username';
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  fi.FlutterIcons.lock_ant,
                                  color: ColorPalette.PRIMARY_COLOR,
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                              ),
                              onSaved: (password) =>
                                  _userInfo['password'] = password,
                              controller: _password,
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Please Enter Your Password';
                                return null;
                              },
                            ),
                            if (_authMode == AuthMode.SignUp)
                              Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        fi.FlutterIcons.lock_ant,
                                        color: ColorPalette.PRIMARY_COLOR,
                                      ),
                                      border: OutlineInputBorder(),
                                      labelText: 'Confirm Password',
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return 'Please Confirm Your Password';
                                      if (_password.text != value)
                                        return 'Passwords Don\'t Match';

                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            SizedBox(
                              height: _height / 15.185454545454546,
                            ),
                            Container(
                              height: _height / 15.185454545454546,
                              width: double.infinity,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(500),
                                ),
                                color: ColorPalette.PRIMARY_COLOR,
                                onPressed: _submit,
                                child: Text(
                                  _authMode == AuthMode.Login
                                      ? 'Login'
                                      : 'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: _height / 15.185454545454546,
                              width: double.infinity,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(500),
                                  side: BorderSide(
                                    color: ColorPalette.PRIMARY_COLOR,
                                    width: 2,
                                  ),
                                ),
                                onPressed: _changeAuthMode,
                                child: Text(
                                  _authMode == AuthMode.Login
                                      ? 'Sign Up'
                                      : 'Login',
                                  style: TextStyle(
                                    color: ColorPalette.PRIMARY_COLOR,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
