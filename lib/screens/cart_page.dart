import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/screens/product_page.dart';
import 'package:food_delivery/services/firebase_services.dart';
import 'package:food_delivery/widgets/custom_action_bar.dart';
import 'package:ionicons/ionicons.dart';

import '../constants.dart';
import 'checkout_page.dart';
import 'map.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  int number = 1;
  num totalPrice = 0;
  String subtotal = "0";

  _snackBar() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Product removed from cart")));
  }

  Future _alertDialogBuilder(id) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Remove item"),
            content: Container(child: Text("Item will be removed from cart")),
            actions: [
              TextButton(
                  onPressed: () {
                    deleteFromCart(id);
                    Navigator.pop(context);
                    _snackBar();
                  },
                  child: Text("Remove")),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"))
            ],
          );
        });
  }

  Future _noItemsAlert() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(child: Text("No items in cart")),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Ok"))
            ],
          );
        });
  }

  Future deleteFromCart(id) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Cart")
        .doc(id)
        .delete();
    getTotalPrice();
  }

  Future increaseQuantity(id) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Cart")
        .doc(id)
        .get()
        .then((ds) {
      number = ds.data()!['quantity'];
    });
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Cart")
        .doc(id)
        .update({
      'quantity': number + 1,
    });
    getTotalPrice();
  }

  Future decreaseQuantity(id) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Cart")
        .doc(id)
        .get()
        .then((ds) {
      number = ds.data()!['quantity'];
    });
    number != 1
        ? await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Cart")
            .doc(id)
            .update({
            'quantity': number - 1,
          })
        : null;
    getTotalPrice();
  }

  Future getTotalPrice() async {
    num sum = 0;
    num total = 0;
    final snapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Cart")
        .get();
    if (snapshot.docs.isNotEmpty) {
      // Exist
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Cart")
          .get()
          .then(
        (querySnapshot) {
          for (var result in querySnapshot.docs) {
              sum = sum + result.data()!['price'] * result.data()!['quantity'];
              total = sum;
              totalPrice = total;
          }
          print('total price: $totalPrice');

          _firebaseServices.usersRef
              .doc(_firebaseServices.getUserId())
              .set({"cartTotal": totalPrice}, SetOptions(merge: true));
        },
      );
    } else {
      _firebaseServices.usersRef
          .doc(_firebaseServices.getUserId())
          .set({"cartTotal": 0}, SetOptions(merge: true));
    }
  }

  @override
  void initState() {
    getTotalPrice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _firebaseServices.cartRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Scaffold(
                    body: Center(
                      child: Text("Error: ${snapshot.error}"),
                    ),
                  );
                }

                // Collection data ready to display
                if (snapshot.connectionState == ConnectionState.active) {

                  List documents = snapshot.data!.docs;
                  int totalItems = documents.length;

                  // Display the data inside a list view
                  return totalItems != 0 ? Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.only(top: 108.0, bottom: 12.0),
                          children: snapshot.data!.docs.map((document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;

                            int priceFinal = data!['price'] * data!['quantity'];

                            return GestureDetector(
                                onLongPress: () {
                                  _alertDialogBuilder(document.id);
                                },
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductPage(
                                              productId: document.id)));
                                },
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 16, 24, 16),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // Icon(Icons.remove_circle_outline),
                                          // SizedBox(width: 20,),
                                          Container(
                                            width: 90,
                                            height: 90,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                "${data!['image']}",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(left: 16.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("${data!['name']}",
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                      )),
                                                  Text("${data!['size']}",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                      )),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                              "LKR $priceFinal",
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight: FontWeight.w600,
                                                                color: Theme.of(context).colorScheme.secondary,
                                                              )),
                                                          Row(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  decreaseQuantity(document.id);
                                                                  data!['quantity'] == 1
                                                                      ? _alertDialogBuilder(document.id) : null;
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 20,
                                                                  height: 20,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors.black26,
                                                                    borderRadius: BorderRadius.circular(4.0),
                                                                  ),
                                                                  child: Icon(
                                                                    Icons.remove,
                                                                    color: Colors.white,
                                                                    size: 15.0,
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal: 8.0),
                                                                child: Text(
                                                                    "${data!['quantity']}",
                                                                    style: TextStyle(
                                                                        fontSize: 16.0,
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Colors.black)),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  increaseQuantity(document.id);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 20,
                                                                  height: 20,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors.black87,
                                                                    borderRadius: BorderRadius.circular(4.0),
                                                                  ),
                                                                  child: Icon(
                                                                    Icons.add,
                                                                    color: Colors.white,
                                                                    size: 15.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                ],
                                              ),
                                            ),
                                          )
                                        ])));
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 65.0,
                        child: StreamBuilder<DocumentSnapshot>(
                            stream:  _firebaseServices.usersRef
                                .doc(_firebaseServices.getUserId()).snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                Scaffold(
                                  body: Center(
                                    child: Text("Error: ${snapshot.error}"),
                                  ),
                                );
                              }
                              // Collection data ready to display
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {

                                subtotal = "${snapshot.data!['cartTotal']}";

                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      30.0, 20.0, 30.0, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Text(
                                        "Subtotal",
                                        style: Constants.regularHeading,
                                      )),
                                      Text(
                                        "${snapshot.data!['cartTotal']}",
                                        style: Constants.regularHeading,
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Scaffold(
                                body: Center(child: CircularProgressIndicator()),
                              );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: GestureDetector(
                          onTap: () async {
                            subtotal != "0" ?
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    //CurrentLocationScreen()
                                        CheckoutPage()
                                ))
                            : _noItemsAlert();
                          },
                          child: Container(
                            height: 65.0,
                            //margin: EdgeInsets.only(left: 16.0),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12.0)),
                            child: Text(
                              "Checkout",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                    ],
                  ) : Center(child: Text("No Items In Cart", style: Constants.regularDarkText,));
                }

                // Loading state
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }),
          CustomActionBar(
            clickableCart: false,
            hasBackArrow: true,
            title: "Cart",
          ),
        ],
      ),
    );
  }
}
