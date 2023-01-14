import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/screens/orders/order_page.dart';
import 'package:food_delivery/screens/orders/orders_list.dart';
import 'package:food_delivery/screens/product_page.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../services/firebase_services.dart';
import '../../widgets/custom_action_bar.dart';
import '../map.dart';

class OrderPlaced extends StatefulWidget {
  final String docId;
  OrderPlaced({required this.docId});

  @override
  State<OrderPlaced> createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {

  String docId = "";

  @override
  void initState() {
    docId = widget.docId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 150.0, bottom: 40),
            child: Image.asset(
              "assets/images/5526265.jpg",
              height: MediaQuery.of(context).size.width / 1.5,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Column(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Text("Thank You!", style: Constants.boldHeading),
              ),
              Text("for your order",
                style: Constants.regularDarkText,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text("Your order is now bieng processed. "
                    "We will let you know once the order is picked up from the outlet."
                    "\nCheck the status of your Order",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 10.0),
                child: GestureDetector(
                  onTap: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => OrderPage(productId: docId)));
                  },
                  child: Container(
                    height: 65.0,
                    //margin: EdgeInsets.only(left: 16.0),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100.0)),
                    child: Text(
                      "Track My Order",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: GestureDetector(
                  onTap: () async {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Container(
                    height: 65.0,
                    //margin: EdgeInsets.only(left: 16.0),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Text(
                      "Back To Home",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
