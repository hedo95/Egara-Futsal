import 'package:egaradefinitiu/logic/Logic/DAO/FirebaseContext.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Game.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Team.dart';
import 'package:egaradefinitiu/logic/Logic/Providers/GameProvider.dart';
import 'package:egaradefinitiu/logic/Logic/Providers/PlayerProvider.dart';
import 'package:egaradefinitiu/logic/Logic/Providers/TeamProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  get bottomNavBarIndex => null;
  var db = new FirebaseContext();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Game>>(
        // Primer StreamBuilder para cargar los partidos de Firebase
        stream: db.loadGames(),
        builder: (context, snapshot1) {
          return StreamBuilder<List<Team>>(
              // Segundo StreamBuilder para cargar los equipos de Firebase
              stream: db.loadTeams(),
              builder: (context, snapshot2) {
                if (!snapshot1.hasData || !snapshot2.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot1.hasError) {
                  return Center(child: Text(snapshot1.error));
                } else if (snapshot2.hasError) {
                  return Center(child: Text(snapshot2.error));
                } else {
                  ChangeNotifierProvider provider1 = ChangeNotifierProvider(
                      create: (context) => GameProvider(
                          snapshot1.data)); // Los metemos en su provider
                  ChangeNotifierProvider provider2 = ChangeNotifierProvider(
                      create: (context) => TeamProvider(
                          snapshot2.data)); // Lo metemos en su provider
                  ChangeNotifierProvider provider3 = ChangeNotifierProvider(
                      create: (context) => PlayerProvider(snapshot1
                          .data)); // Provider3 es de jugadores, y no cargamos nada porque los sacamos de todos los partidos, en el constuctor ya llamamos una función del EgaraBO que nos saca todos los distintos jugadores de los partidos.
                  return MultiProvider(
                      providers: [provider1, provider2, provider3],
                      // Metemos los 3 providers en un Multiproviders
                      child: MaterialApp(
                        // Empieza la App.
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
                                    onPressed:
                                        () // Cargamos los 3 providers, y printamos algo del primer elemento de cada provider para ver que realmente funciona.
                                        {
                                      var games =
                                          Provider.of<GameProvider>(context)
                                              .games;
                                      var teams =
                                          Provider.of<TeamProvider>(context)
                                              .teams;
                                      var players =
                                          Provider.of<PlayerProvider>(context)
                                              .players;
                                      print(games[0].id.toString());
                                      print(teams[0].id.toString());
                                      print(players[0].name +
                                          ' ' +
                                          players[0].surname);
                                    }),
                                Text(
                                  'hola Mundo',
                                )
                              ])),
                        ),
                      ));
                }
              });
        });
  }
}
