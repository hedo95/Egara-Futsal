import 'package:egarafutsal/Logic/DAO/EgaraDAO.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart' show immutable;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:egarafutsal/Logic/BO/EgaraBO.dart';
import 'package:egarafutsal/Logic/Model/Player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Animated Charts App',
      theme: ThemeData(
        primaryColor: Colors.purple[900],
      ),
      home: PlayerView(getAllPlayersFromFile().firstWhere((item) => item.goals == 12)),
    );
  }
}

class PlayerView extends StatelessWidget{

  final Player player;
  PlayerView(this.player);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.purple[900],
                bottom: TabBar(
                  indicatorColor: Colors.purple[500],
                  tabs: [
                    Tab(
                        icon: Icon(FontAwesomeIcons.solidChartBar,
                            color: Colors.pink[200])),
                    Tab(
                        icon: Icon(FontAwesomeIcons.chartPie,
                            color: Colors.pink[200])),
                  ],
                ),
                title: Text(player.name + ' ' + player.surname),
              ),
              body:
               Games(player.playedgames, maxPlayedJourney(), player.goals, player.ycards, player.rcards),
                  ),
              )
    );
  }
}


class Games extends StatefulWidget {

    final int playedgames, totalgames, goals, yellowcards, redcards;
    Games(this.playedgames, this.totalgames, this.goals, this.yellowcards, this.redcards);
  _GamesState createState() => _GamesState(this.playedgames, this.totalgames, this.goals, this.yellowcards, this.redcards);
}

class _GamesState extends State<Games> {

  List<charts.Series<Task, String>> _seriesPieData;
  List<charts.Series<GoalandCards, String>> _seriesEventsData;
  final int playedgames, totalgames, goals, yellowcards, redcards;
  _GamesState(this.playedgames, this.totalgames, this.goals, this.yellowcards, this.redcards);

  _generateData() {

    var eventsData = [
      new GoalandCards('Partidos', this.totalgames, Colors.purple[900]),
      new GoalandCards('Goles', this.goals, Colors.green[600]),
      new GoalandCards('T. Amarillas', this.yellowcards, Colors.yellow[700]),
      new GoalandCards('T. Rojas', this.redcards, Colors.red[800]),
    ];

     _seriesEventsData.add(
      charts.Series(
          data: eventsData,
          domainFn: (GoalandCards event, _) => event.event,
          measureFn: (GoalandCards event, _) => event.value,
          id: 'Events',
          fillPatternFn: (_, __) => charts.FillPatternType.solid,
          colorFn: (GoalandCards event, _) =>
              charts.ColorUtil.fromDartColor(event.color),
          fillColorFn: (GoalandCards event, _) => charts.ColorUtil.fromDartColor(event.color)
    ));

    var pieData = [
      new Task('Partidos disputados', this.playedgames, Colors.purple[900]),
      new Task('Partidos no convocados', this.totalgames - this.playedgames, Colors.purple[500]),
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
    _seriesEventsData = List<charts.Series<GoalandCards, String>>();
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
                        child: Column(
                          children: <Widget> [
                            Text('Eventos de los partidos',
                              style: TextStyle(
                                      fontSize: 34.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple[900]),
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
                                    desiredMaxRows: 2,
                                    cellPadding: new EdgeInsets.only(right: 60.0),
                                    entryTextStyle: charts.TextStyleSpec(
                                        color: charts.MaterialPalette.purple
                                            .shadeDefault,
                                        fontFamily: 'Georgia',
                                        fontSize: 15),
                                  )
                                ],
                              )
                            )
                          ]
                        )
                      )
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                        child: Center(
                        child: Column(
                          children: <Widget>[
                            Text('Partidos jugados',
                                style: TextStyle(
                                    fontSize: 34.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple[900])
                                    ),
                            SizedBox(height: 20.0),
                            Expanded(
                                child: charts.PieChart(_seriesPieData,
                                    animate: true,
                                    animationDuration: Duration(seconds: 2),
                                    behaviors: [
                                  new charts.DatumLegend(
                                    outsideJustification:
                                        charts.OutsideJustification.endDrawArea,
                                    horizontalFirst: false,
                                    desiredMaxRows: 2,
                                    cellPadding: new EdgeInsets.only(right: 130.0),
                                    entryTextStyle: charts.TextStyleSpec(
                                        color: charts.MaterialPalette.purple
                                            .shadeDefault,
                                        fontFamily: 'Georgia',
                                        fontSize: 19),
                                  )
                                ],
                                defaultRenderer: new charts.ArcRendererConfig(
                                  arcWidth: 100,
                                  arcRendererDecorators: [
                                    new charts.ArcLabelDecorator(
                                      labelPosition: charts.ArcLabelPosition.inside,
                                      insideLabelStyleSpec: charts.TextStyleSpec(
                                        fontSize: 25,
                                        color: charts.MaterialPalette.white,
                                        ),
                                    )
                                  ],
                                ),
                                ))
                        ],
                      ),
                    )))
    ],);
  }
}

class Task {
  String task;
  int taskvalue;
  Color colorvalue;

  Task(this.task, this.taskvalue, this.colorvalue);
}

class GoalandCards {
  final String event;
  final int value;
  final Color color;

  GoalandCards(this.event, this.value, this.color);
}

