import 'package:egaradefinitiu/screens/Clasificacion.dart';
import 'package:egaradefinitiu/style/Theme.dart';
import 'package:egaradefinitiu/subscreens/Graficos_jugadoras.dart';
import 'package:egaradefinitiu/widgets/BottomMenu.dart';
import 'package:flutter/material.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  get bottomNavBarIndex => null;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/Graficos_jugadoras': (BuildContext context) => EstadisticaJugadora(),
        '/Clasificacion': (BuildContext context) => Clasificacion(),
        
      },
      theme: ThemeData(
        primaryColor: primaryColor,
        backgroundColor: backgroundColor,
      ),
      home: BottomMenu(),
      
    );
  }
}

