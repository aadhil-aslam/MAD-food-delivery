import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/product_card.dart';
import '../../widgets/product_list.dart';
import '../constants.dart';

class Carousel extends StatefulWidget {
  const Carousel({Key? key}) : super(key: key);

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final CollectionReference _productRef =
      FirebaseFirestore.instance.collection("Products");

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      child: FutureBuilder<QuerySnapshot>(
          future: _productRef.get(),
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
              return CarouselSlider(
                options: CarouselOptions(
                  //autoPlayInterval: Duration(milliseconds: 3000),
                  //autoPlay: true,
                  height: 250.0,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  viewportFraction: 0.9,
                  aspectRatio: 1.0,
                  initialPage: 0,
                ),
                items: snapshot.data!.docs.map<Widget>((document) {
                  Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

                  return Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
                      height: 250,
                      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                      child: Stack(
                        children: [
                          Container(
                            height: 350,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.network(
                                  data['images'][0],
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                gradient: LinearGradient(
                                    begin: Alignment(0, 1),
                                    end: Alignment(0, 0),
                                    // begin: Alignment.bottomCenter,
                                    // end: Alignment.topCenter,
                                    // stops: [
                                    //   0.0,
                                    //   0.5
                                    // ],
                                    colors: [
                                      Colors.black.withOpacity(0.9),
                                      Colors.black.withOpacity(0.0)
                                    ]),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    data['name'] ?? "Name",
                                    style: Constants.regularHeadingWhite,
                                  ),
                                  Text("LKR ${data['price']}" ?? "Price",
                                      style: Constants.regularHeadingWhite
                                    // TextStyle(
                                    //     fontSize: 18.0,
                                    //     color: Theme.of(context)
                                    //         .colorScheme
                                    //         .secondary,
                                    //     fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    //Text("Name: ${data['name']}"),
                  );
                }).toList(),
              );
              ListView(
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
          }),
    );
  }
}
