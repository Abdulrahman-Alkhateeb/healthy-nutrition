import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_nutrition/providers/diets.dart';
import 'package:healthy_nutrition/providers/generated_meals.dart';
import 'package:healthy_nutrition/providers/info.dart';
import 'package:healthy_nutrition/providers/meals.dart';
import 'package:healthy_nutrition/screens/auth/auth_screen.dart';
import 'package:healthy_nutrition/screens/auth/splash_screen.dart';
import 'package:healthy_nutrition/screens/custom_meals/custom_meals_screen.dart';
import 'package:healthy_nutrition/screens/custom_meals/generate_meal_screen.dart';
import 'package:healthy_nutrition/screens/diets/diet_details_screen.dart';
import 'package:healthy_nutrition/screens/diets/home_screen.dart';
import 'package:healthy_nutrition/screens/diets/meal_details_screen.dart';
import 'package:healthy_nutrition/screens/user/edit_user_info_screen.dart';
import 'package:healthy_nutrition/screens/user/get_user_info.dart';
import 'package:healthy_nutrition/screens/user/my_favourite_meals_screen.dart';
import 'package:healthy_nutrition/screens/user/profile_screen.dart';
import 'package:healthy_nutrition/utils/color_palette.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Info(),
        ),
        ChangeNotifierProvider(
          create: (context) => Diets(),
        ),
        ChangeNotifierProvider(
          create: (context) => Meals(),
        ),
        ChangeNotifierProvider(
          create: (context) => GeneratedMeals(),
        ),
      ],
      child: MaterialApp(
        title: 'Healthy Nutrition',
        theme: ThemeData(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          primarySwatch: ColorPalette.PRIMARY_COLOR,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Itim',
        ),
        home: SplashScreen(),
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
          AuthScreen.routeName: (ctx) => AuthScreen(),
          GetUserInfoScreen.routeName: (ctx) => GetUserInfoScreen(),
          ProfileScreen.routeName: (ctx) => ProfileScreen(),
          GenerateMealScreen.routeName: (ctx) => GenerateMealScreen(),
          DietDetailsScreen.routeName: (ctx) => DietDetailsScreen(),
          MealDetailsScreen.routeName: (ctx) => MealDetailsScreen(),
          CustomMealsScreen.routeName: (ctx) => CustomMealsScreen(),
          MyFavouritesScreen.routeName: (ctx) => MyFavouritesScreen(),
          EditUserInfoScreen.routeName: (ctx) => EditUserInfoScreen(),
        },
      ),
    );
  }
}
