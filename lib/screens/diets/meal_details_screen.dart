import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:healthy_nutrition/models/meal.dart';
import 'package:healthy_nutrition/providers/generated_meals.dart';
import 'package:healthy_nutrition/utils/color_palette.dart';
import 'package:healthy_nutrition/utils/server_info.dart';
import 'package:healthy_nutrition/widgets/feature_card.dart';
import 'package:provider/provider.dart';

class MealDetailsScreen extends StatefulWidget {
  static const String routeName = 'meal-details';

  @override
  _MealDetailsScreenState createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  Meal _meal;
  double _height;
  bool _firstTime = true, _isAdding = false, _canEdit;
  TextEditingController _ingredientController = TextEditingController();
  FocusNode _ingredientFocus = new FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;
      Map<String, dynamic> _data = ModalRoute.of(context).settings.arguments;
      _meal = _data['meal'];
      _canEdit = _data['canEdit'] ?? false;
      _firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            stretch: true,
            pinned: true,
            expandedHeight: 300,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: _meal.id,
                child: Image(
                  fit: BoxFit.cover,
                  image:
                      NetworkImage('${ServerInfo.MEALS_IMAGES}/${_meal.image}'),
                ),
              ),
              centerTitle: true,
              title: Text(
                _meal.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 2,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        constraints: BoxConstraints(
                          maxHeight:
                              _height / 2.5738058551617874576271186440678,
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
                                title: 'Carbs',
                                value: _meal.carbs.toString(),
                              ),
                              FeatureCard(
                                height: _height,
                                title: 'Fat',
                                value: _meal.fat.toString(),
                              ),
                              FeatureCard(
                                height: _height,
                                title: 'Protein',
                                value: _meal.protein.toString(),
                              ),
                              FeatureCard(
                                height: _height,
                                title: 'Prep',
                                value: _meal.prep.toString(),
                              ),
                              FeatureCard(
                                height: _height,
                                title: 'Cook',
                                value: _meal.cook.toString(),
                              ),
                              FeatureCard(
                                height: _height,
                                title: 'Calories',
                                value: _meal.calories.toString(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_meal.ingredients.length} Ingredients',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_canEdit)
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (_isAdding) {
                                    if (_ingredientController.text.isNotEmpty) {
                                      String _ingredient =
                                          _ingredientController.text;
                                      _meal.ingredients.add(_ingredient);
                                      _ingredientController.clear();
                                      Provider.of<GeneratedMeals>(
                                        context,
                                        listen: false,
                                      ).editMeal(
                                        meal: _meal,
                                        context: context,
                                      );
                                    }
                                  }
                                  _isAdding = !_isAdding;
                                });
                              },
                              icon: Icon(
                                _isAdding
                                    ? FlutterIcons.check_circle_fea
                                    : FlutterIcons.plus_circle_fea,
                                color: ColorPalette.PRIMARY_COLOR,
                                size: 30,
                              ),
                            ),
                        ],
                      ),
                      if (_isAdding)
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            labelText: 'Type Ingredient name',
                            labelStyle: TextStyle(
                              color: _ingredientFocus.hasFocus
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                          focusNode: _ingredientFocus,
                          controller: _ingredientController,
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: _height / 3.7963636363636365,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.blue,
                          ),
                          itemBuilder: (context, index) => _canEdit
                              ? Dismissible(
                                  key: GlobalKey(),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    padding: const EdgeInsets.only(right: 15),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                  onDismissed: (direction) {
                                    setState(() {
                                      _meal.ingredients.removeAt(index);
                                      _ingredientController.clear();
                                      Provider.of<GeneratedMeals>(
                                        context,
                                        listen: false,
                                      ).editMeal(
                                        meal: _meal,
                                        context: context,
                                      );
                                    });
                                  },
                                  child: buildListTile(index),
                                )
                              : buildListTile(index),
                          itemCount: _meal.ingredients.length,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            'Directions',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: _height / 3.7963636363636365,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.blue,
                          ),
                          itemBuilder: (context, index) => ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            title: Text(
                              _meal.directions[index],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          itemCount: _meal.directions.length,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListTile buildListTile(int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(
          '${index + 1}',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        _meal.ingredients[index],
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }
}
