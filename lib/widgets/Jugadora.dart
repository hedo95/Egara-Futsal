
import 'package:flutter/material.dart';

class Jugadora extends StatefulWidget {
  @override
  _JugadoraState createState() => _JugadoraState();
}

class _JugadoraState extends State<Jugadora> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
          child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(50)
              ),
              padding: EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black,
                ),
                height: 100,
                width: 100,
                child: Icon(
                  Icons.photo,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              'Jugadora',
              style: TextStyle(color: Colors.white38, fontSize: 20),
            ),
            Text(
              'edad, posición',
              style: TextStyle(color: Colors.white38, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

