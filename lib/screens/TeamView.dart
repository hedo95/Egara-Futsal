import 'package:charts_flutter/flutter.dart' as charts;
import 'package:egaradefinitiu/logic/Logic/BO/EgaraBO.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Game.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Player.dart';
import 'package:provider/provider.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Team.dart';
import 'package:egaradefinitiu/style/Theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'PlayerView.dart';


class TeamView extends StatefulWidget {
  final Team team;

  TeamView(this.team);

  @override
  _TeamViewState createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView> {
  @override
  Widget build(BuildContext context) {
    List<Game> games = Provider.of<List<Game>>(context);
    List<Team> teams = Provider.of<List<Team>>(context);

    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor:  Color(0xFF270049),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                );
              },
            ),
            bottom: TabBar(
              unselectedLabelColor: Color(0xFF4e1a96),
              indicatorColor: Colors.pink[200],
              labelColor: Colors.pink[200],
              tabs: [
                Tab(
                  icon: Icon(
                    FontAwesomeIcons.solidChartBar,
                  ),
                ),
                Tab(
                  icon: Icon(
                    FontAwesomeIcons.chartPie,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.group,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.room,
                  ),
                ),
              ],
            ),
            title: Text(this.widget.team.name, style: TextStyle(fontSize: 18)),
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
              widget.team.currentConcededGoals(games),
              games,
              teams),
        ),
      ),
    );
  }
}

class Games extends StatefulWidget {
  final List<Game> games;
  final List<Team> teams;
  List<Player> playersFromTeam = [];
  final int position,
      points,
      playedgames,
      wongames,
      drawngames,
      lostgames,
      goals,
      concededgoals;
  final Team team;

  Games(this.team, this.position, this.points, this.playedgames, this.wongames,
      this.drawngames, this.lostgames, this.goals, this.concededgoals,
      this.games, this.teams){
        playersFromTeam = getAllPlayersFromAteam(team, games);
        playersFromTeam.sort((b,a) => a.goals(games).compareTo(b.goals(games)));
      }

  _GamesState createState() => _GamesState(
      this.team,
      this.position,
      this.points,
      this.playedgames,
      this.wongames,
      this.drawngames,
      this.lostgames,
      this.goals,
      this.concededgoals,
      games,
      playersFromTeam);
}

class _GamesState extends State<Games> {
  List<charts.Series<Task, String>> _seriesPieData;
  List<charts.Series<GamesData, String>> _seriesEventsData;
  final List<Player> players;
  final List<Game> games;
  final Team team;

  final int points,
      playedgames,
      wongames,
      drawngames,
      lostgames,
      goals,
      concededgoals,
      position;

  _GamesState(
      this.team,
      this.position,
      this.points,
      this.playedgames,
      this.wongames,
      this.drawngames,
      this.lostgames,
      this.goals,
      this.concededgoals,
      this.games,
      this.players);

