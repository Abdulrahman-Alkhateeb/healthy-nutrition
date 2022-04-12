import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:healthy_nutrition/providers/generated_meals.dart';
import 'package:healthy_nutrition/screens/custom_meals/custom_meals_screen.dart';
import 'package:healthy_nutrition/utils/color_palette.dart';
import 'package:healthy_nutrition/widgets/custom_app_bar.dart';
import 'package:healthy_nutrition/widgets/custom_bottom_bar.dart';
import 'package:healthy_nutrition/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

class GenerateMealScreen extends StatefulWidget {
  static const String routeName = 'gen-meal';
  @override
  _GenerateMealScreenState createState() => _GenerateMealScreenState();
}

class _GenerateMealScreenState extends State<GenerateMealScreen> {
  Map<String, String> _data = {};
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future<void> _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      bool _result = await Provider.of<GeneratedMeals>(
        context,
        listen: false,
      ).generateMeals(
        fat: _data['fat'],
        carbs: _data['carbs'],
        protein: _data['protein'],
      );
      if (_result) {
        Navigator.of(context).pushNamed(CustomMealsScreen.routeName);
      } else {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Something Went Wrong, Try Again',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Custom Meal',
      ),
      drawer: CustomDrawer(),
      bottomNavigationBar: CustomBottomBar(
        index: 1,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 5,
                  clipBehavior: Clip.hardEdge,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(23),
                      topLeft: Radius.circular(23),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    color: ColorPalette.PRIMARY_COLOR,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Enter Values To Generate Meals',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: ColorPalette.PRIMARY_COLOR,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 25,
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Fat',
                          ),
                          onSaved: (fat) => _data['fat'] = fat,
                          validator: (value) {
                            if (value.isEmpty) return 'Please Enter Fat';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Protein',
                          ),
                          onSaved: (protein) => _data['protein'] = protein,
                          validator: (value) {
                            if (value.isEmpty) return 'Please Enter Protein';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Carbs',
                          ),
                          onSaved: (carbs) => _data['carbs'] = carbs,
                          validator: (value) {
                            if (value.isEmpty) return 'Please Enter Carbs';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 75,
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: ColorPalette.PRIMARY_COLOR,
                    onPressed: _submit,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Text(
                          'Generate',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          FlutterIcons.arrow_right_fea,
                          color: Colors.white,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
