import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:healthy_nutrition/models/generated_meal.dart';
import 'package:healthy_nutrition/models/user.dart';
import 'package:healthy_nutrition/utils/app_lists.dart';
import 'package:healthy_nutrition/utils/enums.dart';
import 'package:healthy_nutrition/utils/server_info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Info with ChangeNotifier {
  User _user;

  User get user {
    return _user;
  }

  Future<bool> signUp({
    @required String username,
    @required String password,
    @required String fullName,
  }) async {
    try {
      var response = await http.post(
        Uri.parse(ServerInfo.SIGN_UP),
        body: {
          'username': username,
          'password': password,
          'fullName': fullName,
        },
      );
      if (response.statusCode == 201)
        return true;
      else
        return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> login({
    @required String username,
    @required String password,
  }) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var response = await http.post(
        Uri.parse(ServerInfo.LOGIN),
        body: {
          'username': username,
          'password': password,
        },
      );
      if (response.statusCode == 201) {
        Map<String, dynamic> _body = json.decode(response.body);
        _prefs.setString('token', _body['token']);
        _prefs.setString('username', username);
        _prefs.setString('password', password);
        _prefs.setString('fullName', _body['fullName']);
        _prefs.setString('id', _body['id']);
        bool _goToHome = _body['goToHome'] == 'true' ? true : false;
        bool _didRecommend = _body['didRecommend'] == 'true' ? true : false;
        _prefs.setBool('goToHome', _goToHome);

        _prefs.setBool('didRecommend', _didRecommend);
        if (_goToHome) {
          var _userData = _body['user'];

          Gender _gender = Gender.values[AppLists.genders.keys.toList().indexOf(
                _userData['gender'].toString(),
              )];
          LifeStyle _lifeStyle;
          ExerciseType _exercise;
          Goal _goal = Goal.values[AppLists.goals.keys.toList().indexOf(
                _userData['goal'].toString(),
              )];

          switch (_userData['lifeStyle']) {
            case '1. Sedentary or light activity (e.g. - Office worker getting little or no exercise)':
              _lifeStyle = LifeStyle.Sedentary;
              break;
            case '2. Active or moderately active (Construction worker or person running one hour daily)':
              _lifeStyle = LifeStyle.Active;
              break;
            case '3. Vigorously active (Agricultural worker (non mechanized) or person swimming two hours daily)':
              _lifeStyle = LifeStyle.VigorouslyActive;
              break;
          }

          switch (_userData['exercise']) {
            case '1. Sedentary (little or no exercise)':
              _exercise = ExerciseType.Sedentary;
              break;
            case '2. Lightly active (light exercise/sports 1-3 days/ week)':
              _exercise = ExerciseType.LightlyActive;
              break;
            case '3. Moderately active (moderate exercise/sports 3-5 days/week)':
              _exercise = ExerciseType.ModeratelyActive;
              break;
            case '4. Very active (hard exercise/sports 6-7 days a week)':
              _exercise = ExerciseType.ModeratelyActive;
              break;
          }
          _user = User(
            name: _userData['fullName'],
            id: _userData['_id'],
            height: int.parse(_userData['height'].toString()),
            age: int.parse(_userData['age'].toString()),
            bmi: double.parse(_userData['bmi'].toString()),
            bmr: double.parse(_userData['bmr'].toString()),
            dailyCalorieNeed:
                double.parse(_userData['dailyCalorieNeed'].toString()),
            bodyType: _userData['bodyType'],
            weight: double.parse(_userData['weight'].toString()),
            gender: _gender,
            exercise: _exercise,
            goal: _goal,
            lifeStyle: _lifeStyle,
            favDiets: (_userData['diets'] as List)
                ?.map(
                  (e) => e as int,
                )
                ?.toList(),
            favMeals: (_userData['fav_meals'] as List)?.map(
              (meal) {
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
                return GeneratedMeal(
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
                  type: _type,
                );
              },
            )?.toList(),
          );
        }
        return true;
      } else
        return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> setInfo({
    @required User user,
  }) async {
    _user = user;

    String gender = '',
        id = _user.id,
        bodyType = _user.bodyType,
        age = _user.age.toString(),
        height = _user.height.toString(),
        weight = _user.weight.toString(),
        lifeStyle = '',
        exercise = '',
        goal = '',
        bmi = _user.bmi.toString(),
        bmr = _user.bmr.toString(),
        dailyCalorieNeed = _user.dailyCalorieNeed.toString();

    switch (_user.gender) {
      case Gender.Male:
        gender = 'Male';
        break;
      case Gender.Female:
        gender = 'Female';
        break;
    }

    switch (_user.lifeStyle) {
      case LifeStyle.Sedentary:
        lifeStyle =
            '1. Sedentary or light activity (e.g. - Office worker getting little or no exercise)';
        break;
      case LifeStyle.Active:
        lifeStyle =
            '2. Active or moderately active (Construction worker or person running one hour daily)';
        break;
      case LifeStyle.VigorouslyActive:
        lifeStyle =
            '3. Vigorously active (Agricultural worker (non mechanized) or person swimming two hours daily)';
        break;
    }

    switch (_user.exercise) {
      case ExerciseType.Sedentary:
        exercise = '1. Sedentary (little or no exercise)';
        break;
      case ExerciseType.LightlyActive:
        exercise = '2. Lightly active (light exercise/sports 1-3 days/ week)';
        break;
      case ExerciseType.ModeratelyActive:
        exercise =
            '3. Moderately active (moderate exercise/sports 3-5 days/week)';
        break;
      case ExerciseType.VeryActive:
        exercise = '4. Very active (hard exercise/sports 6-7 days a week)';
        break;
    }

    switch (_user.goal) {
      case Goal.GainWeight:
        goal = 'Gain Muscle';
        break;
      case Goal.MaintainWeight:
        goal = 'Maintain Weight';
        break;
      case Goal.LoseWeight:
        goal = 'Lose Weight';
        break;
    }
    notifyListeners();
    return await _saveInfo(
      id: id,
      gender: gender,
      bmi: bmi,
      bmr: bmr,
      age: age,
      goal: goal,
      height: height,
      weight: weight,
      exercise: exercise,
      bodyType: bodyType,
      lifeStyle: lifeStyle,
      dailyCalorieNeed: dailyCalorieNeed,
      editInfo: false,
    );
  }

  Future<bool> editInfo({
    @required User user,
  }) async {
    _user = user;

    String gender = '',
        id = _user.id,
        bodyType = _user.bodyType,
        age = _user.age.toString(),
        height = _user.height.toString(),
        weight = _user.weight.toString(),
        lifeStyle = '',
        exercise = '',
        goal = '',
        bmi = _user.bmi.toString(),
        bmr = _user.bmr.toString(),
        dailyCalorieNeed = _user.dailyCalorieNeed.toString();

    switch (_user.gender) {
      case Gender.Male:
        gender = 'Male';
        break;
      case Gender.Female:
        gender = 'Female';
        break;
    }

    switch (_user.lifeStyle) {
      case LifeStyle.Sedentary:
        lifeStyle =
            '1. Sedentary or light activity (e.g. - Office worker getting little or no exercise)';
        break;
      case LifeStyle.Active:
        lifeStyle =
            '2. Active or moderately active (Construction worker or person running one hour daily)';
        break;
      case LifeStyle.VigorouslyActive:
        lifeStyle =
            '3. Vigorously active (Agricultural worker (non mechanized) or person swimming two hours daily)';
        break;
    }

    switch (_user.exercise) {
      case ExerciseType.Sedentary:
        exercise = '1. Sedentary (little or no exercise)';
        break;
      case ExerciseType.LightlyActive:
        exercise = '2. Lightly active (light exercise/sports 1-3 days/ week)';
        break;
      case ExerciseType.ModeratelyActive:
        exercise =
            '3. Moderately active (moderate exercise/sports 3-5 days/week)';
        break;
      case ExerciseType.VeryActive:
        exercise = '4. Very active (hard exercise/sports 6-7 days a week)';
        break;
    }

    switch (_user.goal) {
      case Goal.GainWeight:
        goal = 'Gain Muscle';
        break;
      case Goal.MaintainWeight:
        goal = 'Maintain Weight';
        break;
      case Goal.LoseWeight:
        goal = 'Lose Weight';
        break;
    }
    notifyListeners();
    return await _saveInfo(
      id: id,
      gender: gender,
      bmi: bmi,
      bmr: bmr,
      age: age,
      goal: goal,
      height: height,
      weight: weight,
      exercise: exercise,
      bodyType: bodyType,
      lifeStyle: lifeStyle,
      dailyCalorieNeed: dailyCalorieNeed,
      editInfo: true,
    );
  }

  Future<bool> _saveInfo({
    @required String id,
    @required String gender,
    @required String bmi,
    @required String bmr,
    @required String age,
    @required String goal,
    @required String height,
    @required String weight,
    @required String exercise,
    @required String lifeStyle,
    @required String bodyType,
    @required String dailyCalorieNeed,
    @required bool editInfo,
  }) async {
    try {
      var response = await http.patch(
        Uri.parse(editInfo ? ServerInfo.EDIT_INFO : ServerInfo.SIGN_UP),
        body: {
          'id': id,
          'name': _user.name,
          'gender': gender,
          'bmi': bmi,
          'bmr': bmr,
          'age': age,
          'goal': goal,
          'height': height,
          'weight': weight,
          'exercise': exercise,
          'lifeStyle': lifeStyle,
          'bodyType': bodyType,
          'dailyCalorieNeed': dailyCalorieNeed,
          'goToHome': 'true',
          'didRecommend': 'true',
        },
      );
      if (response.statusCode == 201) {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setBool('goToHome', true);
        _prefs.setBool('recommendDiets', true);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  double calculateBMR({
    @required double weight,
    @required int height,
    @required int age,
    @required Gender gender,
  }) {
    if (gender == Gender.Male)
      return 66 + (13.7 * weight) + (5 * height) - (6.8 * age);
    else
      return 655 + (9.6 * weight) + (1.8 * height) - (4.7 * age);
  }

  double calculateBMI({
    @required double weight,
    @required int height,
  }) {
    return weight / ((height / 100) * (height / 100));
  }

  double calculateDailyCalorieNeed({
    @required double bmr,
    @required ExerciseType exerciseType,
  }) {
    switch (exerciseType) {
      case ExerciseType.Sedentary:
        return bmr * 1.2;
      case ExerciseType.LightlyActive:
        return bmr * 1.375;
      case ExerciseType.ModeratelyActive:
        return bmr * 1.55;
      case ExerciseType.VeryActive:
      default:
        return bmr * 1.725;
    }
  }
}
