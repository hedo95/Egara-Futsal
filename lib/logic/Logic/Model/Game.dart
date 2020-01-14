import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egaradefinitiu/logic/Logic/DAO/FirebaseContext.dart';
import '../BO/EgaraBO.dart';
import '../DAO/EgaraDAO.dart';
import 'Player.dart';
import 'Team.dart';

class Game {
  Team localTeam, awayTeam;
  int id, localGoals, awayGoals, journey;
  List<int> season = [];
  DateTime date;
  Map<Player, List<int>> goalScorers;
  Map<Player, List<int>> yellowCards;
  Map<Player, List<int>> redCards;
  List<Player> localSquad, awaySquad;
  String documentID;
  FirebaseContext db;

  Game(
      List<dynamic> season,
      this.date,
      this.journey,
      String localteam,
      String awayteam,
      this.localGoals,
      this.awayGoals,
      Map<String, dynamic> goalscorers,
      Map<String, dynamic> yellowcards,
      Map<String, dynamic> redcards,
      List<dynamic> localsquad,
      List<dynamic> awaysquad,
      [this.id,
      this.documentID]) {
    this.season = season.cast<int>();
    this.localSquad = [];
    this.awaySquad = [];

    this.localTeam = new Team.game(localteam);
    this.awayTeam = new Team.game(awayteam);

    this.localSquad = mappingDataFromSquad(localsquad, localTeam);
    this.awaySquad = mappingDataFromSquad(awaysquad, awayTeam);

    this.goalScorers =
        mappingDataFromMaps(goalscorers, this.localSquad, this.awaySquad);
    this.yellowCards =
        mappingDataFromMaps(yellowcards, this.localSquad, this.awaySquad);
    this.redCards =
        mappingDataFromMaps(redcards, this.localSquad, this.awaySquad);
  }

  Game.db(
      List<dynamic> season,
      this.date,
      this.journey,
      String localteam,
      String awayteam,
      this.localGoals,
      this.awayGoals,
      Map<dynamic, dynamic> goalscorers,
      Map<dynamic, dynamic> yellowcards,
      Map<dynamic, dynamic> redcards,
      List<dynamic> localsquad,
      List<dynamic> awaysquad,
      [this.id,
      this.documentID]) {
    this.season = season.cast<int>();
    this.localSquad = [];
    this.awaySquad = [];

    this.localTeam = new Team.game(localteam);
    this.awayTeam = new Team.game(awayteam);

    this.localSquad = mappingDataFromSquad(localsquad, localTeam);
    this.awaySquad = mappingDataFromSquad(awaysquad, awayTeam);

    this.goalScorers =
        mappingDataFromMaps2(goalscorers, this.localSquad, this.awaySquad);
    this.yellowCards =
        mappingDataFromMaps2(yellowcards, this.localSquad, this.awaySquad);
    this.redCards =
        mappingDataFromMaps2(redcards, this.localSquad, this.awaySquad);
  }

  toJson() {
    List<dynamic> localsq = putSquadTodynamic(this.localSquad);
    List<dynamic> awaysq = putSquadTodynamic(this.awaySquad);
    Map<String, dynamic> goalscorers = putPlayersToJson(this.goalScorers);
    Map<String, dynamic> yellowc = putPlayersToJson(this.yellowCards);
    Map<String, dynamic> redc = putPlayersToJson(this.redCards);
    return {
      'id': this.id,
      'season': this.season,
      'journey': this.journey,
      'date': this.date.toString(),
      'localTeam': this.localTeam.name,
      'awayTeam': this.awayTeam.name,
      'localGoals': this.localGoals,
      'awayGoals': this.awayGoals,
      'goalScorers': goalscorers,
      'yellowcards': yellowc,
      'redcards': redc,
      'localsquad': localsq,
      'awaysquad': awaysq
    };
  }

  toDocument() => toJson();

  factory Game.fromJson(Map<String, dynamic> json) {
    return new Game(
        json['season'] as List<dynamic>,
        DateTime.parse(json['date']),
        json['journey'] as int,
        json['localTeam'] as String,
        json['awayTeam'] as String,
        json['localGoals'] as int,
        json['awayGoals'] as int,
        json['goalScorers'] as Map<String, dynamic>,
        json['yellowcards'] as Map<String, dynamic>,
        json['redcards'] as Map<String, dynamic>,
        json['localsquad'] as List<dynamic>,
        json['awaysquad'] as List<dynamic>,
        json['id'] as int);
  }

  static Game fromSnapshot(DocumentSnapshot snap) {
    return new Game.db(
        snap.data['season'],
        (snap.data['date'] as Timestamp).toDate(),
        snap.data['journey'],
        snap.data['localTeam'],
        snap.data['awayTeam'],
        snap.data['localGoals'],
        snap.data['awayGoals'],
        snap.data['goalScorers'],
        snap.data['yellowCards'],
        snap.data['redCards'],
        snap.data['localsquad'],
        snap.data['awaysquad'],
        snap.data['id'],
        snap.documentID);
  }
}
