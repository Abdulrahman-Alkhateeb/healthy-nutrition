import 'package:healthy_nutrition/utils/enums.dart';

class AppLists {
  static const Map<String, Goal> goals = {
    'Gain Muscle': Goal.GainWeight,
    'Maintain Weight': Goal.MaintainWeight,
    'Lose Weight': Goal.LoseWeight,
  };
  static const Map<String, Gender> genders = {
    'Male': Gender.Male,
    'Female': Gender.Female,
  };
  static const Map<String, LifeStyle> lifeStyles = {
    'Sedentary or light activity': LifeStyle.Sedentary,
    'Active or moderately active': LifeStyle.Active,
    'Vigorously active': LifeStyle.VigorouslyActive,
  };
  static const Map<String, ExerciseType> exercises = {
    'Sedentary': ExerciseType.Sedentary,
    'Lightly active': ExerciseType.LightlyActive,
    'Moderately active': ExerciseType.ModeratelyActive,
    'Very active': ExerciseType.VeryActive,
  };
}
