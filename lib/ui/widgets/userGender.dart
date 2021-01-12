import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget userGender(gender) {
  switch (gender) {
    case 'Male':
      return Icon(
        FontAwesomeIcons.male,
        color: Colors.white,
      );
      break;
    case 'Female':
      return Icon(
        FontAwesomeIcons.female,
        color: Colors.white,
      );
      break;
    case 'Transgender':
      return Icon(
        FontAwesomeIcons.transgenderAlt,
        color: Colors.white,
      );
      break;
    default:
      return null;
      break;
  }
}
