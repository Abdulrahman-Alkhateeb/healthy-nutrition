import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart' as fi;
import 'package:healthy_nutrition/models/user.dart';
import 'package:healthy_nutrition/providers/info.dart';
import 'package:healthy_nutrition/screens/user/edit_user_info_screen.dart';
import 'package:healthy_nutrition/utils/enums.dart';
import 'package:healthy_nutrition/widgets/custom_app_bar.dart';
import 'package:healthy_nutrition/widgets/custom_bottom_bar.dart';
import 'package:healthy_nutrition/widgets/custom_drawer.dart';
import 'package:healthy_nutrition/widgets/feature_card.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = 'profile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double _height;
  bool _firstTime = true, _isLoading = true;
  User _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;
      // Map<String, dynamic> _data = ModalRoute.of(context).settings.arguments;
      _getUser();
      _firstTime = false;
    }
  }

  Future<void> _getUser() async {
    _user = Provider.of<Info>(
      context,
      listen: false,
    ).user;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        rightButton: IconButton(
          icon: Icon(
            fi.FlutterIcons.edit_fea,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(EditUserInfoScreen.routeName);
          },
        ),
      ),
      drawer: CustomDrawer(),
      bottomNavigationBar: CustomBottomBar(
        index: 3,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          _user.name ?? '',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: 520,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GridView(
                          physics: BouncingScrollPhysics(
                            parent: NeverScrollableScrollPhysics(),
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 10,
                          ),
                          children: [
                            FeatureCard(
                              height: _height,
                              title: 'Gender',
                              value: _gender(
                                gender: _user.gender,
                              ),
                            ),
                            FeatureCard(
                              height: _height,
                              title: 'Age',
                              value: _user.age.toString(),
                            ),
                            FeatureCard(
                              height: _height,
                              title: 'BMI',
                              value: _user.bmi.toStringAsFixed(2),
                            ),
                            FeatureCard(
                              height: _height,
                              title: 'Weight',
                              value: _user.weight.toString(),
                            ),
                            FeatureCard(
                              height: _height,
                              title: 'Height',
                              value: _user.height.toString(),
                            ),
                            FeatureCard(
                              height: _height,
                              title: 'BMR',
                              value: _user.bmr.toStringAsFixed(2),
                            ),
                            FeatureCard(
                              height: _height,
                              title: 'Exercise',
                              value: _exercise(
                                exerciseType: _user.exercise,
                              ),
                            ),
                            FeatureCard(
                              height: _height,
                              title: 'Lifestyle',
                              value: _lifestyle(
                                lifeStyle: _user.lifeStyle,
                              ),
                            ),
                            FeatureCard(
                              height: _height,
                              title: 'Goal',
                              value: _goal(
                                goal: _user.goal,
                              ),
                            ),
                            FeatureCard(
                              height: _height,
                              title: 'Calories',
                              value: _user.dailyCalorieNeed.toStringAsFixed(2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.blue,
                      thickness: 2,
                      endIndent: 10,
                      indent: 10,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String _gender({
    @required Gender gender,
  }) {
    switch (gender) {
      case Gender.Male:
        return 'Male';
      case Gender.Female:
      default:
        return 'Female';
    }
  }

  String _goal({
    @required Goal goal,
  }) {
    switch (goal) {
      case Goal.GainWeight:
        return 'Gain\nWeight';
      case Goal.MaintainWeight:
        return 'Maintain\nWeight';
      case Goal.LoseWeight:
      default:
        return 'Lose\nWeight';
    }
  }

  String _exercise({
    @required ExerciseType exerciseType,
  }) {
    switch (exerciseType) {
      case ExerciseType.Sedentary:
        return 'Sedentary';
      case ExerciseType.LightlyActive:
        return 'Lightly\nActive';
      case ExerciseType.ModeratelyActive:
        return 'Moderately\nActive';
      case ExerciseType.VeryActive:
      default:
        return 'Very\nActive';
    }
  }

  String _lifestyle({
    @required LifeStyle lifeStyle,
  }) {
    switch (lifeStyle) {
      case LifeStyle.Sedentary:
        return 'Sedentary';
      case LifeStyle.Active:
        return 'Active';
      case LifeStyle.VigorouslyActive:
      default:
        return 'Vigorously\nActive';
    }
  }
}
