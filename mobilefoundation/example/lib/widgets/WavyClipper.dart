import 'package:flutter/material.dart';

class WavyClipper extends CustomClipper<Path> {
  // @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);

    var firstControlPoint = new Offset(size.width * 0.25, size.height - 50);
    var firstEndPoint = new Offset(size.width * 0.5, size.height - 30);

    var secondControlPoint = new Offset(size.width * .75, size.height - 10);
    var secondEndPoint = new Offset(size.width, size.height - 70);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
