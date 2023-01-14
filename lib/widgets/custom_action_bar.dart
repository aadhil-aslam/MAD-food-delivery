import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../constants.dart';
import '../screens/cart_page.dart';
import '../services/firebase_services.dart';

class CustomActionBar extends StatelessWidget {
  final String? title;
  final bool? hasBackArrow;
  final bool? hasTitle;
  final bool? hasCart;
  final bool? clickableCart;
  final bool? hasBackground;

  CustomActionBar({
    this.title,
    this.hasBackArrow,
    this.hasTitle,
    this.hasBackground,
    this.hasCart,
    this.clickableCart,
  });

  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("Users");

  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    bool _hasBackArow = hasBackArrow ?? false;
    bool _hasCart = hasCart ?? true;
    bool _clickableCart = clickableCart ?? true;
    bool _hasTitle = hasTitle ?? true;
    bool _hasBackground = hasBackground ?? true;

    return Container(
      decoration: BoxDecoration(
          gradient: _hasBackground
              ? LinearGradient(
                  colors: [Colors.white, Colors.white.withOpacity(0)],
                  begin: Alignment(0, 0),
                  end: Alignment(0, 1),
                )
              : null),
      padding: EdgeInsets.fromLTRB(24, 56, 24, 24
          //42
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_hasBackArow)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  width: 42.0,
                  height: 42.0,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 18,
                  )),
            ),
          if (_hasTitle)
            Text(title ?? "Action Bar", style: Constants.boldHeading),
          if (_hasCart)
            GestureDetector(
                onTap: () {
                  if(_clickableCart)
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
                    //   Stack(
                    //   children: [
                    //     Container(
                    //         alignment: Alignment.center,
                    //         child: Icon(
                    //           Ionicons.cart,
                    //           color: Colors.white,
                    //         )),
                    //     Container(
                    //       alignment: Alignment.center,
                    //       width: 25.0,
                    //       height: 25.0,
                    //       decoration: BoxDecoration(
                    //           color: Theme.of(context).colorScheme.secondary,
                    //           borderRadius: BorderRadius.circular(100.0)),
                    //       child: Text(
                    //         _totalItems.toString() ?? "0",
                    //         style: TextStyle(
                    //             fontSize: 16,
                    //             fontWeight: FontWeight.w600,
                    //             color: Colors.white),
                    //       ),
                    //     ),
                    //   ],
                    // );
                  },
                )),
        ],
      ),
    );
  }
}
