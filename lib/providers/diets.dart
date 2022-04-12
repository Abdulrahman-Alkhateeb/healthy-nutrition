import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:healthy_nutrition/models/diet.dart';
import 'package:healthy_nutrition/models/user.dart';
import 'package:healthy_nutrition/providers/info.dart';
import 'package:healthy_nutrition/utils/enums.dart';
import 'package:healthy_nutrition/utils/server_info.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Diets with ChangeNotifier {
  List<Diet> _recommendedDiets = [];
  List<Diet> _favDiets = [];

  Future<void> getFavDiets({
    @required BuildContext context,
  }) async {
    String _userId = Provider.of<Info>(
      context,
      listen: false,
    ).user.id;
    if (_favDiets.isEmpty) {
      try {
        var _response = await http
            .post(Uri.parse('${ServerInfo.FAV_DIETS}/getDiets'), body: {
          'userId': _userId,
        });
        if (_response.statusCode == 201) {
          var _body = json.decode(_response.body);
          List<dynamic> _diets = _body['favDiets'];

          _diets.forEach((diet) {
            _favDiets.add(
              Diet(
                id: diet['_id'],
                dietId: int.parse(diet['diet_id'].toString()),
                name: diet['diet_name'],
                image: diet['diet_image'],
                shortDescription: diet['diet_description'].toString().substring(
                      0,
                      50,
                    ),
                longDescription: diet['diet_description'],
                type: diet['diet_type'],
              ),
            );
          });
        }
      } catch (e) {
        print(e);
        throw e;
      }
    }
    notifyListeners();
  }

  List<Diet> favDiets() {
    return [..._favDiets];
  }

  Future<List<Diet>> recommendedDiets({
    @required BuildContext context,
  }) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool _goToHome = _prefs.getBool('goToHome') ?? false;
    bool _didRecommend = _prefs.getBool('didRecommend') ?? false;
    bool _recommend = _goToHome && _didRecommend;

    if (_recommend) {
      await Provider.of<Diets>(context, listen: false).recommend(
        context: context,
      );
    }

    getFavDiets(context: context);

    return [..._recommendedDiets];
  }

  Future<bool> recommend({
    @required BuildContext context,
  }) async {
    _recommendedDiets.clear();
    User _user = Provider.of<Info>(context, listen: false).user;

    String gender = '',
        age = _user.age.toString(),
        bodyType = _user.bodyType,
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
    try {
      var response = await http.post(
        Uri.parse(ServerInfo.RECOMMEND),
        body: {
          'gender': gender,
          'bmi': bmi,
          'bmr': bmr,
          'age': age,
          'goal': goal,
          'height': height,
          'weight': weight,
          'exercise': exercise,
          'bodyType': bodyType,
          'lifeStyle': lifeStyle,
          'dailyCalorieNeed': dailyCalorieNeed,
        },
      );

      if (response.statusCode == 201) {
        Map<String, dynamic> _body = json.decode(response.body);
        List<dynamic> _diets = _body['result'];

        _diets.forEach((diet) {
          _recommendedDiets.add(
            Diet(
              id: diet['_id'],
              dietId: int.parse(diet['diet_id'].toString()),
              name: diet['diet_name'],
              image: diet['diet_image'],
              shortDescription: diet['diet_description'].toString().substring(
                    0,
                    50,
                  ),
              longDescription: diet['diet_description'],
              type: diet['diet_type'],
            ),
          );
        });
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setBool('didRecommend', true);
        return true;
      } else {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setBool('didRecommend', false);
        return false;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> setDietAsFavourite({
    @required String userId,
    @required String dietId,
  }) async {
    try {
      var response = await http.post(Uri.parse(ServerInfo.FAV_DIETS), body: {
        'userId': userId,
        'dietId': dietId,
      });

      if (response.statusCode == 201) {
        _favDiets.add(
          findDietById(
            dietId: int.parse(dietId),
          ),
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> removeDietFromFavourites({
    @required String userId,
    @required String dietId,
  }) async {
    try {
      var response =
          await http.post(Uri.parse('${ServerInfo.FAV_DIETS}/remove'), body: {
        'userId': userId,
        'dietId': dietId,
      });

      if (response.statusCode == 201) {
        _favDiets.removeWhere((diet) => diet.dietId == int.parse(dietId));
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

  Diet findDietById({
    @required int dietId,
  }) {
    return _recommendedDiets.firstWhere((diet) => diet.dietId == dietId);
  }
}
