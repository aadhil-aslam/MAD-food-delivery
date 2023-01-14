import 'package:flutter/material.dart';

import '../constants.dart';
import '../screens/product_page.dart';

class ProductCard extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  final int price;
  final String productId;
  final String imageUrl;
  ProductCard(
      {required this.title,
      this.onPressed,
      required this.price,
      required this.productId,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductPage(
                      productId: productId,
                      productName: title,
                      productPrice: price,
                      imageUrl: imageUrl,
                    )));
      },
      child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
          height: 250,
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Stack(
            children: [
              Container(
                height: 350,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      imageUrl,
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
                        title ?? "Name",
                        style: Constants.regularHeadingWhite,
                      ),
                      Text("LKR $price" ?? "Price",
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
          ),
    );
  }
}
