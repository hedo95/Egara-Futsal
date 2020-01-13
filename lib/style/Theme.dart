import 'package:flutter/material.dart';

//Colores Aplicacion
Color backgroundColor = Color(0xFF3D006A);
Color primaryColor = Colors.white;
Color containerDestacado = Color(0xFF4b1a77);
Color shadowColor = Color(0xFF270049);

LinearGradient colorGradiente = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.purple[100],
    Colors.white,
  ],
);

LinearGradient colorGradienteBar = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.red[200],
    Colors.blue[200],
  ],
);

TextStyle titulocabecera = TextStyle(
  color: Colors.white,
  fontSize: 30,
  fontStyle: FontStyle.italic,
);

BoxDecoration estiloContenedor = BoxDecoration(
  color: Color(0xFF4b1a77),
  borderRadius: BorderRadius.circular(30),
  boxShadow: [
    BoxShadow(
      color: Color(0xFF270049),
      offset: Offset(-10, 10),
    ),
  ],
  gradient: colorGradiente,
);

class MyFlutterApp {
  MyFlutterApp._();

  static const _kFontFam = 'MyFlutterApp';

  static const IconData trophy = const IconData(0xe800, fontFamily: _kFontFam);
  static const IconData home = const IconData(0xe801, fontFamily: _kFontFam);
  static const IconData cog = const IconData(0xe810, fontFamily: _kFontFam);
  static const IconData user = const IconData(0xe82a, fontFamily: _kFontFam);
  static const IconData soccer = const IconData(0xe837, fontFamily: _kFontFam);
  static const IconData chart_bars = const IconData(0xe843, fontFamily: _kFontFam);
  static const IconData list = const IconData(0xe872, fontFamily: _kFontFam);
  static const IconData chevron_left = const IconData(0xe875, fontFamily: _kFontFam);
}
