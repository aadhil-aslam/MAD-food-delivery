import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String? text;
  final Function() onPressed;
  final bool? outlineBtn;
  final bool? isLoading;

  CustomBtn(
      {required this.text, required this.onPressed, this.outlineBtn, this.isLoading});

  @override
  Widget build(BuildContext context) {

    bool _outlineBtn = outlineBtn ?? false;
    bool _isLoading = isLoading ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 65.0,
        decoration: BoxDecoration(
            color: _outlineBtn ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8),
            border: Border.all(
                color: Colors.black,
                width: 2.0),
            borderRadius: BorderRadius.circular(12.0)),
        margin: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 8),
        child: Stack(
          children: [
            Visibility(
              visible: _isLoading ? false : true,
              child: Center(
                child: Text(
                  text ?? "Text",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: _outlineBtn ? Colors.black : Colors.white),
                ),
              ),
            ),
            Visibility(
              visible: _isLoading,
              child: Center(
                child: SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: CircularProgressIndicator()
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