  _boolsToStrings(){
    var strs = [];
    if(team.parking){
      strs.add('Si');
    }else{
      strs.add('No');
    }if(team.bar){
      strs.add('Si');
    }else{
      strs.add('No');
    }if(team.wifi){
      strs.add('Si');
    }else{
      strs.add('No');
    }
    return strs;
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
    _boolsToStrings();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Padding(
          padding: EdgeInsets.all(0),
          child: Container(
            child: Center(
              child: Container(
                decoration: BoxDecoration(gradient: colorGradiente),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: <Widget>[
                              Text(
                                'Puntos:',
                                style: TextStyle(
                                  color: Colors.purple[900],
                                  fontSize: 20.0,
                                  letterSpacing: 2,
                                ),
                              ),
                              SizedBox(width: 20),
                              Text(
                                this.points.toString(),
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.purple[900],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: <Widget>[
                              Text(
                                'Posición:',
                                style: TextStyle(
                                  color: Colors.purple[900],
                                  fontSize: 20.0,
                                  letterSpacing: 2,
                                ),
                              ),
                              SizedBox(width: 20),
                              Text(
                                this.position.toString(),
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.purple[900],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(0),
          child: Container(
            child: Center(
              child: Container(
                decoration: BoxDecoration(gradient: colorGradiente),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Goles',
                        style: TextStyle(
                          color: Colors.purple[900],
                          fontSize: 30.0,
                          letterSpacing: 2,
                        ),
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
                                color:
                                    charts.MaterialPalette.purple.shadeDefault,
                                //fontFamily: 'Georgia',
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
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: colorGradiente,
          ),
          child: Padding(
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
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PlayerView(
                                    players[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.topCenter,
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80),                                
                                color: Color(0xFF381254),                                
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  players[index].dorsal.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 75,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          players[index].name,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.purple[900], fontSize: 15),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
          gradient: colorGradiente,),
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: SingleChildScrollView(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Equipo', style: TextStyle(color: Colors.purple[900], fontSize: 17)),
                Text('${team.name}', style: TextStyle(color: Color(0xFF270049), fontSize: 20)),
                Text(''),
                Text('Dirección', style: TextStyle(color: Colors.purple[900], fontSize: 17)),
                Text('${team.address}, ${team.location}', style: TextStyle(color: Color(0xFF270049), fontSize: 20)),
                Text(''),
                Text('Código postal', style: TextStyle(color: Colors.purple[900], fontSize: 17)),
                Text('${team.zipcode}', style: TextStyle(color: Color(0xFF270049), fontSize: 20)),
                Text(''),
                Text('Provincia', style: TextStyle(color: Colors.purple[900], fontSize: 17)),
                Text('${team.province}', style: TextStyle(color: Color(0xFF270049), fontSize: 20)),
                Text(''),
                Text('Coordenadas', style: TextStyle(color: Colors.purple[900], fontSize: 17)),
                Text('${team.coordinates[0]}, ${team.coordinates[1]}', style: TextStyle(color: Color(0xFF270049), fontSize: 20)),
                Text(''),
                Text('Estadio', style: TextStyle(color: Colors.purple[900], fontSize: 17)),
                Text('${team.fieldname}', style: TextStyle(color: Color(0xFF270049), fontSize: 20)),
                Text(''),
                Text('Tipo de pista', style: TextStyle(color: Colors.purple[900], fontSize: 17)),
                Text('${team.fieldtype}', style: TextStyle(color: Color(0xFF270049), fontSize: 20)),
                Text(''),
                Text('Parking', style: TextStyle(color: Colors.purple[900], fontSize: 17)),
                Text('${_boolsToStrings()[0]}', style: TextStyle(color: Color(0xFF270049), fontSize: 20)),
                Text(''),
                Text('Bar', style: TextStyle(color: Colors.purple[900], fontSize: 17)),
                Text('${_boolsToStrings()[1]}', style: TextStyle(color: Color(0xFF270049), fontSize: 20)),
                Text(''),
                Text('Wifi', style: TextStyle(color: Colors.purple[900], fontSize: 17)),
                Text('${_boolsToStrings()[2]}', style: TextStyle(color: Color(0xFF270049), fontSize: 20)),
                      // Container(
                      //   height: 178,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: <Widget>[
                      //       Text(
                      //         team.fieldname,
                      //         style: TextStyle(
                      //           color: Colors.white38,
                      //           fontSize: 30,
                      //         ),
                      //       ),
                      //       SizedBox(height: 40),
                      //       Row(
                      //         crossAxisAlignment: CrossAxisAlignment.baseline,
                      //         textBaseline: TextBaseline.ideographic,
                      //         children: <Widget>[
                      //           Text(
                      //             team.location + ',  ',
                      //             style: TextStyle(
                      //               color: Colors.white38,
                      //               fontSize: 25,
                      //             ),
                      //           ),
                      //           Text(
                      //             team.zipcode,
                      //             style: TextStyle(
                      //               color: Colors.white38,
                      //               fontSize: 15,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       SizedBox(height: 40),
                      //       Text(
                      //         team.province,
                      //         style: TextStyle(
                      //           color: Colors.white38,
                      //           fontSize: 25,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(height: 40),
                      // Container(
                      //   padding: EdgeInsets.only(left: 64),
                      //   child: Row(
                      //     children: <Widget>[
                      //       Image.asset(
                      //         "assets/escudos/${team.id}.png",
                      //         scale: 0.6
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                ),
                 ),
          ),
        ),
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
