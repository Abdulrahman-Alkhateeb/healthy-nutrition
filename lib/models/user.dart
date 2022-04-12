import 'package:flutter/foundation.dart';
import 'package:healthy_nutrition/models/generated_meal.dart';
import 'package:healthy_nutrition/utils/enums.dart';

class User {
  final int age, height;
  final String id, name, bodyType;
  final double weight, bmi, bmr, dailyCalorieNeed;
  final Goal goal;
  final Gender gender;
  final ExerciseType exercise;
  final LifeStyle lifeStyle;
  final List<int> favDiets;
  final List<GeneratedMeal> favMeals;

  User({
    @required this.id,
    @required this.name,
    @required this.gender,
    @required this.bmi,
    @required this.bmr,
    @required this.age,
    @required this.goal,
    @required this.height,
    @required this.weight,
    @required this.exercise,
    @required this.lifeStyle,
    @required this.bodyType,
    @required this.dailyCalorieNeed,
    @required this.favDiets,
    @required this.favMeals,
  });
}
