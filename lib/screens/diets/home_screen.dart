import 'package:flutter/material.dart';
import 'package:healthy_nutrition/models/diet.dart';
import 'package:healthy_nutrition/providers/diets.dart';
import 'package:healthy_nutrition/widgets/custom_app_bar.dart';
import 'package:healthy_nutrition/widgets/custom_bottom_bar.dart';
import 'package:healthy_nutrition/widgets/custom_drawer.dart';
import 'package:healthy_nutrition/widgets/diet_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Diet> _diets = [];
  double _height;
  bool _firstTime = true, _isLoading = true;

  Future<void> _getDiets() async {
    _diets = await Provider.of<Diets>(
      context,
      listen: false,
    ).recommendedDiets(
      context: context,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;
      _getDiets();

      _firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Recommended Diets',
      ),
      drawer: CustomDrawer(),
      bottomNavigationBar: CustomBottomBar(
        index: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                physics: BouncingScrollPhysics(),
                children: _diets
                    .map(
                      (diet) => DietCard(
                        diet: diet,
                        height: _height,
                        fromFavs: false,
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
