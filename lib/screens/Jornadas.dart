import 'package:egaradefinitiu/logic/Logic/BO/EgaraBO.dart';
import 'package:egaradefinitiu/logic/Logic/DAO/EgaraDAO.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Game.dart';
import 'package:egaradefinitiu/style/Theme.dart';
import 'package:egaradefinitiu/widgets/Cabecera.dart';
import 'package:flutter/material.dart';

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
    /*
    return Padding(
      padding: EdgeInsets.all(10),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  color: Colors.purple[900],
                  iconSize: 30,
                  onPressed: (){
                    if(currentJourney > 1){
                      setState(() {
                        this.currentJourney--;
                        this.journeyGames = getCalendar(games).firstWhere((item) => item.journey == this.currentJourney).games;
                      });
                    }  
                  },
                ),
                Text(this.currentJourney.toString(),
                  style: TextStyle(
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
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(10),
                        child: JornadaContainer(journeyGames[index]));
                  },
                )
              ],
            ),
            JornadaContainer(this.journeyGames[0]),
            JornadaContainer(this.journeyGames[1]),
            JornadaContainer(this.journeyGames[2]),
            JornadaContainer(this.journeyGames[3]),
            JornadaContainer(this.journeyGames[4]),
            JornadaContainer(this.journeyGames[5]),
          ],
        ),
      )
    );
   */
    return Container(
      color: Color(0xFF3D006A),
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            Cabecera(),
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
                      color: Colors.white38,
                      onPressed: () {
                        if (currentJourney > 1) {
                          setState(() {
                            this.currentJourney--;
                            this.journeyGames = getCalendar(games)
                                .firstWhere((item) =>
                                    item.journey == this.currentJourney)
                                .games;
                          });
                        }
                      },
                    ),
                    Text(
                      'Jornada' + ' ' + this.currentJourney.toString(),
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white38,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                      iconSize: 30,
                      color: Colors.white38,
                      onPressed: () {
                        if (currentJourney < 9) {
                          setState(
                            () {
                              this.currentJourney++;
                              this.journeyGames = getCalendar(games)
                                  .firstWhere((item) =>
                                      item.journey == this.currentJourney)
                                  .games;
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

  @override
  Widget build(BuildContext context) {
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
              color: Color(0xFF270049),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(width: 0.8),
                Container(
                  color: Colors.black,
                  child: Text(
                    'Equipo 1',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Text(
                  game.localGoals.toString() +
                      ' - ' +
                      game.awayGoals.toString(),
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 30,
                  ),
                ),
                Container(
                  color: Colors.black,
                  child: Text(
                    'Equipo 2',
                    style: TextStyle(color: Colors.white),
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
