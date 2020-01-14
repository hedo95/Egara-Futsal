import 'package:charts_flutter/flutter.dart' as charts;
import 'package:egaradefinitiu/logic/Logic/DAO/EgaraDAO.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Game.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PlayerView extends StatelessWidget {
  final Player player;

  PlayerView(this.player);

  @override
  Widget build(BuildContext context) {
    List<Game> games = Provider.of<List<Game>>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[900],
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
        title: Text(player.name + ' ' + player.surname),
      ),
      body: Games(player.playedgames(games), player.totalgames(games),
          player.goals(games), player.ycards(games), player.rcards(games)),
    );
  }
}

class Games extends StatefulWidget {
  final int playedgames, totalgames, goals, yellowcards, redcards;

  Games(this.playedgames, this.totalgames, this.goals, this.yellowcards,
      this.redcards);

  _GamesState createState() => _GamesState(this.playedgames, this.totalgames,
      this.goals, this.yellowcards, this.redcards);
}

class _GamesState extends State<Games> {
  List<charts.Series<GoalandCards, String>> _seriesEventsData;
  final int playedgames, totalgames, goals, yellowcards, redcards;

  _GamesState(this.playedgames, this.totalgames, this.goals, this.yellowcards,
      this.redcards);

  _generateData() {
    var eventsData = [
      new GoalandCards('Partidos T.', this.totalgames, Colors.purple[900]),
      new GoalandCards('Partidos J.', this.playedgames, Colors.blue[300]),
      new GoalandCards('Goles', this.goals, Colors.green[600]),
      new GoalandCards('T. Amarillas', this.yellowcards, Colors.yellow[700]),
      new GoalandCards('T. Rojas', this.redcards, Colors.red[800]),
    ];

    _seriesEventsData.add(charts.Series(
        data: eventsData,
        domainFn: (GoalandCards event, _) => event.event,
        measureFn: (GoalandCards event, _) => event.value,
        id: 'Events',
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        colorFn: (GoalandCards event, _) =>
            charts.ColorUtil.fromDartColor(event.color),
        fillColorFn: (GoalandCards event, _) =>
            charts.ColorUtil.fromDartColor(event.color)));
  }

  @override
  void initState() {
    super.initState();
    _seriesEventsData = List<charts.Series<GoalandCards, String>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Eventos de los partidos',
                style: TextStyle(
                    color: Colors.purple[900],
                    fontSize: 34.0,
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
                      desiredMaxRows: 2,
                      cellPadding: new EdgeInsets.only(right: 20.0),
                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.purple.shadeDefault,
                          fontFamily: 'Georgia',
                          fontSize: 15),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoalandCards {
  final String event;
  final int value;
  final Color color;

  GoalandCards(this.event, this.value, this.color);
}
