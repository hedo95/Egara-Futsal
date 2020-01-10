import 'dart:async';
import 'package:egaradefinitiu/logic/Logic/BO/EgaraBO.dart';
import 'package:egaradefinitiu/logic/Logic/DAO/EgaraDAO.dart';
import 'package:egaradefinitiu/logic/Logic/DAO/FirebaseContext.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Game.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Team.dart';
import 'package:egaradefinitiu/screens/Clasificacion.dart';
import 'package:egaradefinitiu/screens/Jornadas.dart';
import 'package:egaradefinitiu/screens/PlayerView.dart';
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
import 'package:sentry/sentry.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


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


