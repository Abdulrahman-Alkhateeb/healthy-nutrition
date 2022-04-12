import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:healthy_nutrition/screens/auth/auth_screen.dart';
import 'package:healthy_nutrition/screens/custom_meals/generate_meal_screen.dart';
import 'package:healthy_nutrition/screens/diets/home_screen.dart';
import 'package:healthy_nutrition/screens/user/my_favourite_meals_screen.dart';
import 'package:healthy_nutrition/utils/color_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  void _navigate({
    @required String routeName,
    @required bool replace,
  }) {
    String _currentRoute = ModalRoute.of(context).settings.name;
    if (routeName != _currentRoute) {
      if (replace)
        Navigator.of(context).pushReplacementNamed(routeName);
      else if (!replace) Navigator.of(context).pushNamed(routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 175),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                ListTile(
                  onTap: () {
                    _navigate(
                      routeName: HomeScreen.routeName,
                      replace: true,
                    );
                  },
                  title: Text(
                    'Home',
                    style: TextStyle(
                      color: Colors.blue.shade400,
                      fontSize: 20,
                    ),
                  ),
                  leading: Icon(
                    FlutterIcons.home_faw5s,
                    color: ColorPalette.PRIMARY_COLOR,
                    size: 25,
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 0,
                  endIndent: 20,
                  indent: 20,
                  color: ColorPalette.PRIMARY_COLOR,
                ),
                ListTile(
                  onTap: () {
                    _navigate(
                      routeName: GenerateMealScreen.routeName,
                      replace: true,
                    );
                  },
                  title: Text(
                    'Custom Meal',
                    style: TextStyle(
                      color: Colors.blue.shade400,
                      fontSize: 20,
                    ),
                  ),
                  leading: Icon(
                    FlutterIcons.food_variant_mco,
                    color: ColorPalette.PRIMARY_COLOR,
                    size: 25,
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 0,
                  endIndent: 20,
                  indent: 20,
                  color: ColorPalette.PRIMARY_COLOR,
                ),
                ListTile(
                  onTap: () {
                    _navigate(
                      routeName: MyFavouritesScreen.routeName,
                      replace: true,
                    );
                  },
                  title: Text(
                    'My Favourites',
                    style: TextStyle(
                      color: Colors.blue.shade400,
                      fontSize: 20,
                    ),
                  ),
                  leading: Icon(
                    FlutterIcons.favorite_mdi,
                    color: ColorPalette.PRIMARY_COLOR,
                    size: 25,
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 0,
                  endIndent: 20,
                  indent: 20,
                  color: ColorPalette.PRIMARY_COLOR,
                ),
                ListTile(
                  onTap: () async {
                    SharedPreferences _prefs =
                        await SharedPreferences.getInstance();
                    _prefs.clear();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AuthScreen.routeName,
                      (route) => false,
                    );
                  },
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.blue.shade400,
                      fontSize: 20,
                    ),
                  ),
                  leading: Icon(
                    FlutterIcons.log_out_ent,
                    color: ColorPalette.PRIMARY_COLOR,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.hardEdge,
            child: Container(
              width: double.infinity,
              height: 200,
              color: ColorPalette.PRIMARY_COLOR,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(20),
                      height: 100,
                      width: 100,
                      child: Image(
                        height: 100,
                        width: 100,
                        image: AssetImage('assets/images/apple.png'),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Healthy Nutrition',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
