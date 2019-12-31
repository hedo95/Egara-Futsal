import 'package:egaradefinitiu/logic/Logic/DAO/EgaraDAO.dart';
import 'package:egaradefinitiu/logic/Logic/BO/EgaraBO.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Game.dart';
import 'package:egaradefinitiu/style/Theme.dart';
import 'package:egaradefinitiu/widgets/Cabecera.dart';
import 'package:flutter/material.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Journey.dart';

class Jornadas extends StatefulWidget {
  final List<Game> games = getAllGamesFromFile();
  int journey;
  Jornadas({int journey}) {
    if (journey == null) {
      this.journey = currentJourney(games);
    } else {
      this.journey = journey;
    }
  }

  @override
  _JornadasState createState() => _JornadasState(this.journey);
}

class _JornadasState extends State<Jornadas> {
  int currentJourney;
  final List<Game> games = getAllGamesFromFile();
  List<Game> journeyGames = [];
  _JornadasState(this.currentJourney) {
    this.journeyGames = getCalendar(games)
        .firstWhere((item) => item.journey == this.currentJourney)
        .games;
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.skip_previous),
                    color: Colors.purple[900],
                    iconSize: 30,
                    onPressed: () {
                      if (currentJourney > 1) {
                        setState(() {
                          this.currentJourney--;
                          this.journeyGames = getCalendar(games)
                              .firstWhere(
                                  (item) => item.journey == this.currentJourney)
                              .games;
                        });
                      }
                    },
                  ),
                  Text(this.currentJourney.toString(),
                      style:
                          TextStyle(color: Colors.purple[900], fontSize: 30)),
                  IconButton(
                    icon: Icon(Icons.skip_next),
                    iconSize: 30,
                    color: Colors.purple[900],
                    onPressed: () {
                      // Cuando el fichero contenga las 22 jornadas del calendario, el if será "< 22"
                      if (currentJourney < 9) {
                        setState(() {
                          this.currentJourney++;
                          this.journeyGames = getCalendar(games)
                              .firstWhere(
                                  (item) => item.journey == this.currentJourney)
                              .games;
                        });
                      }
                    },
                  )
                ],
              ),
              Expanded(
                child: Scrollbar(
                  child: ListView.builder(
                    itemCount: journeyGames.length,
                    itemBuilder: (context,index){
                      return JornadaContainer(journeyGames[index]);
                    },
                  )
                )
              )
            ],
          ),
        ));
  }
}

class JornadaContainer extends StatelessWidget {
  final Game game;
  JornadaContainer(this.game);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
            onTap: () {
              print('Navigator.of(context).push(MaterialPageRoute(builder:(context) => ActaPartido(journeyGames[index])));');
              // Navigator.of(context).push(
              //               MaterialPageRoute(
              //                 builder: (context) => ActaPartido(journeyGames[index]);
              //               ));
            },
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                    game.localGoals.toString() +
                        ' - ' +
                        game.awayGoals.toString(),
                    style: TextStyle(color: Colors.purple[900], fontSize: 140))),
      );
    }
}
