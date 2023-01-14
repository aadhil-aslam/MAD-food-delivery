import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../screens/product_page.dart';

class ProductList extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  final String desc;
  final int price;
  final String productId;
  final String imageUrl;
  ProductList(
      {required this.title,
      this.onPressed,
      required this.price,
      required this.productId,
      required this.imageUrl,
      required this.desc});

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
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 1,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            bottomLeft: Radius.circular(6)),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          //placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                        // Image.network(
                        //   imageUrl ?? '',
                        //   width: 130,
                        //   height: 130,
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                        maxLines: 2,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 2.0)),
                      Text(desc,
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                          maxLines: 2),
                      const Padding(padding: EdgeInsets.only(top: 10.0)),
                      Text("LKR $price" ?? "Price",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                          maxLines: 1),
                    ],
                  ),
                ),
              ),
              // const Icon(
              //   Icons.more_vert,
              //   size: 16.0,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
