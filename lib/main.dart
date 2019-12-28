import 'dart:async';
import 'package:egaradefinitiu/logic/Logic/DAO/EgaraDAO.dart';
import 'package:egaradefinitiu/logic/Logic/DAO/FirebaseContext.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Game.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Team.dart';
import 'package:egaradefinitiu/screens/Clasificacion.dart';
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
import 'logic/Logic/BO/EgaraBO.dart';
import 'logic/Logic/Model/Player.dart';
import 'package:sentry/sentry.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  get bottomNavBarIndex => null;
  var db = new FirebaseContext();
  List<Game> games = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Game>>( // Primer StreamBuilder para cargar los partidos de Firebase
      stream: db.loadGames(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Center( child: CircularProgressIndicator());
        }
        else if(snapshot.hasError){
          return Center(child: Text(snapshot.error));
        }else{
            ChangeNotifierProvider provider1 = ChangeNotifierProvider(create: (context) => GameProvider(snapshot.data)); // Los metemos en su provider
            games.addAll(snapshot.data); // Esta variable la necesitaremos mas adelante
            return StreamBuilder<List<Team>>( // Segundo StreamBuilder para cargar los equipos de Firebase
              stream: db.loadTeams(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return Center( child: CircularProgressIndicator());
                }
                else if(snapshot.hasError){
                  return Center(child: Text(snapshot.error));
                }else{
                  ChangeNotifierProvider provider2 = ChangeNotifierProvider(create: (context) => TeamProvider(snapshot.data)); // Lo metemos en su provider
                  ChangeNotifierProvider provider3 = ChangeNotifierProvider(create: (context) => PlayerProvider(games)); // Provider3 es de jugadores, y no cargamos nada porque los sacamos de todos los partidos, en el constuctor ya llamamos una función del EgaraBO que nos saca todos los distintos jugadores de los partidos.
                  return MultiProvider(
                    providers: [provider1, provider2, provider3], // Metemos los 3 providers en un Multiproviders
                    child: MaterialApp( // Empieza la App.
                      debugShowCheckedModeBanner: false,
                      routes: <String, WidgetBuilder>{
                        '/Graficos_jugadoras': (BuildContext context) => EstadisticaJugadora(),
                        '/Clasificacion': (BuildContext context) => Clasificacion(),
                      },
                      theme: ThemeData(
                        primaryColor: primaryColor,
                        backgroundColor: backgroundColor,
                      ),
                      home: BottomMenu()
                    )
                  );
                }
          }
      );
        }
      }
    );
  }
}










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

*/

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Team> teams = getAllTeamsFromFile();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Animated Charts App',
        theme: ThemeData(
          primaryColor: Colors.purple[900],
        ),
        home: TeamView(
            getAllTeamsFromFile().firstWhere((item) => item.id == 20008)));
  }
}

class TeamView extends StatefulWidget {
  final Team team;

  TeamView(this.team);

  @override
  _TeamViewState createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView> {
  final List<Game> games = getAllGamesFromFile();
  List<Team> teams = getAllTeamsFromFile();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[900],
          bottom: TabBar(
            indicatorColor: Colors.pink[200],
            tabs: [
              Tab(
                  icon: Icon(FontAwesomeIcons.solidChartBar,
                      color: Colors.pink[200])),
              Tab(
                  icon:
                      Icon(FontAwesomeIcons.chartPie, color: Colors.pink[200])),
              Tab(
                  icon: Icon(Icons.group,
                      color: Colors.pink[200])),
              Tab(
                  icon: Icon(Icons.room,
                      color: Colors.pink[200]))
            ],
          ),
          title: Text(this.widget.team.name),
        ),
        body: Games(
            widget.team,
            widget.team.currentPosition(teams, games),
            widget.team.currentPoints(games),
            widget.team.totalGames(games),
            widget.team.wonGames(games),
            widget.team.drawnGames(games),
            widget.team.lostGames(games),
            widget.team.currentGoals(games),
            widget.team.currentConcededGoals(games)),
      ),
    ));
  }
}

class Games extends StatefulWidget {
  final int position,
      points,
      playedgames,
      wongames,
      drawngames,
      lostgames,
      goals,
      concededgoals;
  final Team team;
  Games(this.team,this.position, this.points, this.playedgames, this.wongames,
      this.drawngames, this.lostgames, this.goals, this.concededgoals);
  _GamesState createState() => _GamesState(
      this.team,
      this.position,
      this.points,
      this.playedgames,
      this.wongames,
      this.drawngames,
      this.lostgames,
      this.goals,
      this.concededgoals);
}

class _GamesState extends State<Games> {
  List<charts.Series<Task, String>> _seriesPieData;
  List<charts.Series<GamesData, String>> _seriesEventsData;
  List<Player> players = [];
  final List<Game> games = getAllGamesFromFile();
  final Team team;
  final int points,
      playedgames,
      wongames,
      drawngames,
      lostgames,
      goals,
      concededgoals,
      position;
  _GamesState(this.team,this.position, this.points, this.playedgames, this.wongames,
      this.drawngames, this.lostgames, this.goals, this.concededgoals){
        players = getAllPlayersFromAteam(team, games);
        players.sort((b,a) => a.goals(games).compareTo(b.goals(games)));
      }

