import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/constants.dart';
import 'package:food_delivery/services/firebase_services.dart';
import 'package:food_delivery/widgets/custom_input.dart';

import '../widgets/product_card.dart';

class SearchTab extends StatefulWidget {
  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String _searchString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        if (_searchString.isEmpty)
          Center(
            child: Text(
              "Search results",
              style: Constants.regularDarkText,
            ),
          )
        else
          FutureBuilder<QuerySnapshot>(
              future: _firebaseServices.productRef
                  .orderBy('search string')
                  .startAt([_searchString])
                  .endAt(["$_searchString\uf8ff"])
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
                    padding: EdgeInsets.only(top: 128.0, bottom: 12.0),
                    children: snapshot.data!.docs.map<Widget>((document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                        return ProductCard(
                          title: data['name'],
                          price: data['price'],
                          productId: document.id,
                          imageUrl: data['images'][0]);
                    }).toList(),
                  );
                }

                // Loading state
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }),
        Padding(
          padding: const EdgeInsets.only(top: 45.0),
          child: CustomInput(
            //isAutoFocus: true,
            hintText: "Search here",
            onSubmitted: (value) {
              setState(() {
                _searchString = value.toLowerCase();
              });
            },
          ),
        ),
      ],
    ));
  }
}
