import 'package:egara/Cabecera.dart';
import 'package:egara/Theme.dart';
import 'package:flutter/material.dart';

class Equipos extends StatefulWidget {
  @override
  _EquiposState createState() => _EquiposState();
}

class _EquiposState extends State<Equipos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF3D006A),
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            Cabecera(),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Equipo',
                style: titulocabecera,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  decoration: estiloContenedor,
                  height: 200,
                  width: 20,
                ))
          ],
        ),
      ),
    );
  }
}
