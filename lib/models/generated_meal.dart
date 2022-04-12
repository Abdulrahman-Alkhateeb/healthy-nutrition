import 'package:flutter/foundation.dart';
import 'package:healthy_nutrition/models/meal.dart';
import 'package:healthy_nutrition/utils/enums.dart';

class GeneratedMeal extends Meal {
  final GeneratedMealType type;

  GeneratedMeal({
    @required carbs,
    @required fat,
    @required protein,
    @required prep,
    @required cook,
    @required directions,
    @required ingredients,
    @required id,
    @required dietId,
    @required calories,
    @required title,
    @required image,
    @required mealId,
    @required this.type,
  }) : super(
          prep: prep,
          fat: fat,
          directions: directions,
          cook: cook,
          carbs: carbs,
          dietId: dietId,
          image: image,
          calories: calories,
          id: id,
          ingredients: ingredients,
          title: title,
          protein: protein,
          mealId: mealId,
        );

  // Map<String, String> toMap(){
  //   return {
  //     'id': id,
  //    'carbs': carbs.toString(),
  //    'fat': fat.toString(),
  //    'protein': ,
  //    'prep': ,
  //    'cook': ,
  //    'directions': ,
  //    'ingredients': ,
  //    'dietId': ,
  //    'calories': ,
  //    'title': ,
  //    'image': ,
  //    'mealId': ,
  //    'type': ,
  //   };
  // }
}
