

import 'package:flutter/material.dart';

import '../Constant/Colors.dart';

class MainButton extends StatelessWidget {
  MainButton({Key? key, required this.title, this.onTap}) : super(key: key);
  String title;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: BoxDecoration(
            color: alterColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              title,
              style:  TextStyle(
                  color: appbackgroundColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}