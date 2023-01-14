import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/widgets/custom_action_bar.dart';
import 'package:food_delivery/widgets/product_size.dart';
import 'package:ionicons/ionicons.dart';

import '../constants.dart';
import '../services/firebase_services.dart';
import '../widgets/image_swipe.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  final String? productName;
  final int? productPrice;
  final String? imageUrl;
  ProductPage(
      {required this.productId,
        this.productName,
        this.productPrice,
        this.imageUrl});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  late bool exist;

  Future<bool> checkExist() async {
    try {
      await _firebaseServices.usersRef
          .doc(_firebaseServices.getUserId())
          .collection("Cart")
          .doc(widget.productId)
          .get()
          .then((doc) {
        exist = doc.exists;
      });
      print(exist);
      return exist;
    } catch (e) {
      // If any error
      print("error");
      return false;
    }
  }

  String _selectedPizzaSize = "S";
  String _extraPrice = "0";

  Future _cartFunctions() async {
    await _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(widget.productId)
        .set({
      "size": _selectedPizzaSize,
      "name": widget.productName,
      "price": widget.productPrice! + int.parse(_extraPrice),
      "image": widget.imageUrl,
      "quantity": 1,
    });
  }

  Future _addToCart() {
    return exist
        ? _addToExistCart()
        : _cartFunctions();
  }

  int number = 1;

  Future _addToExistCart() async {
    await _firebaseServices.usersRef
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Cart")
        .doc(widget.productId)
        .get()
        .then((ds) {
      number = ds.data()!['quantity'];
    });
    await _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(widget.productId)
        .update({
      "quantity": number + 1,
    });
  }

  Future _addToSaved() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Saved")
        .doc(widget.productId)
        .set({
      "size": _selectedPizzaSize,
    });
  }

  _snackBar() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Product added to cart")));
  }

  _savedSnackBar() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Product added to favourites")));
  }

  num index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            StreamBuilder(
                stream: _firebaseServices.productRef.doc(widget.productId).snapshots(),
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
                    // Firebase document data map
                    Map<String, dynamic> documentData =
                    snapshot.data?.data() as Map<String, dynamic>;

                    // List of images
                    List imageList = documentData['images'];

                    // List of product sizes
                    List pizzaSizes = documentData['size'];
                    List pizzaPrices = documentData['prices'];

                    // Set an initial size
                    _selectedPizzaSize = pizzaSizes[0];

                    return Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.all(0),
                            children: [
                              ImageSwipe(imageList: imageList),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 4.0, right: 24.0, left: 24.0, top: 24),
                                child: Text(
                                  "${documentData['name']}",
                                  style: Constants.boldHeading,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 24),
                                child: Text(
                                  "LKR ${documentData['price']}",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 24),
                                child: Text(
                                  "${documentData['desc']}",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 24.0, horizontal: 24),
                                child: Text(
                                  "Size",
                                  style: Constants.regularDarkText,
                                ),
                              ),
                              ProductSize(
                                pizzaSizes: pizzaSizes,
                                pizzaPrices: pizzaPrices,
                                onSelected: (size, extraPrice) {
                                  _selectedPizzaSize = size;
                                  _extraPrice = extraPrice;
                                  print(_extraPrice);
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await _addToSaved();
                                  _savedSnackBar();
                                },
                                child: Container(
                                    width: 65.0,
                                    height: 65.0,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFFDCDCDC),
                                        borderRadius: BorderRadius.circular(12.0)),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Ionicons.heart_outline,
                                      size: 25,
                                    )),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    await checkExist();
                                    _addToCart();
                                    _snackBar();
                                  },
                                  child: Container(
                                    height: 65.0,
                                    margin: EdgeInsets.only(left: 16.0),
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(12.0)),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Add To Cart",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  }

                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }),
            CustomActionBar(
              hasBackArrow: true,
              hasTitle: false,
              hasBackground: false,
            )
          ],
        ));
  }
}

