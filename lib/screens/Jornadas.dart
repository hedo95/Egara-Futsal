import 'package:egaradefinitiu/logic/Logic/BO/EgaraBO.dart';
import 'package:egaradefinitiu/logic/Logic/DAO/EgaraDAO.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Game.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Team.dart';
import 'package:egaradefinitiu/style/Theme.dart';
import 'package:egaradefinitiu/widgets/Cabecera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Jornadas extends StatefulWidget {
  final List<Game> games;
  int journey;

  Jornadas(this.games, {int journey}) {
    if (journey == null) {
      this.journey = currentJourney(games);
    } else {
      this.journey = journey;
    }
  }

  @override
  _JornadasState createState() => _JornadasState(this.games, this.journey);
}

class _JornadasState extends State<Jornadas> {
  int currentJourney;
  int maxJourney = 12;
  List<Game> games;
  List<Game> journeyGames = [];

  _JornadasState(this.games, this.currentJourney) {
    this.journeyGames = getCalendar(games)
        .firstWhere((item) => item.journey == this.currentJourney)
        .games;
    //this.maxJourney = getCalendar(games).length;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF3D006A),
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Jornadas',
                style: titulocabecera,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                decoration: estiloContenedor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      iconSize: 30,
                      color: containerDestacado,
                      onPressed: () {
                        if (currentJourney > 1) {
                          setState(() {
                            this.currentJourney--;
                            this.journeyGames = getCalendar(games)
                                .firstWhere((item) =>
                                    item.journey == this.currentJourney)
                                .games;
                            //this.maxJourney = getCalendar(games).length;
                          });
                        }
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      children: <Widget>[
                        Text(
                          'J$currentJourney',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: containerDestacado,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${getJourneyDate(journeyGames)}',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: containerDestacado,
                          ),
                        )
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                      iconSize: 30,
                      color: containerDestacado,
                      onPressed: () {
                        if (currentJourney < maxJourney) {
                          setState(
                            () {
                              this.currentJourney++;
                              this.journeyGames = getCalendar(games)
                                  .firstWhere((item) =>
                                      item.journey == this.currentJourney)
                                  .games;
                              //this.maxJourney = getCalendar(games).length;
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                decoration: estiloContenedor,
                child: Column(
                  children: <Widget>[
                    JornadaContainer(this.journeyGames[0]),
                    JornadaContainer(this.journeyGames[1]),
                    JornadaContainer(this.journeyGames[2]),
                    JornadaContainer(this.journeyGames[3]),
                    JornadaContainer(this.journeyGames[4]),
                    JornadaContainer(this.journeyGames[5]),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class JornadaContainer extends StatelessWidget {
  final Game game;
  JornadaContainer(this.game);

  Widget displayJourneyResult(game) {
    var x = getJourneyResult(game);
    if (x.length > 4) {
      return Container(
        color: shadowColor,
        height: 60,
        width: 80,
        padding: EdgeInsets.only(top: 17),
        child: Text(
          x,
          style: TextStyle(
            color: Colors.white38,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else
      return Container(
        color: shadowColor,
        height: 60,
        width: 80,
        padding: EdgeInsets.only(top: 12),
        child: Text(
          x,
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 30,
          ),
          textAlign: TextAlign.center,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    List<Team> teams = Provider.of<List<Team>>(context);
    String localTeamshortname = teams.firstWhere((item) => item.name == game.localTeam.name).shortname;
    String awayTeamshortname = teams.firstWhere((item) => item.name == game.awayTeam.name).shortname;
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          // Navigator a la pantalla del acta del partido
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(width: 0.8),
                Container(
                  height:40,
                  width: 80,
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    '$localTeamshortname',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                displayJourneyResult(this.game),
                Container(
                  height:40,
                  width: 80,
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    '$awayTeamshortname',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                SizedBox(width: 0.8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
