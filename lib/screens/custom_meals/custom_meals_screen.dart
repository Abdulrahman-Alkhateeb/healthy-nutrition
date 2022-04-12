import 'package:flutter/material.dart';
import 'package:healthy_nutrition/models/generated_meal.dart';
import 'package:healthy_nutrition/providers/generated_meals.dart';
import 'package:healthy_nutrition/widgets/custom_app_bar.dart';
import 'package:healthy_nutrition/widgets/custom_bottom_bar.dart';
import 'package:healthy_nutrition/widgets/custom_drawer.dart';
import 'package:healthy_nutrition/widgets/generated_meal_card.dart';
import 'package:provider/provider.dart';

class CustomMealsScreen extends StatefulWidget {
  static const String routeName = 'custom-meals';

  @override
  _CustomMealsScreenState createState() => _CustomMealsScreenState();
}

class _CustomMealsScreenState extends State<CustomMealsScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  bool _firstTime = true;
  List<GeneratedMeal> _meals = [];
  double _height;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;

      _firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _meals = Provider.of<GeneratedMeals>(context).meals;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Generated Meals',
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
                ..._meals
                    .map(
                      (meal) => GeneratedMealCard(
                        height: _height,
                        meal: meal,
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
