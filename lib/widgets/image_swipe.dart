import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageSwipe extends StatefulWidget {
  final List imageList;
  ImageSwipe({required this.imageList});

  @override
  State<ImageSwipe> createState() => _ImageSwipeState();
}

class _ImageSwipeState extends State<ImageSwipe> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400.0,
        child: Stack(
          children: [
            PageView(
              onPageChanged: (num) {
                setState(() {
                  _selectedPage = num;
                });
              },
              children: [
                for (var i = 0; i < widget.imageList.length; i++)
                  CachedNetworkImage(
                    imageUrl: "${widget.imageList[i]}",
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                  // Image.network(
                  //   "${widget.imageList[i]}",
                  //   fit: BoxFit.cover,
                  // )
              ],
            ),
            Positioned(
              bottom: 20.0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < widget.imageList.length; i++)
                    AnimatedContainer(
                      duration: Duration(
                        milliseconds: 300,),
                      curve: Curves.easeOutCubic,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      width: _selectedPage == i ? 35.0 : 10.0,
                      height: 10.0,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12.0)
                      ),
                    )
                ],
              ),
            )
          ],
        )
    );
  }
}
