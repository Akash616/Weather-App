import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weather/consts/colors.dart';

class CustomThemes {
  static final lightTheme = ThemeData( //static bec. we have to access lightTheme var. using className
    cardColor: Colors.grey.shade300,
    fontFamily: "poppins",
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Vx.gray800,
    dividerTheme: DividerThemeData(
      color: Vx.gray200
    ),
    iconTheme: IconThemeData(
      color: Vx.gray600
    ),
    canvasColor: Colors.blueAccent.withOpacity(0.7),
  );
  static final darkTheme = ThemeData(
    cardColor: Color(0x898c7db0),
    fontFamily: "poppins",
    scaffoldBackgroundColor: bgColor,
    primaryColor: Colors.white,
    dividerTheme: DividerThemeData(
      color: Vx.white.withOpacity(0.3)
    ),
    iconTheme: IconThemeData(
      color: Colors.white
    ),
    canvasColor: Colors.grey.shade400, //circleAvatar color
  );
}