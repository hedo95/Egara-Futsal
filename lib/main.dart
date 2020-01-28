import 'dart:io';
import 'package:egaradefinitiu/logic/Logic/DAO/FirebaseContext.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Game.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Team.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'logic/Logic/BO/EgaraBO.dart';
import 'logic/Logic/DAO/EgaraDAO.dart';
import 'logic/Logic/Model/Player.dart';
import 'widgets/BottomMenu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  final db = new FirebaseContext();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Game>>(
      stream: db.loadGames(),
      builder: (context, snapshot1) {
        if (!snapshot1.hasData) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(backgroundColor: Colors.green[200]),
              SizedBox(height: 10),
              Text('Loading Games..',
                  style: TextStyle(color: Colors.green[200], fontSize: 18),
                  textDirection: TextDirection.ltr)
            ],
          ));
        } else if (snapshot1.hasError) {
          return Center(child: Text(snapshot1.error));
        } else {
          return StreamBuilder<List<Team>>(
            stream: db.loadTeams(),
            builder: (context, snapshot2) {
              if (!snapshot2.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                          backgroundColor: Colors.red[800]),
                      SizedBox(height: 10),
                      Text('Loading Teams..',
                          style:
                              TextStyle(color: Colors.red[800], fontSize: 18),
                          textDirection: TextDirection.ltr)
                    ],
                  ),
                );
              } else if (snapshot2.hasError) {
                return Center(child: Text(snapshot2.error));
              } else {
                return MultiProvider(
                  providers: [
                    Provider<List<Game>>.value(
                        value: makingGamesReal(snapshot1.data, snapshot2.data)),
                    Provider<List<Team>>.value(value: snapshot2.data),
                  ],
                  child: MaterialApp(
                    // Empieza la App.
                    debugShowCheckedModeBanner: false,
                    initialRoute: '/',
                    routes: {
                      '/': (_) => BottomMenu(),
                    },
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}

// //Prueba provider

// void main() {
//   FlutterError.onError = (FlutterErrorDetails details) {
//     FlutterError.dumpErrorToConsole(details);
//     if (kReleaseMode)
//       exit(1);
//   };
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   get bottomNavBarIndex => null;
//   var db = new FirebaseContext();
//   List<Game> games = [];
//   List<Team> teams = [];
//   List<Player> players = [];

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp( // Empieza la App.
//                       title: 'Welcome to Flutter',
//                       home: Scaffold(
//                         appBar: AppBar(
//                           title: Text('Welcome to Flutter'),
//                         ),
//                         body: Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               IconButton(
//                                 icon: Icon(Icons.add),
//                                 color: Colors.blue[500],
//                                 onPressed: () // Cargamos los 3 providers, y printamos algo del primer elemento de cada provider para ver que realmente funciona.
//                                 {
//                                   // var games = Provider.of<GameProvider>(context).games;
//                                   // var teams = Provider.of<TeamProvider>(context).teams;
//                                   // var players = Provider.of<PlayerProvider>(context).players;
//                                   // List<Game> games = getAllGamesFromFile();
//                                   // db.addAllGames(games);
//                                   //print(games.length);
//                                   db.loadGames().listen((list){
//                                     list.sort((a,b) => a.id.compareTo(b.id));
//                                     print(list.length);
//                                    });
//                                   // db.loadTeams().listen((onData){
//                                   //   onData.forEach((item) => print(item.id.toString()));
//                                   // });
//                                 }
//                               ),
//                               Text('hola Mundo',
//                               )
//                             ]
//                           )
//                         ),
//                       ),
//                     );
//                 }
//           }

/////////////////////////////////////////////
