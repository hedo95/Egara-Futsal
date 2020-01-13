import 'package:egaradefinitiu/widgets/Cabecera.dart';
import 'package:flutter/material.dart';

class EstadisticaJugadora extends StatefulWidget {
  @override
  _EstadisticaJugadoraState createState() => _EstadisticaJugadoraState();
}

class _EstadisticaJugadoraState extends State<EstadisticaJugadora> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF3D006A),
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            Cabecera(),
          ],
        ),
      ),
    );
  }
}
