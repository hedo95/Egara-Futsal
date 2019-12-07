import 'package:egara/BottomMenu.dart';
import 'package:egara/Theme.dart';
import 'package:egara/Theme.dart';
import 'package:egara/Theme.dart';
import 'package:egara/Theme.dart' as prefix0;
import 'package:flutter/material.dart';

import 'HomePage.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  get bottomNavBarIndex => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: primaryColor,
          backgroundColor: prefix0.backgroundColor,
        ),
        home: BottomMenu());
  }
}
