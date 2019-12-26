import 'package:egaradefinitiu/logic/Logic/BO/EgaraBO.dart';
import 'package:egaradefinitiu/logic/Logic/DAO/EgaraDAO.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Game.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Player.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Team.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/src/rendering/box.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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

class TeamView extends StatelessWidget {
  final Team team;
  final List<Game> games = getAllGamesFromFile();
  List<Team> teams = getAllTeamsFromFile();
  TeamView(this.team);

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
          title: Text(this.team.name),
        ),
        body: Games(
            team.currentPosition(teams, games),
            team.currentPoints(games),
            team.totalGames(games),
            team.wonGames(games),
            team.drawnGames(games),
            team.lostGames(games),
            team.currentGoals(games),
            team.currentConcededGoals(games)),
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
  Games(this.position, this.points, this.playedgames, this.wongames,
      this.drawngames, this.lostgames, this.goals, this.concededgoals);
  _GamesState createState() => _GamesState(
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
  final int points,
      playedgames,
      wongames,
      drawngames,
      lostgames,
      goals,
      concededgoals,
      position;
  _GamesState(this.position, this.points, this.playedgames, this.wongames,
      this.drawngames, this.lostgames, this.goals, this.concededgoals);

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
            padding: EdgeInsets.all(8.0),
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
                    fontSize: 24.0,
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
                        fontSize: 34.0,
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
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(' Insertar \n\ GridView  \n\ Jugadoras',
              style: TextStyle(
                fontSize: 30,
                color: Colors.purple[900]
              )
            ),
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
