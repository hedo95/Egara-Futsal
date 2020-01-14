import 'package:egaradefinitiu/style/Theme.dart';
import 'package:flutter/material.dart';

class Jugadora extends StatelessWidget {
  final String nombreJugadora, dorsal;

  const Jugadora({
    Key key,
    @required this.nombreJugadora,
    @required this.dorsal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50)),
              padding: EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFF270049),
                ),
                height: 100,
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    this.dorsal,
                    style: TextStyle(
                      fontSize: 60,
                      color: Colors.white38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Text(
              this.nombreJugadora,
              style: TextStyle(color: containerDestacado, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
          ],
        ),
      ),
    );
  }
}
