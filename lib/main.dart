import 'dart:async';
import 'package:egaradefinitiu/logic/Logic/DAO/EgaraDAO.dart';
import 'package:egaradefinitiu/logic/Logic/DAO/FirebaseContext.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Game.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Team.dart';
import 'package:egaradefinitiu/screens/Clasificacion.dart';
import 'package:egaradefinitiu/screens/HomePage.dart';
import 'package:egaradefinitiu/screens/Jornadas.dart';
import 'package:egaradefinitiu/screens/PlayerView.dart';
import 'package:egaradefinitiu/screens/TeamView.dart';
import 'package:egaradefinitiu/style/Theme.dart';
import 'package:egaradefinitiu/subscreens/Graficos_jugadoras.dart';
import 'package:egaradefinitiu/widgets/BottomMenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egaradefinitiu/logic/Logic/Providers/GameProvider.dart';
import 'package:egaradefinitiu/logic/Logic/Providers/TeamProvider.dart';
import 'package:egaradefinitiu/logic/Logic/Providers/PlayerProvider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sentry/sentry.dart';
import 'logic/Logic/BO/EgaraBO.dart';
import 'logic/Logic/Model/Player.dart';
import 'package:sentry/sentry.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sortedmap/sortedmap.dart';

/*
// Prueba provider con menú real

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  get bottomNavBarIndex => null;
  var db = new FirebaseContext();
  List<Game> games = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Empieza la App.
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/Graficos_jugadoras': (BuildContext context) =>
              EstadisticaJugadora(),
          '/Clasificacion': (BuildContext context) => Clasificacion(),
        },
        theme: ThemeData(
          primaryColor: primaryColor,
          backgroundColor: backgroundColor,
        ),
        home: BottomMenu());
  }
}


























// Prueba provider

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode)
      exit(1);
  };
  runApp(MyApp());
}
  
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  get bottomNavBarIndex => null;
  var db = new FirebaseContext();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Game>>( // Primer StreamBuilder para cargar los partidos de Firebase
      stream: db.loadGames(),
      builder: (context, snapshot1) {
            return StreamBuilder<List<Team>>( // Segundo StreamBuilder para cargar los equipos de Firebase
              stream: db.loadTeams(),
              builder: (context, snapshot2) {
                if(!snapshot1.hasData || !snapshot2.hasData){
                  return Center(child: CircularProgressIndicator());
                }
                else if(snapshot1.hasError){
                  return Center(child: Text(snapshot1.error));
                }else if(snapshot2.hasError){
                  return Center(child: Text(snapshot2.error));
                }else{
                  ChangeNotifierProvider provider1 = ChangeNotifierProvider<GameProvider>.value(value: GameProvider(snapshot1.data)); //(create: (context) => GameProvider(snapshot1.data)); // Los metemos en su provider
                  ChangeNotifierProvider provider2 = ChangeNotifierProvider<TeamProvider>.value(value: TeamProvider(snapshot2.data)); 
                  ChangeNotifierProvider provider3 = ChangeNotifierProvider<PlayerProvider>.value(value: PlayerProvider(snapshot1.data)); //(create: (context) => PlayerProvider(snapshot1.data)); // Provider3 es de jugadores, y no cargamos nada porque los sacamos de todos los partidos, en el constuctor ya llamamos una función del EgaraBO que nos saca todos los distintos jugadores de los partidos.
                  return MultiProvider(
                    providers: [provider1, provider2, provider3], // Metemos los 3 providers en un Multiproviders
                    child: MaterialApp( // Empieza la App.
                      title: 'Welcome to Flutter',
                      home: Scaffold(
                        appBar: AppBar(
                          title: Text('Welcome to Flutter'),
                        ),
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.add),
                                color: Colors.blue[500],
                                onPressed: () // Cargamos los 3 providers, y printamos algo del primer elemento de cada provider para ver que realmente funciona.
                                {
                                  var games = Provider.of<GameProvider>(context).games;
                                  var teams = Provider.of<TeamProvider>(context).teams;
                                  var players = Provider.of<PlayerProvider>(context).players;
                                  print(games[0].id.toString());
                                  print(teams[0].id.toString());
                                  print(players[0].name + ' ' + players[0].surname);
                                }
                              ),
                              Text('hola Mundo',
                              )
                            ]
                          )
                        ),
                      ),
                    )
                  );
                }
          }
      );
      }
    );
  }
}






























// Prueba firebase


void main(){ 
  FlutterError.onError = (FlutterErrorDetails details){
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode)
      exit(1);
  };
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                iconSize: 40,
                icon: Icon(Icons.add),
                color: Colors.blue[500],
                onPressed: ()
                {
                  // Vemos que funciona la conexión con Firebase
                  // var db = new FirebaseContext();
                  // var games = db.loadGames();
                  // games.listen((onData){
                  //   onData.sort((a,b) => a.id.compareTo(b.id));
                  //   onData.forEach((element) => print(element.id.toString()));
                  // });

                  List<Game> games = getAllGamesFromFile();
                  games.sort((a,b) => a.id.compareTo(b.id));
                  topScorers(games).forEach((k,v) => print('${k.name} ${k.surname}: $v'));

                  // Printamos los metodos de equipo:
                  // List<Team> teams = getAllTeamsFromFile();
                  // Team egara = teams.firstWhere((item) => item.id == 20008);
                  // print(' ');
                  // print('Current goals: '+egara.currentGoals(games).toString());
                  // print('Current conceded goals: '+egara.currentConcededGoals(games).toString());
                  // print('Current position: ' + egara.currentPosition(teams, games).toString());
                  // print('Last current position: ' + egara.lastCurrentPosition(teams,games).toString() + '\n');
                  // print('Current points: '+egara.currentPoints(games).toString());
                  // print('Last current points: ' + egara.lastCurrentPoints(games).toString());

                  // Printamos los metodos de jugador
                  // Player oumaima = getAllPlayers(games).firstWhere((item) => item.surname == "BEDDOUH");
                  // print('');
                  // print('Goals: ' + oumaima.goals(games).toString());
                  // print('Played games: ' + oumaima.playedgames(games).toString());
                  // print('Total games: ' + oumaima.totalgames(games).toString());
                  // print('Yellow cards: '+ oumaima.ycards(games).toString());
                  // print('Red cards: ' + oumaima.rcards(games).toString());
                }
              ),
              Text('Push me',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue[500]
                ),
              )
            ]
          )
        ),
      ),
    );
  }
}




























































// Jornadas


void main(){ 
  FlutterError.onError = (FlutterErrorDetails details){
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode)
      exit(1);
  };
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jornadas',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Jornadas'),
          backgroundColor: Colors.purple[900],
        ),
        body: Jornadas()
      ),
    );
  }
}





// Prueba StreamProvider

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode)
      exit(1);
  };
  runApp(MyApp());
}
  
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  get bottomNavBarIndex => null;
  var db = new FirebaseContext();

  @override
  Widget build(BuildContext context) {
        return MultiProvider(
          providers: [
            StreamProvider<List<Game>>.value(value: db.loadGames()),
            StreamProvider<List<Team>>.value(value: db.loadTeams())
            ], // Metemos los 3 providers en un Multiproviders
          child: MaterialApp( // Empieza la App.
            title: 'Welcome to Flutter',
            home: Scaffold(
              appBar: AppBar(
                title: Text('Welcome to Flutter'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.add),
                      color: Colors.blue[500],
                      onPressed: () 
                      // Cargamos los 2 providers, y printamos algo de cada
                      {
                        var games = Provider.of<List<Game>>(context);
                        var teams = Provider.of<List<Team>>(context);
                        var players = getAllPlayers(games);
                        print(games[0].id.toString());
                        print(teams[0].id.toString());
                        print(players[0].name + ' ' + players[0].surname);
                      }
                    ),
                    Text('hola Mundo',
                    )
                  ]
                )
              ),
            ),
          )
        );
      }
}







*/

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  get bottomNavBarIndex => null;
  var db = new FirebaseContext(); // Mi class Firebase

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Game>>(
      // First StreamBuilder to load games
      stream: db.loadGames(),
      builder: (context, snapshot1) {
        return StreamBuilder<List<Team>>(
          // Second StreamBuilder to load teams
          stream: db.loadTeams(),
          builder: (context, snapshot2) {
            if (!snapshot1.hasData || !snapshot2.hasData) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot1.hasError || snapshot2.hasError) {
              return Center(child: Text('Error reading data!'));
            } else {
              return MultiProvider(
                providers: [
                  Provider<List<Game>>.value(value: snapshot1.data),
                  Provider<List<Team>>.value(value: snapshot2.data),
                  Provider<List<Player>>.value(
                      value: getAllPlayers(snapshot1.data))
                ],
                child: MaterialApp(
                  // Empieza la App.
                  initialRoute: '/',
                  routes: {
                    '/': (_) => BottomMenu(),
                  },
                ),
              );
            }
          },
        );
      },
    );
  }
}

class PantallaPrueba extends StatelessWidget {
  const PantallaPrueba({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Game> games = Provider.of<List<Game>>(context);
    List<Player> players = Provider.of<List<Player>>(context);
    List<Team> teams = Provider.of<List<Team>>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Flutter'),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                color: Colors.blue[500],
                onPressed: () {
                  // Get the value of each provider (List<Object>) and print the first item of them all
                  print('Partido ${games[0].id}');
                  print('${players[0].name} ${players[0].surname}');
                  print('${teams[0].name}');
                  print(
                      'Firebase -> StreamBuilder -> Multiprovider -> Consumer ');
                }),
            Text(
              'Press me',
            )
          ])),
    );
  }
}

/*

void main(){ 
  FlutterError.onError = (FlutterErrorDetails details){
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode)
      exit(1);
  };
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        body: TeamView(getAllTeamsFromFile()[8])
        ),
    );
  }
}




*/
