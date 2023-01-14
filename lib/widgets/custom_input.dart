import 'package:flutter/material.dart';

import '../constants.dart';

class CustomInput extends StatelessWidget {
  final String? hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool? isPasswordField;
  final TextInputType? isNumField;
  final bool? isAutoFocus;

  CustomInput(
      {required this.hintText,
      this.onChanged,
      this.onSubmitted,
      this.focusNode,
      this.textInputAction,
      this.isPasswordField,
      this.isAutoFocus,
      this.isNumField});

  @override
  Widget build(BuildContext context) {
    bool _isPasswordField = isPasswordField ?? false;
    TextInputType _isNumField = isNumField ?? TextInputType.text;
    bool _isAutoFocus = isAutoFocus ?? false;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      decoration: BoxDecoration(
          color: Color(0xFFF2F2F2).withOpacity(0.8),
          borderRadius: BorderRadius.circular(12.0)),
      child: TextField(
        keyboardType: _isNumField,
        autofocus: _isAutoFocus,
        obscureText: _isPasswordField,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText ?? "Hint text",
            contentPadding:
                EdgeInsets.symmetric(horizontal: 24, vertical: 20.0)),
        style: Constants.regularDarkText,
      ),
    );
  }
}
