import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../constants.dart';
import '../screens/cart_page.dart';
import '../screens/map.dart';
import '../services/firebase_services.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  FirebaseServices _firebaseServices = FirebaseServices();

  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 54.0, 24.0, 24.0),
      child: Row(
        children: [
          Expanded(
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              //key: Key(_uid),
              future: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //print(snapshot.data?.data()?['username']);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(snapshot.data!['name'].split(" ").elementAt(0),
                          style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CurrentLocationScreen(
                                    hasBackArrow: true,
                                  )))
                              .then((value) {
                            setState(() {});
                          });
                        },
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                snapshot.data!['Address'],
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }
                return Text("Welcome", style: Constants.boldHeading);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartPage()));
                },
                child: StreamBuilder(
                  stream: _usersRef
                      .doc(_firebaseServices.getUserId())
                      .collection("Cart")
                      .snapshots(),
                  builder: (context, snapshot) {
                    num _totalItems = 0;
                    //num totalPrice = 0;

                    if (snapshot.connectionState == ConnectionState.active) {
                      List _documents = snapshot.data!.docs;
                      _totalItems = _documents.length;

                      // for (var result in snapshot.data!.docs) {
                      //   _totalItems = _totalItems + result.data()['quantity'];
                      //   totalPrice = _totalItems;
                      //
                      // }
                      // print('total price: $totalPrice');

                    }
                    return Badge(
                      //toAnimate: false,
                      position: BadgePosition.topEnd(top: -15, end: -10),
                      padding: EdgeInsets.all(8),
                      showBadge: _totalItems == 0 ? false : true,
                      animationType: BadgeAnimationType.scale,
                      animationDuration: Duration(milliseconds: 100),
                      badgeContent: Text(
                        _totalItems.toString() ?? "0",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      child: Container(
                          width: 42.0,
                          height: 42.0,
                          decoration: BoxDecoration(
                              color:
                                  //_totalItems == 0 ?
                                  Colors.black,
                              //: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(8.0)),
                          alignment: Alignment.center,
                          child: Icon(
                            Ionicons.cart,
                            color: Colors.white,
                          )),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
