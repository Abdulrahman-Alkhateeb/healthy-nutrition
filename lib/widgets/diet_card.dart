import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:healthy_nutrition/models/diet.dart';
import 'package:healthy_nutrition/providers/diets.dart';
import 'package:healthy_nutrition/providers/info.dart';
import 'package:healthy_nutrition/screens/diets/diet_details_screen.dart';
import 'package:healthy_nutrition/utils/color_palette.dart';
import 'package:healthy_nutrition/utils/server_info.dart';
import 'package:provider/provider.dart';

class DietCard extends StatefulWidget {
  final Diet diet;
  final double height;
  final bool fromFavs;

  DietCard({
    @required this.diet,
    @required this.height,
    @required this.fromFavs,
    Key key,
  }) : super(
          key: key,
        );

  @override
  _DietCardState createState() => _DietCardState();
}

class _DietCardState extends State<DietCard> {
  bool _isFav = false, _firstTime = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _isFav = Provider.of<Info>(
        context,
        listen: false,
      ).user.favDiets.contains(
            widget.diet.dietId,
          );
      if (widget.fromFavs) _isFav = true;
      _firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(DietDetailsScreen.routeName, arguments: {
          'diet': widget.diet,
          'fromFavs': widget.fromFavs,
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
              tag: widget.fromFavs ? widget.diet.dietId : widget.diet.id,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: widget.height / 1.89818181818181825,
                ),
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/loading.gif'),
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    '${ServerInfo.DIETS_IMAGES}/${widget.diet.image}',
                  ),
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
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            widget.diet.name,
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
                            widget.diet.type,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.diet.shortDescription,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
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
                    bool _result = await Provider.of<Diets>(
                      context,
                      listen: false,
                    ).removeDietFromFavourites(
                      userId: _userId,
                      dietId: widget.diet.dietId.toString(),
                    );
                    if (_result)
                      setState(() {
                        _isFav = false;
                      });
                  } else {
                    bool _result = await Provider.of<Diets>(
                      context,
                      listen: false,
                    ).setDietAsFavourite(
                      userId: _userId,
                      dietId: widget.diet.dietId.toString(),
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
}
