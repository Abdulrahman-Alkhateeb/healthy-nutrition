import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Meal extends Equatable {
  final int dietId, mealId;
  final double calories, carbs, fat, protein;
  final String id, image, prep, cook, title;
  final List<String> ingredients, directions;

  Meal({
    @required this.carbs,
    @required this.fat,
    @required this.protein,
    @required this.prep,
    @required this.cook,
    @required this.directions,
    @required this.ingredients,
    @required this.id,
    @required this.dietId,
    @required this.calories,
    @required this.image,
    @required this.mealId,
    @required this.title,
  });

  @override
  List<Object> get props => [
        mealId,
        dietId,
      ];
}
