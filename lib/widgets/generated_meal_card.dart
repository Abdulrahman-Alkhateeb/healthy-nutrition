import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:healthy_nutrition/models/generated_meal.dart';
import 'package:healthy_nutrition/models/meal.dart';
import 'package:healthy_nutrition/providers/info.dart';
import 'package:healthy_nutrition/providers/meals.dart';
import 'package:healthy_nutrition/screens/diets/meal_details_screen.dart';
import 'package:healthy_nutrition/utils/color_palette.dart';
import 'package:healthy_nutrition/utils/enums.dart';
import 'package:healthy_nutrition/utils/server_info.dart';
import 'package:provider/provider.dart';

class GeneratedMealCard extends StatefulWidget {
  final GeneratedMeal meal;
  final double height;
  final bool canEdit;

  GeneratedMealCard({
    @required this.meal,
    @required this.height,
    this.canEdit,
    Key key,
  }) : super(
          key: key,
        );

  @override
  _GeneratedMealCardState createState() => _GeneratedMealCardState();
}

class _GeneratedMealCardState extends State<GeneratedMealCard> {
  bool _isFav = false, _firstTime = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      List<Meal> _favMeals = Provider.of<Info>(
        context,
        listen: false,
      ).user.favMeals;

      _favMeals.forEach((meal) {
        if (meal.mealId == widget.meal.mealId) {
          _isFav = true;
        }
      });
      _firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(MealDetailsScreen.routeName, arguments: {
          'meal': widget.meal,
          'canEdit': widget.canEdit,
        });
      },
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Hero(
              tag: widget.meal.id,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: widget.height / 1.89818181818181825,
                ),
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      '${ServerInfo.MEALS_IMAGES}/${widget.meal.image}'),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: widget.height / 1.89818181818181825,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 260,
                          ),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            widget.meal.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _mealType(
                              type: widget.meal.type,
                            ),
                            style: TextStyle(
                              color: ColorPalette.PRIMARY_COLOR,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: InkWell(
                onTap: () async {
                  String _userId = Provider.of<Info>(
                    context,
                    listen: false,
                  ).user.id;

                  if (_isFav) {
                    bool _result = await Provider.of<Meals>(
                      context,
                      listen: false,
                    ).removeMealFromFavourites(
                      userId: _userId,
                      context: context,
                      mealId: widget.meal.mealId.toString(),
                    );
                    if (_result)
                      setState(() {
                        _isFav = false;
                      });
                  } else {
                    bool _result = await Provider.of<Meals>(
                      context,
                      listen: false,
                    ).setMealAsFavourite(
                      userId: _userId,
                      context: context,
                      mealId: widget.meal.mealId.toString(),
                    );
                    if (_result)
                      setState(() {
                        _isFav = true;
                      });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.8),
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: Center(
                    child: Icon(
                      _isFav
                          ? FlutterIcons.heart_ent
                          : FlutterIcons.heart_outlined_ent,
                      color: ColorPalette.PRIMARY_COLOR,
                      size: 30,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _mealType({
    @required GeneratedMealType type,
  }) {
    switch (type) {
      case GeneratedMealType.Breakfast:
        return 'Breakfast';
      case GeneratedMealType.Lunch:
        return 'Lunch';
      case GeneratedMealType.Dinner:
      default:
        return 'Dinner';
    }
  }
}