  _generateData() {
    var eventsData = [
      new GamesData(
          'Partidos jugados', 'PJ', this.playedgames, Colors.purple[900]),
      new GamesData('Partidos ganados', 'PG', this.wongames, Colors.green[600]),
      new GamesData(
          'Partidos empatados', 'PE', this.drawngames, Colors.yellow[700]),
      new GamesData('Partidos perdidos', 'PP', this.lostgames, Colors.red[800]),
    ];


    _seriesEventsData.add(charts.Series(
        data: eventsData,
        domainFn: (GamesData event, _) => event.labelx,
        measureFn: (GamesData event, _) => event.value,
        id: 'Events',
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        colorFn: (GamesData event, _) =>
            charts.ColorUtil.fromDartColor(event.color),
        fillColorFn: (GamesData event, _) =>
            charts.ColorUtil.fromDartColor(event.color)));

    var pieData = [
      new Task('A favor', this.goals, Colors.purple[900]),
      new Task('En contra', this.concededgoals, Colors.pink[200]),
    ];


    _seriesPieData.add(
      charts.Series(
          data: pieData,
          domainFn: (Task task, _) => task.task,
          measureFn: (Task task, _) => task.taskvalue,
          colorFn: (Task task, _) =>
              charts.ColorUtil.fromDartColor(task.colorvalue),
          id: 'Daily task',
          labelAccessorFn: (Task row, _) => '${row.taskvalue}'),
    );
  }

  @override
  void initState() {
    super.initState();
    _seriesPieData = List<charts.Series<Task, String>>();
    _seriesEventsData = List<charts.Series<GamesData, String>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
                child: Center(
                    child: Column(children: <Widget>[
              Text(
                'Puntos: ' +
                    this.points.toString() +
                    '       ' +
                    'Posición: ' +
                    this.position.toString(),
                style: TextStyle(
                    color: Colors.purple[900],
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Expanded(
                  child: charts.BarChart(
                _seriesEventsData,
                animate: true,
                barGroupingType: charts.BarGroupingType.grouped,
                animationDuration: Duration(seconds: 2),
                behaviors: [
                  new charts.DatumLegend(
                    outsideJustification:
                        charts.OutsideJustification.endDrawArea,
                    horizontalFirst: false,
                    desiredMaxRows: 1,
                    cellPadding: new EdgeInsets.only(right: 40.0),
                    entryTextStyle: charts.TextStyleSpec(
                        color: charts.MaterialPalette.purple.shadeDefault,
                        fontFamily: 'Georgia',
                        fontSize: 15),
                  )
                ],
              ))
            ])))),
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
                child: Center(
              child: Column(
                children: <Widget>[
                  Text(
                    'Goles',
                    style: TextStyle(
                        color: Colors.purple[900],
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Expanded(
                      child: charts.PieChart(
                    _seriesPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 2),
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:
                            charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 1,
                        cellPadding: new EdgeInsets.only(right: 60.0),
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.purple.shadeDefault,
                            fontFamily: 'Georgia',
                            fontSize: 19),
                      )
                    ],
                    defaultRenderer: new charts.ArcRendererConfig(
                      arcWidth: 100,
                      arcRendererDecorators: [
                        new charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.inside,
                            insideLabelStyleSpec: new charts.TextStyleSpec(
                                fontSize: 25,
                                color: charts.MaterialPalette.white))
                      ],
                    ),
                  ))
                ],
              ),
            )
          )
        ),
        Padding(
          padding: EdgeInsets.all(2),
          child: Scrollbar(
            child: GridView.builder(
              padding: EdgeInsets.all(22),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Columnas
                childAspectRatio: 1, // H/W
                crossAxisSpacing: 60, // separacion vertical entre items
                mainAxisSpacing: 50 // Separacion horiontal entre items
              ),
              itemCount: players.length,
              itemBuilder: (context,index){
                return Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PlayerView(players[index])
                            ));
                        },
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Text(players[index].dorsal.toString(),
                            style: TextStyle(
                              color: Colors.purple[900],
                              fontSize: 75
                            )
                          )
                        )
                      ),
                      Text(players[index].name,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.purple[900],
                          fontSize:15
                        ),
                      )
                    ],
                  )
                );
              },
            )
          )
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(' Insertar \n\ Información del equipo  \n\            + \n\ Google Maps',
              style: TextStyle(
                fontSize: 30,
                color: Colors.purple[900]
              )
            ),
          )
        )
      ],
    );
  }
}

class Task {
  String task;
  int taskvalue;
  Color colorvalue;

  Task(this.task, this.taskvalue, this.colorvalue);
}

class GamesData {
  final String event;
  final String labelx;
  final int value;
  final Color color;

  GamesData(this.event, this.labelx, this.value, this.color);
}
