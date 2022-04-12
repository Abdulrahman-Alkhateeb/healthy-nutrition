import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:healthy_nutrition/models/user.dart';
import 'package:healthy_nutrition/providers/info.dart';
import 'package:healthy_nutrition/screens/diets/home_screen.dart';
import 'package:healthy_nutrition/utils/app_lists.dart';
import 'package:healthy_nutrition/utils/color_palette.dart';
import 'package:healthy_nutrition/utils/enums.dart';
import 'package:healthy_nutrition/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditUserInfoScreen extends StatefulWidget {
  static const String routeName = 'edit-info';

  @override
  _EditUserInfoScreenState createState() => _EditUserInfoScreenState();
}

class _EditUserInfoScreenState extends State<EditUserInfoScreen> {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final _nagmFormKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  TextEditingController _ageController = TextEditingController(),
      _heightController = TextEditingController(),
      _weightController = TextEditingController();

  int _radioGoalValue, _radioGenderValue;
  String _bodyType = '';
  int _age, _userHeight, _radioLifeStyleValue, _radioExerciseTypeValue;
  double _weight, _height, _bmi;
  Gender _gender;
  LifeStyle _lifeStyle;
  Goal _goal;
  ExerciseType _exerciseType;

  bool _isLoading = false, _firstTime = true;
  User _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _user = Provider.of<Info>(context, listen: false).user;
      _ageController.text = _user.age.toString();
      _heightController.text = _user.height.toString();
      _weightController.text = _user.weight.toString();
      _radioGoalValue = _user.goal.index;
      _radioExerciseTypeValue = _user.exercise.index;
      _radioLifeStyleValue = _user.lifeStyle.index;
      _radioGenderValue = _user.gender.index;
      _firstTime = false;
    }
  }

  Future<void> _next() async {
    _saveNAGM();
    bool _navigate = await _saveExerciseType();
    if (_navigate) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HomeScreen.routeName,
        (route) => false,
      );
    } else {
      _scaffoldState.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Text(
                'Something Went Wrong, Try Again.',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _saveNAGM() {
    if (_nagmFormKey.currentState.validate()) {
      _nagmFormKey.currentState.save();
      setState(() {
        _calcBmi();
        _gender = Gender.values[_radioGenderValue];
        _lifeStyle = LifeStyle.values[_radioLifeStyleValue];
      });
    }
  }

  Future<bool> _saveExerciseType() async {
    setState(() {
      _exerciseType = ExerciseType.values[_radioExerciseTypeValue];
      _goal = Goal.values[_radioGoalValue];
      _isLoading = true;
    });
    bool _isInfoSet = await _setUserInfo();
    if (_isInfoSet) {
      return true;
    } else
      return false;
  }

  Future<bool> _setUserInfo() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    double _bmr = Provider.of<Info>(
      context,
      listen: false,
    ).calculateBMR(
      weight: _weight,
      height: _userHeight,
      age: _age,
      gender: _gender,
    );
    double _dailyCalorieNeed = Provider.of<Info>(
      context,
      listen: false,
    ).calculateDailyCalorieNeed(
      bmr: _bmr,
      exerciseType: _exerciseType,
    );

    return await Provider.of<Info>(
      context,
      listen: false,
    ).setInfo(
      user: User(
        id: _user.id,
        name: _user.name,
        gender: _gender,
        bmi: _bmi,
        bmr: _bmr,
        age: _age,
        bodyType: _bodyType,
        goal: _goal,
        height: _userHeight,
        weight: _weight,
        exercise: _exerciseType,
        lifeStyle: _lifeStyle,
        dailyCalorieNeed: _dailyCalorieNeed,
        favMeals: _user.favMeals,
        favDiets: _user.favDiets,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldState,
      appBar: CustomAppBar(
        title: 'Edit User Info',
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 20,
          ),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(),
                  child: _buildInfoChecks(),
                ),
        ),
      ),
    );
  }

  void _calcBmi() {
    setState(() {
      _bmi = Provider.of<Info>(
        context,
        listen: false,
      ).calculateBMI(
        weight: _weight,
        height: _userHeight,
      );
      if (_bmi < 18.5) _bodyType = 'Underweight';
      if (_bmi <= 24.9 && _bmi >= 18.5) _bodyType = 'Normal';
      if (_bmi <= 29.9 && _bmi >= 25.0) _bodyType = 'Overweight';
      if (_bmi >= 30.0) _bodyType = 'Obese';
    });
  }

  Column _buildGoal() {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Column(
          children: [
            Card(
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      'Your goal',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: CustomRadioButton(
                            elevation: 3,
                            horizontal: true,
                            enableShape: true,
                            height: _height / 15.185454545454546,
                            defaultSelected: _user.goal,
                            customShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(500),
                              side: BorderSide(
                                color: ColorPalette.PRIMARY_COLOR,
                                width: 2,
                              ),
                            ),
                            absoluteZeroSpacing: false,
                            unSelectedColor: Theme.of(context).canvasColor,
                            buttonLables: [
                              ...AppLists.goals.entries
                                  .map(
                                    (goal) => goal.key == 'Gain Muscle'
                                        ? 'Gain Weight'
                                        : goal.key,
                                  )
                                  .toList()
                            ],
                            buttonValues: [
                              ...AppLists.goals.entries
                                  .map(
                                    (gender) => gender.value,
                                  )
                                  .toList()
                            ],
                            buttonTextStyle: ButtonTextStyle(
                              selectedColor: Colors.white,
                              unSelectedColor: Colors.black,
                              textStyle: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            radioButtonValue: (value) {
                              setState(() {
                                setState(() {
                                  _radioGoalValue = value.index;
                                });
                              });
                            },
                            selectedColor: ColorPalette.PRIMARY_COLOR,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
          ],
        ),
      ],
    );
  }

  Column _buildInfoChecks() {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Form(
          key: _nagmFormKey,
          child: Column(
            children: [
              Card(
                elevation: 5,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) return 'Please Enter Your Age';
                            return null;
                          },
                          controller: _ageController,
                          onSaved: (newValue) => _age = int.parse(newValue),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Age',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Please Enter Your Height';
                            return null;
                          },
                          controller: _heightController,
                          onSaved: (newValue) =>
                              _userHeight = int.parse(newValue),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Height (cm)',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: TextFormField(
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onSaved: (newValue) =>
                              _weight = double.parse(newValue),
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Please Enter Your Weight';
                            return null;
                          },
                          controller: _weightController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Weight (kg)',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Card(
                elevation: 5,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Text(
                          'What is your gender?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: CustomRadioButton(
                              elevation: 3,
                              horizontal: true,
                              enableShape: true,
                              defaultSelected: _user.gender,
                              height: _height / 15.185454545454546,
                              customShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(500),
                                side: BorderSide(
                                  color: ColorPalette.PRIMARY_COLOR,
                                  width: 2,
                                ),
                              ),
                              absoluteZeroSpacing: false,
                              unSelectedColor: Theme.of(context).canvasColor,
                              buttonLables: [
                                ...AppLists.genders.entries
                                    .map(
                                      (gender) => gender.key,
                                    )
                                    .toList()
                              ],
                              buttonValues: [
                                ...AppLists.genders.entries
                                    .map(
                                      (gender) => gender.value,
                                    )
                                    .toList()
                              ],
                              buttonTextStyle: ButtonTextStyle(
                                selectedColor: Colors.white,
                                unSelectedColor: Colors.black,
                                textStyle: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              radioButtonValue: (value) {
                                setState(() {
                                  _radioGenderValue = value.index;
                                });
                              },
                              selectedColor: ColorPalette.PRIMARY_COLOR,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Card(
                elevation: 5,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Text(
                          'How do you describe your life style?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: CustomRadioButton(
                              elevation: 3,
                              horizontal: true,
                              enableButtonWrap: true,
                              enableShape: true,
                              defaultSelected: _user.lifeStyle,
                              height: _height / 15.185454545454546,
                              customShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(500),
                                side: BorderSide(
                                  color: ColorPalette.PRIMARY_COLOR,
                                  width: 2,
                                ),
                              ),
                              absoluteZeroSpacing: false,
                              unSelectedColor: Theme.of(context).canvasColor,
                              buttonLables: [
                                ...AppLists.lifeStyles.entries
                                    .map(
                                      (gender) => gender.key,
                                    )
                                    .toList()
                              ],
                              buttonValues: [
                                ...AppLists.lifeStyles.entries
                                    .map(
                                      (gender) => gender.value,
                                    )
                                    .toList()
                              ],
                              buttonTextStyle: ButtonTextStyle(
                                selectedColor: Colors.white,
                                unSelectedColor: Colors.black,
                                textStyle: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              radioButtonValue: (value) {
                                setState(() {
                                  setState(() {
                                    _radioLifeStyleValue = value.index;
                                  });
                                });
                              },
                              selectedColor: ColorPalette.PRIMARY_COLOR,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              _buildExercise(),
            ],
          ),
        ),
      ],
    );
  }

  Column _buildExercise() {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          child: Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    'Do you exercise?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CustomRadioButton(
                        elevation: 3,
                        horizontal: true,
                        enableShape: true,
                        height: _height / 15.185454545454546,
                        defaultSelected: _user.exercise,
                        customShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(500),
                          side: BorderSide(
                            color: ColorPalette.PRIMARY_COLOR,
                            width: 2,
                          ),
                        ),
                        absoluteZeroSpacing: false,
                        unSelectedColor: Theme.of(context).canvasColor,
                        buttonLables: [
                          ...AppLists.exercises.entries
                              .map(
                                (gender) => gender.key,
                              )
                              .toList()
                        ],
                        buttonValues: [
                          ...AppLists.exercises.entries
                              .map(
                                (gender) => gender.value,
                              )
                              .toList()
                        ],
                        buttonTextStyle: ButtonTextStyle(
                          selectedColor: Colors.white,
                          unSelectedColor: Colors.black,
                          textStyle: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        radioButtonValue: (value) {
                          setState(() {
                            setState(() {
                              _radioExerciseTypeValue = value.index;
                            });
                          });
                        },
                        selectedColor: ColorPalette.PRIMARY_COLOR,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        _buildGoal(),
        Container(
          height: _height / 15.185454545454546,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(500),
              ),
              primary: ColorPalette.PRIMARY_COLOR,
            ),
            onPressed: _next,
            child: Text(
              'Save Info',
              style: TextStyle(
                height: 1,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
