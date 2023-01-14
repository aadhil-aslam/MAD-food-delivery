import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/screens/product_page.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../services/firebase_services.dart';
import 'map.dart';
import 'orders/order_placed.dart';

enum PaymentType { Cash, Card }

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedPaymenType = 'Cash';

  PaymentType? _paymentType = PaymentType.Card;

  final FirebaseServices _firebaseServices = FirebaseServices();

  int total = 0;
  String address = "Address";
  String name = "name";
  String dateTime = "now";

  Future _noAddressAlert() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Container(child: const Text("Select location before order")),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: const Text("Ok"))
            ],
          );
        });
  }

  _fetchAddress() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(_firebaseServices.getUserId())
          .get()
          .then((ds) {
        address = ds.data()!['Address'];
        name = ds.data()!['name'];
        setState(() {});
      }).catchError((e) {});
    } else {
      address = 'Address';
    }
  }

  Future _fetchTotal() async {
    await _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .get()
        .then((ds) {
      setState(() {
        total = (ds.data()! as Map)['cartTotal'] + 250;
      });
      print(total);
    }).catchError((e) {});
  }

  int totalOrderItems = 0;

  Future getCartItems(docId) async {
    String name = "name";
    String price = "price";
    String quantity = "quantity";
    String size = "size";

    await _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .get()
        .then(
      (querySnapshot) async {
        for (var result in querySnapshot.docs) {
          setState(() {
            totalOrderItems = querySnapshot.docs.length;
          });
          name = result.data()['name'];
          price = result.data()['price'].toString();
          quantity = result.data()['quantity'].toString();
          size = result.data()['size'];

          await _firebaseServices.usersRef
              .doc(_firebaseServices.getUserId())
              .collection("Orders")
              .doc(docId)
              .collection("Items")
              .add({
            "quantity": quantity,
            "name": name,
            "price": price,
            "size": size,
          });

          await _firebaseServices.orderRef.doc(docId).update({
            "items": totalOrderItems,
          });

          await _firebaseServices.usersRef
              .doc(_firebaseServices.getUserId())
              .collection("Orders")
              .doc(docId).update({
            "items": totalOrderItems,
          });
        }
      },
    );
  }

  String docId = "docId";

  Future _orderFunctions() async {
    var startFormat = DateFormat('dd.MM.yyyy hh:mm a');
    var Date = startFormat.format(DateTime.now());
    print(Date);

    _fetchAddress();
    DocumentReference docRef = await _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Orders")
        .add({
      "total": total,
      "orderDate": Date,
      "Address": address,
      "status": "Order Placed",
      "payment": selectedPaymenType,
      "items": totalOrderItems,
    });

    docId = docRef.id;

    print(docId);

    getCartItems(docId);

    dateTime = DateTime.now().toString();

    //DocumentReference orderColRef =
    await _firebaseServices.orderRef.doc(docId).set({
      "total": total,
      "orderDate": Date,
      "name": name,
      "customerId": _firebaseServices.getUserId(),
      "orderId": docId,
      "address": address,
      "status": "Order Placed",
      "payment": selectedPaymenType,
      "items": totalOrderItems,
    });

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => OrderPlaced(docId: docId)));
  }

  @override
  void initState() {
    _fetchAddress();
    _fetchTotal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 54.0, 24.0, 10.0),
            child: Row(
              children: [
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
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      )),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text("Checkout", style: Constants.boldHeading),
                ),
              ],
            ),
          ),
          SizedBox(
              height: 200,
              child: CurrentLocationScreen(
                onSelected: (String) {
                  address = String;
                },
              )),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
                future: _firebaseServices.cartRef.get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    Scaffold(
                      body: Center(
                        child: Text("Error: ${snapshot.error}"),
                      ),
                    );
                  }

                  // Collection data ready to display
                  if (snapshot.connectionState == ConnectionState.done) {
                    // Display the data inside a list view
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView(
                            children: snapshot.data!.docs.map((document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;

                              int priceFinal =
                                  data!['price'] * data!['quantity'];

                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductPage(
                                                productId: document.id)));
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: ListTile(
                                        leading: Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "${data!['quantity']}",
                                              ),
                                            )),
                                        title: Text("${data!['name']}",
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            )),
                                        subtitle: Text("${data!['size']}"),
                                        trailing: Text("LKR $priceFinal",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            )),
                                      )));
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  }

                  // Loading state
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }),
          ),
          const Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 0.0, 0.0, 0),
            child: Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    'Pay on delivery:',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Radio(
                        value: "Cash",
                        groupValue: selectedPaymenType,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymenType = value!;
                          });
                        },
                      ),
                      const Expanded(child: Text('Cash'))
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Radio(
                        value: "Card",
                        groupValue: selectedPaymenType,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymenType = value!;
                          });
                        },
                      ),
                      const Expanded(child: Text('Card'))
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          SizedBox(
            height: 50.0,
            child: FutureBuilder<DocumentSnapshot>(
                future: _firebaseServices.usersRef
                    .doc(_firebaseServices.getUserId())
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    Scaffold(
                      body: Center(
                        child: Text("Error: ${snapshot.error}"),
                      ),
                    );
                  }

                  // Collection data ready to display
                  if (snapshot.connectionState == ConnectionState.done) {
                    total = snapshot.data!['cartTotal'] + 250;

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                              child: Text(
                            "Sub Total",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          )),
                          Text(
                            "${snapshot.data!['cartTotal']}",
                            style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                    child: Text(
                  "Delivery Charge",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                )),
                Text(
                  "250",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                    child: Text(
                  "Total",
                  style: Constants.regularHeading,
                )),
                Text(
                  "$total",
                  style: Constants.regularHeading,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: GestureDetector(
              onTap: () async {
                address != "Address"
                    ?
                    //print("Ok")
                    _orderFunctions()
                    : _noAddressAlert();
              },
              child: Container(
                height: 65.0,
                //margin: EdgeInsets.only(left: 16.0),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12.0)),
                child: Text(
                  "Place Order",
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
      ),
    );
  }
}
