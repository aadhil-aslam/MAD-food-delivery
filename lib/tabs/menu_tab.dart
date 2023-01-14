import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/constants.dart';
import 'package:food_delivery/services/firebase_services.dart';
import 'package:food_delivery/widgets/custom_input.dart';

import '../screens/catogeries/appetizers.dart';
import '../screens/catogeries/beverages.dart';
import '../screens/catogeries/desserts.dart';
import '../screens/catogeries/pastas.dart';
import '../screens/catogeries/pizzas.dart';
import '../screens/catogeries/rice.dart';
import '../widgets/custom_action_bar.dart';
import '../widgets/product_card.dart';

class MenuTab extends StatefulWidget {
  @override
  State<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  FirebaseServices _firebaseServices = FirebaseServices();

  int selectedPage = 0;
  late PageController _pageController;

  List<Category> vehicles = <Category>[
    const Category('Pizzas', Icons.local_pizza),
    const Category('Pastas', Icons.dinner_dining),
    const Category('Appetizers', Icons.bakery_dining_rounded),
    const Category('Rice', Icons.rice_bowl),
    const Category('Desserts', Icons.brunch_dining_rounded),
    const Category('Beverages', Icons.emoji_food_beverage_rounded)
  ];

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            CustomActionBar(
              title: "Menu",
            ),
        Container(
          padding: EdgeInsets.fromLTRB(
            24,
            0,
            24,
            15,
          ),
          height: 60,
          child: ListView.builder(
              itemCount: vehicles.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPage = index;
                        _pageController.animateToPage(index,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.fastLinearToSlowEaseIn);
                      });
                    },
                    child: AnimatedContainer(
                      //margin: const EdgeInsets.only(right: 16, bottom: 16),
                      margin: EdgeInsets.symmetric(
                          vertical: selectedPage == index ? 0 : 8,
                          horizontal: selectedPage == index ? 0 : 20),
                      padding: EdgeInsets.symmetric(
                          vertical: selectedPage == index ? 8 : 0,
                          horizontal: selectedPage == index ? 20 : 0),
                      alignment: Alignment.center,
                      // width: 120,
                      // height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: selectedPage == index
                              ? Colors.black87
                              : Colors.transparent),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: Row(
                        children: [
                          Icon(
                            vehicles[index].icon,
                            color: selectedPage == index
                                ? Colors.white
                                : Colors.black87,
                          ),
                          SizedBox(width: 10),
                          Text(
                            vehicles[index].name,
                            style: TextStyle(
                                color: selectedPage == index
                                    ? Colors.white
                                    : Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ));
              }),
        ),
        Expanded(
          child: PageView(
            onPageChanged: (int page) {
              setState(() {
                selectedPage = page;
              });
            },
            controller: _pageController,
            children: [
              Pizzas(),
              Pastas(),
              Appetizers(),
              Rice(),
              Desserts(),
              Beverages()],
          ),
        ),
      ],
    ));
  }
}

class Category {
  const Category(this.name, this.icon);

  final String name;
  final IconData icon;
}
