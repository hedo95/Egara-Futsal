import 'package:egaradefinitiu/logic/Logic/Model/Game.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Player.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Team.dart';
import 'package:egaradefinitiu/style/Theme.dart';
import 'package:egaradefinitiu/widgets/Cabecera.dart';
import 'package:egaradefinitiu/widgets/Jugadora.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';


class Equipos extends StatefulWidget {
  @override
  _EquiposState createState() => _EquiposState();
}

class _EquiposState extends State<Equipos> {

  @override
  
  Widget build(BuildContext context) {

    List<Game> games = Provider.of<List<Game>>(context);
    List<Player> players = Provider.of<List<Player>>(context);
    List<Team> teams = Provider.of<List<Team>>(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/Graficos_jugadoras');
      },
      child: Container(
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
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  decoration: estiloContenedor,
                  height: 500,
                  width: 20,
                  child: GridView(
                    padding: EdgeInsets.all(20),
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    children: <Widget>[
                      Jugadora(nombreJugadora: 'Pepita', dorsal: '20'),
                      Jugadora(nombreJugadora: 'Pepita', dorsal: '40'),
                      Jugadora(nombreJugadora: 'Pepita', dorsal: '40'),
                      Jugadora(nombreJugadora: 'Pepita', dorsal: '40'),
                      Jugadora(nombreJugadora: 'Pepita', dorsal: '40'),
                      Jugadora(nombreJugadora: 'Pepita', dorsal: '40'),
                      Jugadora(nombreJugadora: 'Pepita', dorsal: '40'),
                      Jugadora(nombreJugadora: 'Pepita', dorsal: '40'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


