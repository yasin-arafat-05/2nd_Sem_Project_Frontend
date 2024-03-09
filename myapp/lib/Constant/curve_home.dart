import 'package:flutter/material.dart';

class CurveHome extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    final firstCurve = Offset(0, size.height - 30);
    final secondCurve = Offset(30, size.height - 30);
    path.quadraticBezierTo(
        firstCurve.dx, firstCurve.dy, secondCurve.dx, secondCurve.dy);

    final secondFirstCurve = Offset(size.width - 30, size.height - 30);
    final secondSecondCurve = Offset(size.width - 30, size.height - 30);
    path.quadraticBezierTo(secondFirstCurve.dx, secondFirstCurve.dy,
        secondSecondCurve.dx, secondSecondCurve.dy);

    final thridFirstCurve = Offset(size.width, size.height - 30);
    final thridSecondCurve = Offset(size.width, size.height);
    path.quadraticBezierTo(thridFirstCurve.dx, thridFirstCurve.dy,
        thridSecondCurve.dx, thridSecondCurve.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  //_______________ Advance Topics Just return True _______________________
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
