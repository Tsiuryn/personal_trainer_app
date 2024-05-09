import 'package:flutter/material.dart';

class AppConst {
  static Color background = Colors.black;
  static Color blue = Colors.blue[700]!;
  static Color yellow = Colors.yellow;
  static Color white = Colors.white;
  static Color navBar = Colors.white60;
  static Color grey = Colors.grey;

  /// TextStyle(
  //     fontSize: 24,
  //     fontWeight: FontWeight.w500,
  //     color: white,
  //   )
  static TextStyle appBarTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: white,
  );

  /// TextStyle(
  ///     fontSize: 16,
  ///     fontWeight: FontWeight.w500,
  ///     color: yellow,
  ///   )
  static TextStyle titleItem = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: yellow,
  );

  ///  TextStyle(
  ///    fontSize: 18,
  ///    fontWeight: FontWeight.w400,
  ///    color: blue,
  ///  )
  static TextStyle valueItem = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: blue,
  );
}
