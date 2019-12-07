import 'package:flutter/material.dart';

import 'Cabecera.dart';
import 'Theme.dart';

class Jornadas extends StatefulWidget {
  @override
  _JornadasState createState() => _JornadasState();
}

class _JornadasState extends State<Jornadas> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF3D006A),
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            Cabecera(),
            Container(
              padding: EdgeInsets.only(left:20),
              child: Text('Jornadas', style: titulocabecera),
            ),
          ],
        ),
      ),
    );
  }
}