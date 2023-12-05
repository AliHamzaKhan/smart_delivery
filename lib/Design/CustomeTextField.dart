

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constant/Colors.dart';

class CustomTextField extends StatefulWidget {
  final IconData? postfixicon;
  final IconData? postfixicon1;
  final String hintText;
  bool ispasswordfield;
  bool isPassword;
  bool isEmail;

  TextEditingController cntrlr;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChange;

  CustomTextField({
    Key? key,
    required this.ispasswordfield,
    this.postfixicon1,
    this.postfixicon,
    required this.hintText,
    required this.isEmail,
    required this.isPassword,
    required this.cntrlr,
    this.validator,
    this.onChange
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: textColor),
      cursorColor: textColor,
      validator: widget.validator,
      onChanged: widget.onChange,
      obscureText: widget.isPassword,
      keyboardType:
      widget.isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.transparent,

        suffixIcon: Visibility(
          visible: widget.ispasswordfield,
          child: GestureDetector(
              onTap: () {
                setState(() {
                  widget.isPassword = !widget.isPassword;
                });
              },
              child: widget.isPassword
                  ? Icon(
                CupertinoIcons.eye_slash,
                color: textColor,
              )
                  : Icon(
                CupertinoIcons.eye,
                color: textColor,
              )),
        ),

        hintText: widget.hintText,
        hintStyle: TextStyle(color: textColor),
      ),
      controller: widget.cntrlr,
    );
  }
}