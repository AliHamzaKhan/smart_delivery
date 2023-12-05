

import 'package:flutter/material.dart';
import '../Constant/Colors.dart';

class HorizontelLine extends StatelessWidget {
  const HorizontelLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 1,
        color: textColor,
      ),
    );
  }
}

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: alterColor,
      ),
    );
  }
}


