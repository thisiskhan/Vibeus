import 'package:flutter/material.dart';

Widget genderWidget(icon, text, size, selected, onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 30,
          color: selected == text ? Colors.blue : Colors.black54,
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Text(
          text,
          style: TextStyle(
            color: selected == text ? Colors.black : Colors.black,
          ),
        )
      ],
    ),
  );
}
