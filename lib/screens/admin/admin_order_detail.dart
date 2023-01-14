import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/services/firebase_services.dart';

class AdminOrderPage extends StatefulWidget {
  final String productId;
  final String uid;

  AdminOrderPage({required this.productId, required this.uid});

  @override
  State<AdminOrderPage> createState() => _AdminOrderPageState();
}

class _AdminOrderPageState extends State<AdminOrderPage> {
  final FirebaseServices _firebaseServices = FirebaseServices();

  @override
  void initState() {
    super.initState();
    _fetchId();
  }

  String orderId = "0";

  _fetchId() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance.collection("Users")
          .doc(widget.uid)
          .collection("Orders")
          .doc(widget.productId)
          .get()
          .then((ds) {
        orderId = ds.id;
        print("Order id = $orderId");
      }).catchError((e) {});
    } else {
      orderId = 'orderId';
    }
  }

  cancelOrder() async {
    /// update order
    await _firebaseServices.orderRef.doc(orderId).update({
      'status': 'Cancelled',
    });

    /// update user
    await FirebaseFirestore.instance.collection("Users")
        .doc(widget.uid)
        .collection("Orders")
        .doc(widget.productId).update({
      "status": "Cancelled",
    });
  }

  acceptOrder() async {
    /// update order
    await _firebaseServices.orderRef.doc(orderId).update({
      'status': 'Accepted',
    });

    /// update user
    await FirebaseFirestore.instance.collection("Users")
        .doc(widget.uid)
        .collection("Orders")
        .doc(widget.productId).update({
      "status": "Accepted",
    });
  }

  deliverOrder() async {
    /// update order
    await _firebaseServices.orderRef.doc(orderId).update({
      'status': 'Delivered',
    });

    /// update user
    await FirebaseFirestore.instance.collection("Users")
        .doc(widget.uid)
        .collection("Orders")
        .doc(widget.productId).update({
      "status": "Delivered",
    });
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection("Users")
                          .doc(widget.uid)
                          .collection("Orders")
                          .doc(widget.productId)
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
                          return Text("${snapshot.data!['orderDate']}",
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600));
                        }
                        return const CircularProgressIndicator();
                      }),
                ]),
          ),
          // CustomActionBar(
          //   hasTitle: false,
          //   hasCart: false,
          //   hasBackArrow: true,
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 14.0, 0.0, 10.0),
            child: StreamBuilder<DocumentSnapshot>(
                stream:
                FirebaseFirestore.instance.collection("Users")
                    .doc(widget.uid)
                    .collection("Orders")
                    .doc(widget.productId)
                    .snapshots(),
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
                    bool pending = snapshot.data!['status'] == "Order Placed";

                    bool accepted = snapshot.data!['status'] == "Accepted";

                    bool canceled = snapshot.data!['status'] == "Cancelled";

                    bool delivered = snapshot.data!['status'] == "Delivered";

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: pending ? Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    acceptOrder();
                                  },
                                  child: Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: Colors.green.shade500,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 2.0,
                                            spreadRadius: 1.0,
                                            offset: Offset(2.0,
                                                2.0), // shadow direction: bottom right
                                          )
                                        ],
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Center(
                                            child: Text(
                                          "Accept",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        )),
                                      )),
                                ),
                              )),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 28.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      cancelOrder();
                                    },
                                    child: Container(
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Colors.red.shade400,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 2.0,
                                              spreadRadius: 1.0,
                                              offset: Offset(2.0,
                                                  2.0), // shadow direction: bottom right
                                            )
                                          ],
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Center(
                                              child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          )),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ) : canceled ? Padding(
                            padding: const EdgeInsets.only(
                                right: 30.0, left: 20),
                            child: Container(
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(8.0),
                                  color: Colors.red.shade500,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 2.0,
                                      spreadRadius: 1.0,
                                      offset: Offset(2.0,
                                          2.0), // shadow direction: bottom right
                                    )
                                  ],
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Center(
                                      child: Text("Cancelled",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      )),
                                )),
                          ) : Padding(
                            padding: const EdgeInsets.only(
                                right: 30.0, left: 20),
                            child: GestureDetector(
                              onTap: () { delivered ? null :
                                deliverOrder();
                              },
                              child: Container(
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                    color: delivered ? Colors.grey.shade600 : Colors.green.shade700,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 2.0,
                                        spreadRadius: 1.0,
                                        offset: Offset(2.0,
                                            2.0), // shadow direction: bottom right
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Center(
                                        child: Text(delivered ? "Delivered" :
                                          "Deliver",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        )),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                }),
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection("Users")
                    .doc(widget.uid)
                    .collection("Orders")
                    .doc(widget.productId)
                    .collection("Items")
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
                    // Display the data inside a list view
                    return Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.only(top: 1.0, bottom: 12.0),
                            children: snapshot.data!.docs.map((document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;

                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
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
                                            data!['quantity'],
                                          ),
                                        )),
                                    title: Text(data!['name'],
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        )),
                                    trailing: Text(data!['size']),
                                    // trailing: Text('$priceFinal',
                                    //     style: TextStyle(
                                    //       fontWeight: FontWeight.w500,
                                    //     )),
                                  ));
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 360.0,
                          child: FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance.collection("Users")
                                  .doc(widget.uid)
                                  .collection("Orders")
                                  .doc(widget.productId)
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
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30.0, 20.0, 30.0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Divider(
                                            color: Colors.black38,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.receipt_long),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text(
                                              "Total : ",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                                "LKR ${snapshot.data!['total']}",
                                                style: const TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black)),
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Divider(
                                            color: Colors.black38,
                                          ),
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              const Icon(Icons.article_outlined),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Text(
                                                "Order ID : ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14.0),
                                              ),
                                              Text(
                                                  widget.productId,
                                                  style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Divider(
                                            color: Colors.black38,
                                          ),
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              const Icon(Icons.person),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Text(
                                                "User ID : ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14.0),
                                              ),
                                              Text(
                                                  widget.uid,
                                                  style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Divider(
                                            color: Colors.black38,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                                "${snapshot.data!['payment']}" ==
                                                        "Cash"
                                                    ? Icons.payments
                                                    : Icons.payment),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text(
                                              "Payment : ",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            ),
                                            Text("${snapshot.data!['payment']}",
                                                style: const TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black)),
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Divider(
                                            color: Colors.black38,
                                          ),
                                        ),
                                        Row(
                                          children: const [
                                            Icon(Icons.home_outlined),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Address : ",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 35.0),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                                "${snapshot.data!['Address']}",
                                                style: const TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return const Scaffold(
                                  body: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }),
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
        ],
      ),
    );
  }
}
