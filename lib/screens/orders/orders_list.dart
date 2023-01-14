import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/screens/product_page.dart';
import 'package:food_delivery/services/firebase_services.dart';
import 'package:food_delivery/widgets/custom_action_bar.dart';
import 'package:ionicons/ionicons.dart';

import '../../constants.dart';
import '../checkout_page.dart';
import '../map.dart';
import 'order_page.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({Key? key}) : super(key: key);

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
              future: _firebaseServices.userOrderRef.orderBy("orderDate", descending: true).get(),
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
                  return ListView(
                    padding: EdgeInsets.only(top: 118.0, bottom: 12.0),
                    children: snapshot.data!.docs.map((document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      bool pending = data['status'] == "Order Placed";

                      bool accepted = data['status'] == "Accepted";

                      bool canceled = data['status'] == "Cancelled";

                      bool delivered = data['status'] == "Delivered";

                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OrderPage(productId: document.id)));
                          },
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: ListTile(
                                leading: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        data!['items'].toString(),
                                      ),
                                    )),
                                title: Text(data!['orderDate'],
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    )),
                                subtitle: Text("LKR ${data!['total']}"),
                                trailing: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: canceled
                                          ? Colors.red
                                          : pending
                                              ? Colors.grey.shade300
                                              : Colors.green.shade700),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 5),
                                    child: Text("${data!['status']}",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: pending ? Colors.black : Colors.white,
                                        )),
                                  ),
                                ),
                                // trailing: Text('$priceFinal',
                                //     style: TextStyle(
                                //       fontWeight: FontWeight.w500,
                                //     )),
                              )));
                    }).toList(),
                  );
                }

                // Loading state
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }),
          CustomActionBar(
            clickableCart: false,
            hasBackArrow: true,
            title: "Orders",
          ),
        ],
      ),
    );
  }
}
