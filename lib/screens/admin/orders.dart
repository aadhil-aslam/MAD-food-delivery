import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../services/firebase_services.dart';
import 'admin_order_detail.dart';

class AdminOrders extends StatefulWidget {
  const AdminOrders({Key? key}) : super(key: key);

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  final FirebaseServices _firebaseServices = FirebaseServices();

  @override
  void initState() {
    getTotalOrders();
    super.initState();
  }

  int total = 0;

  Future<int> TotalOrders(String id) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Orders")
        .doc(id)
        .collection("Items")
        .get();
    if (snapshot.docs.isNotEmpty) {
      // Exist
      // setState(() {
      total = snapshot.docs.length;
      // });
      print(total);
    } else {
      total = 0;
    }
    return total;
  }

  Future getTotalOrders() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Cart")
        .get();
    if (snapshot.docs.isNotEmpty) {
      // Exist
      setState(() {
        total = snapshot.docs.length;
      });
    } else {
      total = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
              future: _firebaseServices.orderRef
                  .orderBy("orderDate", descending: true)
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
                  return ListView(
                    padding: const EdgeInsets.only(top: 118.0, bottom: 12.0),
                    children: snapshot.data!.docs.map((document) {
                      Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                      bool pending = data['status'] == "Order Placed";

                      bool accepted = data['status'] == "Accepted";

                      bool canceled = data['status'] == "Cancelled";

                      bool delivered = data['status'] == "Delivered";

                      return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_)=> AdminOrderPage(productId: data!['orderId'], uid: data!['customerId']))).then((value){
                              setState(() {
                              });
                            });
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
                                    style: const TextStyle(
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
                                          : delivered
                                          ? Colors.grey.shade600
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
                              )));
                    }).toList(),
                  );
                }

                // Loading state
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }),
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
                  child: Text("Orders", style: Constants.boldHeading),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
