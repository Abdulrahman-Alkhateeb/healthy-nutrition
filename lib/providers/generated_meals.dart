import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:healthy_nutrition/models/generated_meal.dart';
import 'package:healthy_nutrition/providers/info.dart';
import 'package:healthy_nutrition/utils/enums.dart';
import 'package:healthy_nutrition/utils/server_info.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class GeneratedMeals with ChangeNotifier {
  List<GeneratedMeal> _meals = [];

  List<GeneratedMeal> get meals {
    return [..._meals];
  }

  Future<void> editMeal({
    @required GeneratedMeal meal,
    @required BuildContext context,
  }) async {
    var response =
        http.post(Uri.parse('${ServerInfo.FAV_MEALS}/editMeal'), body: {
      'id': meal.id.toString(),
      'carbs': meal.carbs.toString(),
      'fat': meal.fat.toString(),
      'protein': meal.protein.toString(),
      'prep': meal.prep.toString(),
      'cook': meal.cook.toString(),
      'directions':
          meal.directions.toString().replaceAll('[', '').replaceAll(']', ''),
      'ingredients':
          meal.ingredients.toString().replaceAll('[', '').replaceAll(']', ''),
      'diet_id': meal.dietId.toString(),
      'calories': meal.calories.toString(),
      'title': meal.title.toString(),
      'image': meal.image.toString(),
      'meal_id': meal.mealId.toString(),
      'type': meal.type.toString(),
      'userId': Provider.of<Info>(context, listen: false).user.id,
    });
    notifyListeners();
  }

  Future<bool> generateMeals({
    @required String fat,
    @required String protein,
    @required String carbs,
  }) async {
    _meals.clear();
    try {
      var response = await http.post(Uri.parse(ServerInfo.GENERATE), body: {
        'fat': fat,
        'protein': protein,
        'carbs': carbs,
      });

      if (response.statusCode == 201) {
        var _body = json.decode(response.body);
        List<dynamic> _generatedMeals = _body['meals'];

        _generatedMeals.forEach((meal) {
          GeneratedMealType _type;

          switch (meal['meal_type']) {
            case 'breakfast':
              _type = GeneratedMealType.Breakfast;
              break;
            case 'lunch':
              _type = GeneratedMealType.Lunch;
              break;
            case 'dinner':
              _type = GeneratedMealType.Dinner;
              break;
          }

          _meals.add(
            GeneratedMeal(
              type: _type,
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

  GeneratedMeal findMealById({
    @required int mealId,
  }) {
    return _meals.firstWhere(
      (meal) => meal.mealId == mealId,
    );
  }
}
