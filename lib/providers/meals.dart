import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:healthy_nutrition/models/generated_meal.dart';
import 'package:healthy_nutrition/models/meal.dart';
import 'package:healthy_nutrition/models/user.dart';
import 'package:healthy_nutrition/providers/generated_meals.dart';
import 'package:healthy_nutrition/providers/info.dart';
import 'package:healthy_nutrition/utils/server_info.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Meals with ChangeNotifier {
  List<Meal> _meals = [];

  List<GeneratedMeal> _favMeals = [];

  List<GeneratedMeal> favMeals({
    @required BuildContext context,
  }) {
    User _user = Provider.of<Info>(context, listen: false).user;
    _favMeals = _user.favMeals;
    return [..._favMeals];
  }

  List<Meal> meals() {
    return [..._meals];
  }

  Future<bool> getMeals({
    @required int dietId,
  }) async {
    _meals.clear();
    try {
      var _response =
          await http.post(Uri.parse(ServerInfo.DIET_DETAILS), body: {
        'dietId': dietId.toString(),
      });

      if (_response.statusCode == 201) {
        Map<String, dynamic> _body = json.decode(_response.body);
        List<dynamic> _dietMeals = _body['meals'];
        _dietMeals.forEach((meal) {
          _meals.add(
            Meal(
              id: meal['_id'],
              title: meal['title'],
              protein: double.parse(meal['protein'].toString()),
              ingredients: meal['ingredients']
                  .toString()
                  .replaceAll('[', '')
                  .replaceAll(']', '')
                  .split(RegExp(',|;')),
              calories: double.parse(meal['calories'].toString()),
              image: meal['image'],
              dietId: int.parse(meal['diet_id'].toString()),
              carbs: double.parse(meal['carbs'].toString()),
              cook: meal['cook'],
              directions: meal['directions']
                  .toString()
                  .replaceAll('[', '')
                  .replaceAll(']', '')
                  .split(RegExp(',|;')),
              fat: double.parse(meal['fat'].toString()),
              prep: meal['prep'],
              mealId: int.parse(meal['meal_id'].toString()),
            ),
          );
        });

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> setMealAsFavourite({
    @required String userId,
    @required String mealId,
    @required BuildContext context,
  }) async {
    try {
      var response = await http.post(Uri.parse(ServerInfo.FAV_MEALS), body: {
        'userId': userId,
        'mealId': mealId,
      });

      if (response.statusCode == 201) {
        GeneratedMeal _meal = Provider.of<GeneratedMeals>(
          context,
          listen: false,
        ).findMealById(
          mealId: int.parse(mealId),
        );
        Provider.of<Info>(
          context,
          listen: false,
        ).user.favMeals.add(
              _meal,
            );
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> removeMealFromFavourites({
    @required String userId,
    @required String mealId,
    @required BuildContext context,
  }) async {
    try {
      var response =
          await http.post(Uri.parse('${ServerInfo.FAV_MEALS}/remove'), body: {
        'userId': userId,
        'mealId': mealId,
      });

      if (response.statusCode == 201) {
        Provider.of<Info>(
          context,
          listen: false,
        ).user.favMeals.removeWhere(
              (meal) => meal.mealId == int.parse(mealId),
            );
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
