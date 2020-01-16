import 'package:egaradefinitiu/logic/Logic/BO/EgaraBO.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Game.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Player.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Team.dart';
import 'package:egaradefinitiu/style/Theme.dart';
import 'package:egaradefinitiu/widgets/Cabecera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  int _index;

  ImageItem(int index) {
    this._index = index;
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List<Game> games = Provider.of<List<Game>>(context);
    List<Team> teams = Provider.of<List<Team>>(context);

    Team egara = teams.firstWhere((item) => item.id == 20008);
    int journey = currentJourney(games);
    Game lastMatch = getLastMatch(games, egara);
    Team lastRival;
    if(lastMatch.localTeam.id == egara.id){
      lastRival = teams.firstWhere((item) => item.id == lastMatch.awayTeam.id);
    }else{
      lastRival = teams.firstWhere((item) => item.id == lastMatch.localTeam.id);
    }
    Game nextGame = getNextMatch(games, egara);
    Team localTeamfromNextGame = teams.firstWhere((item) => item.id == nextGame.localTeam.id);
    int x = catchArrow(teams, games);
    List<Team> tresEquipos = getHomepageLeagueContainer(teams, games);
    List<dynamic> tresEstilos = [];
    if(tresEquipos[0].id == egara.id){
      tresEstilos.add(letra3EquiposEgara);
      tresEstilos.add(letra3Equipos);
      tresEstilos.add(letra3Equipos);
    }else if(tresEquipos[1].id == egara.id){
      tresEstilos.add(letra3Equipos);
      tresEstilos.add(letra3EquiposEgara);
      tresEstilos.add(letra3Equipos);
    }else{
      tresEstilos.add(letra3Equipos);
      tresEstilos.add(letra3Equipos);
      tresEstilos.add(letra3EquiposEgara);
    }

    Widget flecha(int x) {
      if (x > 0) {
        return Icon(
          Icons.arrow_drop_up,
          color: Colors.green,
          size: 40.0,
        );
      } else if (x < 0) {
        return Icon(
          Icons.arrow_drop_down,
          color: Colors.red,
          size: 40.0,
        );
      } else {
        return Container(
          height: 40,
          width: 40,
          child: Icon(
            Icons.drag_handle,
            color: Colors.blue[200],
            size: 25.0,
          ),
        );
      }
    }

/*
    StorageReference photo = FirebaseStorage.instance.ref().child('images');

  

    getImage(){
      photo.child("${teams[_index].id}.png")
    }
*/
    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: SafeArea(
          child: ListView(
            children: <Widget>[
              Cabecera(),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  decoration: estiloContenedor,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: 400,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 220, top: 10),
                        child: Image.asset('assets/escudos/20008.png'),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 150, top: 20),
                              child: Text(
                                egara.name,
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                SizedBox(width: 140),
                                Container(
                                  decoration: estiloContenedorDestacado,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          flecha(x),
                                          Text( '${egara.currentPosition(teams, games)}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white38,
                                            ),
                                          ),
                                          SizedBox(width: 70),
                                          Container(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Text(
                                              '${egara.currentPoints(games).toString()} pts',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white38,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.mood_bad,
                                            color: Colors.red[800],
                                            size: 20,
                                          ),
                                          SizedBox(width: 20),
                                          Text(
                                            '${lastMatch.localGoals}-${lastMatch.awayGoals}',
                                            style: TextStyle(
                                              color: Colors.white38,
                                              fontSize: 20,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            height: 50,
                                            width: 50,
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: Image.asset(
                                                'assets/escudos/${lastRival.id}.png'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Siguiente Partido',
                  style: titulocabecera,
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 200,
                      width: 400,
                      decoration: estiloContenedor,
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Local',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: containerDestacado,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width: 50,
                                  child:
                                      Image.asset("assets/escudos/${nextGame.localTeam.id}.png"),
                                ),
                                SizedBox(width: 10),
                                Container(
                                    height: 50,
                                    width: 50,
                                    child: Image.asset(
                                        "assets/escudos/${nextGame.awayTeam.id}.png")),
                                Text(
                                  'Visitante',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: containerDestacado,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('${nextGame.date.day}/${nextGame.date.month}/${nextGame.date.year}', style: estiloLetraContainer),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${add0(nextGame.date.hour)}:${add0(nextGame.date.minute)} h',
                                  style: estiloLetraContainer,
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(' ${localTeamfromNextGame.fieldname}, \n\ ${localTeamfromNextGame.location}',
                                    style: estiloLetraContainer),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Clasificación',
                  style: titulocabecera,
                ),
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  Provider.of<ValueNotifier<int>>(context).value = 2;
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: 400,
                        decoration: BoxDecoration(
                          color: Color(0xFF4b1a77),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF270049),
                              offset: Offset(-10, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 300,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFF270049),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    tresEquipos[0]
                                        .currentPosition(teams, games)
                                        .toString(),
                                    style: letra3Equipos,
                                  ),
                                  Container(
                                      height: 35,
                                      width: 35,
                                      child: Image.asset(
                                          "assets/escudos/${tresEquipos[0].id}.png")),
                                  Text(
                                    tresEquipos[0].shortname,
                                    style: letra3Equipos,
                                  ),
                                  Text(
                                      tresEquipos[0]
                                              .currentPoints(games)
                                              .toString() +
                                          " pts",
                                      style: tresEstilos[0]),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 300,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFF270049),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                      tresEquipos[1]
                                          .currentPosition(teams, games)
                                          .toString(),
                                      style: letra3EquiposEgara),
                                  Container(
                                      height: 40,
                                      width: 40,
                                      child: Image.asset(
                                          "assets/escudos/${tresEquipos[1].id}.png")),
                                  Text(
                                    tresEquipos[1].shortname,
                                    style: letra3EquiposEgara,
                                  ),
                                  Text(
                                    tresEquipos[1].currentPoints(games).toString() +
                                        " pts",
                                    style: tresEstilos[1],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 300,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Color(0xFF270049),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    tresEquipos[2]
                                        .currentPosition(teams, games)
                                        .toString(),
                                    style: letra3Equipos,
                                  ),
                                  Container(
                                      height: 40,
                                      width: 40,
                                      child: Image.asset("assets/escudos/${tresEquipos[2].id}.png")),
                                  Text(
                                    tresEquipos[2].shortname,
                                    style: tresEstilos[2],
                                  ),
                                  
                                  Text(
                                    tresEquipos[2].currentPoints(games).toString() + " pts",
                                    style: letra3Equipos,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
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
/*
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF3D006A),
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Cabecera(),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF270049),
                              offset: Offset(-10, 10),
                            ),
                          ],
                          gradient: colorGradiente,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(right: 200),
                          child: Image.asset('assets/Background.png'),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 130, top: 20),
                              child: Text(
                                'Egara F.C',
                                style: TextStyle(
                                  fontSize: 50.0,
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                SizedBox(width: 170),
                                Container(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF381254),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.arrow_drop_up,
                                              color: Colors.green,
                                              size: 40.0,
                                            ),
                                            Text(
                                              '4',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white38,
                                              ),
                                            ),
                                            SizedBox(width: 70),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                '24 Pts',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white38,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.mood_bad,
                                              color: Colors.red[800],
                                              size: 20,
                                            ),
                                            SizedBox(width: 20),
                                            Text(
                                              '2-0',
                                              style: TextStyle(
                                                color: Colors.white38,
                                                fontSize: 30,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                                height: 50,
                                                width: 50,
                                                color: Colors.black),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Siguiente Partido',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: 400,
                        decoration: BoxDecoration(
                          color: Color(0xFF4b1a77),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF270049),
                              offset: Offset(-10, 10),
                            ),
                          ],
                        ),
                        child: Container(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Local',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white38,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    'Visitante',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white38,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '21/12/2019',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white38,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '19:00 h',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white38,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Camp Nou,   Barcelona',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white38,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Clasificación',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<ValueNotifier<int>>(context).value = 2;
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 200,
                          width: 400,
                          decoration: BoxDecoration(
                            color: Color(0xFF4b1a77),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF270049),
                                offset: Offset(-10, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 300,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xFF270049),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      '7.',
                                      style: TextStyle(
                                        color: Colors.white38,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Container(
                                        height: 40,
                                        width: 40,
                                        color: Colors.black),
                                    Text(
                                      'hola',
                                      style: TextStyle(
                                        color: Colors.white38,
                                      ),
                                    ),
                                    SizedBox(width: 40),
                                    Text(
                                      '26 pts',
                                      style: TextStyle(
                                        color: Colors.white38,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: 300,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xFF270049),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text('7.',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 20,
                                        )),
                                    Container(
                                        height: 40,
                                        width: 40,
                                        color: Colors.black),
                                    Text(
                                      'hola',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(width: 40),
                                    Text(
                                      '26 pts',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: 300,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Color(0xFF270049),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text('7.',
                                        style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 20,
                                        )),
                                    Container(
                                        height: 40,
                                        width: 40,
                                        color: Colors.black),
                                    Text(
                                      'hola',
                                      style: TextStyle(
                                        color: Colors.white38,
                                      ),
                                    ),
                                    SizedBox(width: 40),
                                    Text(
                                      '26 pts',
                                      style: TextStyle(
                                        color: Colors.white38,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/
