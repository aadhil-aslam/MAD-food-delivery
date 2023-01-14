import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/product_list.dart';

class Beverages extends StatefulWidget {
  const Beverages({Key? key}) : super(key: key);

  @override
  State<Beverages> createState() => _BeveragesState();
}

class _BeveragesState extends State<Beverages> {
  final CollectionReference _productRef =
      FirebaseFirestore.instance.collection("Products");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: _productRef
            .where('type', isEqualTo: 'Beverages').get(),
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
              padding: EdgeInsets.symmetric(horizontal: 8),

              //padding: EdgeInsets.only(top: 108.0, bottom: 12.0),
              children: snapshot.data!.docs.map<Widget>((document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return ProductList(
                  title: data['name'],
                  price: data['price'],
                  productId: document.id,
                  imageUrl: data['images'][0],
                  desc: data['desc'],
                );
              }).toList(),
            );
          }

          // Loading state
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        });
  }
}