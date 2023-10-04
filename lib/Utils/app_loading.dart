import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../Constant/Colors.dart';

class AppLoader {
  static showLoading({String? message}) async {
    EasyLoading.instance
          ..loadingStyle = EasyLoadingStyle.custom
          ..indicatorType = EasyLoadingIndicatorType.ring
          ..indicatorColor = Colors.transparent
          ..backgroundColor = Colors.transparent
          ..textColor = Colors.transparent
          ..boxShadow = <BoxShadow>[]
          ..maskColor = subBackgroundColor.withOpacity(0.5)
           ..customAnimation = CustomAnimation();

    await EasyLoading.show(
        status: message,
        maskType: EasyLoadingMaskType.custom,
        dismissOnTap: false,
        indicator: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              color: alterColor,
              backgroundColor: Colors.transparent,
            )));
  }

  static success({String? message}) async {
    EasyLoading.instance
      // ..textStyle = HTStyles.labelSemiBold.copyWith(color: kPrimary)
      ..backgroundColor =
          message != null ? alterColor : Colors.transparent
      ..dismissOnTap = true;
    await EasyLoading.show(
      status: message,
      maskType: EasyLoadingMaskType.black,
      indicator: Stack(
        children: <Widget>[
          SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                color: alterColor,
                value: 1,
                backgroundColor: appbackgroundColor,
                strokeWidth: 10,
              )),
          Positioned(
            left: 12,
            top: 12,
            child: Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(75),
                color: alterColor,
              ),
              child: Center(
                child: Icon(Icons.check, color: appbackgroundColor, size: 70),
              ),
            ),
          )
        ],
      ),
    );

    Timer(
      Duration(seconds: message != null ? 5 : 1),
      () => EasyLoading.dismiss(),
    );
  }

  static dismiss() {
    EasyLoading.dismiss();
  }

  static fail({String? error}) async {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..indicatorColor = Colors.transparent
      ..backgroundColor =
          error != null ? appbackgroundColor : Colors.transparent
      ..dismissOnTap = true
      ..boxShadow = <BoxShadow>[]
      ..maskColor = textColor.withOpacity(0.5)
      ..customAnimation = CustomAnimation();

    await EasyLoading.show(
      status: error,
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true,
      indicator: Stack(
        children: <Widget>[
          SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                color: alterColor,
                backgroundColor: appbackgroundColor,
                value: 1,
                strokeWidth: 10,
              )),
          Positioned(
            left: 12,
            top: 12,
            child: Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(75),
                color: alterColor,
              ),
              child: Center(
                child: Icon(Icons.error_outline,
                    color: appbackgroundColor, size: 70),
              ),
            ),
          )
        ],
      ),
    );

    Timer(
        Duration(seconds: error != null ? 5 : 1), () => EasyLoading.dismiss());
  }
}

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
      Widget child,
      AnimationController controller,
      AlignmentGeometry alignment,
      ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}