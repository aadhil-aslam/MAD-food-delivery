import 'package:flutter/material.dart';

class ProductSize extends StatefulWidget {
  final List pizzaSizes;
  final List? pizzaPrices;
  final Function(String, String) onSelected;
  ProductSize({required this.pizzaSizes, required this.onSelected, this.pizzaPrices});

  @override
  State<ProductSize> createState() => _ProductSizeState();
}

class _ProductSizeState extends State<ProductSize> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          for (var i = 0; i < widget.pizzaSizes.length; i++)
            GestureDetector(
              onTap: () {
                widget.onSelected(widget.pizzaSizes[i], widget.pizzaPrices![i]);
                setState(() {
                  _selected = i;
                });
              },
              child: Container(
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                    color: _selected == i ? Theme.of(context)
                        .colorScheme
                        .secondary : Color(0xFFFDCDCDC),
                  borderRadius: BorderRadius.circular(8.0)
                ),
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  "${widget.pizzaSizes[i]}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _selected == i ? Colors.white : Colors.black,
                    fontSize: 16.0
                  )
                ),
              ),
            ),
          Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: widget.pizzaPrices![_selected] != "0" ? Text(
                "+ ${widget.pizzaPrices![_selected]} LKR",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 16.0
                )
          ) : SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}
