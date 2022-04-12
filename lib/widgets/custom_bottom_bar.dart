import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:healthy_nutrition/screens/custom_meals/generate_meal_screen.dart';
import 'package:healthy_nutrition/screens/diets/home_screen.dart';
import 'package:healthy_nutrition/screens/user/my_favourite_meals_screen.dart';
import 'package:healthy_nutrition/screens/user/profile_screen.dart';

class CustomBottomBar extends StatefulWidget {
  final int index;

  CustomBottomBar({
    @required this.index,
  });

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
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
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.black45,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: BottomNavigationBar(
        showUnselectedLabels: true,
        elevation: 5,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: widget.index,
        onTap: (value) {
          if (value == 0)
            _navigate(
              routeName: HomeScreen.routeName,
              replace: true,
            );
          if (value == 1)
            _navigate(
              routeName: GenerateMealScreen.routeName,
              replace: true,
            );

          if (value == 2)
            _navigate(
              routeName: MyFavouritesScreen.routeName,
              replace: true,
            );

          if (value == 3)
            _navigate(
              routeName: ProfileScreen.routeName,
              replace: true,
            );
        },
        items: [
          BottomNavigationBarItem(
            label: 'Diets',
            icon: Icon(
              FlutterIcons.food_apple_mco,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Custom Meal',
            icon: Icon(
              FlutterIcons.food_variant_mco,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Favourites',
            icon: Icon(
              FlutterIcons.favorite_mdi,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(
              FlutterIcons.profile_ant,
            ),
          ),
        ],
      ),
    );
  }
}
