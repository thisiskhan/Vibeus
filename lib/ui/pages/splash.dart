import 'package:flutter/material.dart';


import '../constants.dart';

// ignore: must_be_immutable
class Splash extends StatelessWidget {
  Color color1 = HexColor("#eb4b44");
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: color1,
      body: Container(
      
        width: size.width,
        child: Center(
         child: Image.asset("images/vibeuslogo.jpeg"),
     
        ),
      ),
    );
  }
}
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

