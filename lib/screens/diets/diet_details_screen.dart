import 'package:flutter/material.dart';
import 'package:healthy_nutrition/models/diet.dart';
import 'package:healthy_nutrition/models/meal.dart';
import 'package:healthy_nutrition/providers/meals.dart';
import 'package:healthy_nutrition/utils/server_info.dart';
import 'package:healthy_nutrition/widgets/meal_card.dart';
import 'package:provider/provider.dart';

class DietDetailsScreen extends StatefulWidget {
  static const String routeName = 'details';

  @override
  _DietDetailsScreenState createState() => _DietDetailsScreenState();
}

class _DietDetailsScreenState extends State<DietDetailsScreen> {
  Diet _diet;
  double _height;
  bool _firstTime = true, _fromFavs;
  List<Meal> _meals = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;
      Map<String, dynamic> _data = ModalRoute.of(context).settings.arguments;
      _diet = _data['diet'];
      _fromFavs = _data['fromFavs'] ?? false;
      _getMeals();

      _firstTime = false;
    }
  }

  Future<void> _getMeals() async {
    await Provider.of<Meals>(
      context,
      listen: false,
    ).getMeals(dietId: _diet.dietId);

    setState(() {
      _meals = Provider.of<Meals>(context, listen: false).meals();
    });
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
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: _fromFavs ? _diet.dietId : _diet.id,
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/loading.gif'),
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    '${ServerInfo.DIETS_IMAGES}/${_diet.image}',
                  ),
                ),
              ),
              centerTitle: true,
              title: Text(
                _diet.name,
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
                      Row(
                        children: [
                          Text(
                            'Diet Description',
                            style: TextStyle(
                              color: Colors.black.withOpacity(.7),
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
                        child: Text(
                          _diet.longDescription,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Diet Meals',
                            style: TextStyle(
                              color: Colors.black.withOpacity(.7),
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
                        height: 260,
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: _meals
                              .map(
                                (meal) => MealCard(
                                  height: _height,
                                  meal: meal,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      SizedBox(
                        height: 50,
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
}
