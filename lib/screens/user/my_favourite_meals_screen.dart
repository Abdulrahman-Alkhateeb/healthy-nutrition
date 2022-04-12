import 'package:flutter/material.dart';
import 'package:healthy_nutrition/models/diet.dart';
import 'package:healthy_nutrition/models/generated_meal.dart';
import 'package:healthy_nutrition/providers/diets.dart';
import 'package:healthy_nutrition/providers/meals.dart';
import 'package:healthy_nutrition/widgets/custom_bottom_bar.dart';
import 'package:healthy_nutrition/widgets/custom_drawer.dart';
import 'package:healthy_nutrition/widgets/diet_card.dart';
import 'package:healthy_nutrition/widgets/generated_meal_card.dart';
import 'package:provider/provider.dart';

class MyFavouritesScreen extends StatefulWidget {
  static const String routeName = 'my-fav';

  @override
  _MyFavouritesScreenState createState() => _MyFavouritesScreenState();
}

class _MyFavouritesScreenState extends State<MyFavouritesScreen>
    with SingleTickerProviderStateMixin {
  bool _firstTime = true;
  List<GeneratedMeal> _meals = [];
  List<Diet> _diets = [];
  double _height;
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 2,
      vsync: this,
    );
  }

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
    _meals = Provider.of<Meals>(context).favMeals(context: context);
    _diets = Provider.of<Diets>(context).favDiets();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _controller,
            tabs: [
              Tab(
                child: Text(
                  'Meals',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Diets',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          title: Text(
            'My Favourites',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        ),
        drawer: CustomDrawer(),
        bottomNavigationBar: CustomBottomBar(
          index: 2,
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            _meals.isEmpty
                ? Center(
                    child: Text(
                      'You Don\'t Have Any Favourite Meals Yet',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                  )
                : SingleChildScrollView(
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
                                  canEdit: true,
                                  key: ValueKey(meal.id),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                  ),
            _diets.isEmpty
                ? Center(
                    child: Text(
                      'You Don\'t Have Any Favourite Diets Yet',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._diets
                              .map(
                                (diet) => DietCard(
                                  height: _height,
                                  diet: diet,
                                  fromFavs: true,
                                  key: UniqueKey(),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
