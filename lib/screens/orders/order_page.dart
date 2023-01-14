import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/services/firebase_services.dart';

class OrderPage extends StatefulWidget {
  final String productId;

  OrderPage({required this.productId});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  void initState() {
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
                      future: _firebaseServices.userOrderRef
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
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 10.0),
            child: FutureBuilder<DocumentSnapshot>(
                future:
                    _firebaseServices.userOrderRef.doc(widget.productId).get(),
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
                    bool pending = snapshot.data!['status'] == "Order Placed";

                    bool accepted = snapshot.data!['status'] == "Accepted";

                    bool canceled = snapshot.data!['status'] == "Cancelled";

                    bool delivered = snapshot.data!['status'] == "Delivered";

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          pending || accepted || delivered
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.grey.shade300),
                                    child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 5),
                                        child: Text("Order Placed",
                                            //"${snapshot.data!['status']}",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ))),
                                  ),
                                )
                              : canceled
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.red),
                                        child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.0, vertical: 5),
                                            child: Text("Cancelled",
                                                //"${snapshot.data!['status']}",
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ))),
                                      ),
                                    )
                                  : const SizedBox(
                                      height: 20,
                                    ),
                          accepted || delivered
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Container(
                                          height: 5,
                                          width: 5,
                                          decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Container(
                                          height: 5,
                                          width: 5,
                                          decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.green.shade600),
                                          child: const Padding(
                                              padding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 5),
                                              child: Text("Accepted",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(
                                  height: 20,
                                ),
                          delivered
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Container(
                                          height: 5,
                                          width: 5,
                                          decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Container(
                                          height: 5,
                                          width: 5,
                                          decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.green.shade700),
                                          child: const Padding(
                                              padding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 5),
                                              child: Text("Delivered",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(
                                  height: 20,
                                ),
                        ],
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                }),
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
                future: _firebaseServices.userOrderRef
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
                                  ));
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 300.0,
                          child: FutureBuilder<DocumentSnapshot>(
                              future: _firebaseServices.userOrderRef
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
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Divider(
                                            color: Colors.black38,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.receipt_long),
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
