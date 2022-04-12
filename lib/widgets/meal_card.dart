import 'package:flutter/material.dart';
import 'package:healthy_nutrition/models/meal.dart';
import 'package:healthy_nutrition/screens/diets/meal_details_screen.dart';
import 'package:healthy_nutrition/utils/server_info.dart';

class MealCard extends StatefulWidget {
  const MealCard({
    Key key,
    @required this.height,
    @required this.meal,
  });

  final double height;
  final Meal meal;

  @override
  _MealCardState createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(MealDetailsScreen.routeName, arguments: {
          'meal': widget.meal,
        });
      },
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: 350,
          width: 350,
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: 200,
                                ),
                                padding: const EdgeInsets.all(
                                  10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  widget.meal.title,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(
                                  10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  widget.meal.calories.toString() + 'Cals',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
