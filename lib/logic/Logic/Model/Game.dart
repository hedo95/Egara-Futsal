import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

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
    season.forEach((item) => this.season.add(item));
    //this.season = new List<int>.from(season.whereType<List<dynamic>>()).toList();
    this.localSquad = [];
    this.awaySquad = [];

    this.localTeam =
        getAllTeamsFromFile().firstWhere((item) => item.name == localteam);
    this.awayTeam =
        getAllTeamsFromFile().firstWhere((item) => item.name == awayteam);

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

    this.localTeam =
        getAllTeamsFromFile().firstWhere((item) => item.name == localteam);
    this.awayTeam =
        getAllTeamsFromFile().firstWhere((item) => item.name == awayteam);

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
    List<dynamic> localsq = [];
    List<dynamic> awaysq = [];
    for (int n = 0; n < this.localSquad.length; n++) {
      if (this.localSquad[n].surname == '') {
        localsq.add('${this.localSquad[n].dorsal}' +
            ' ' +
            '${this.localSquad[n].name}');
      } else {
        localsq.add('${this.localSquad[n].dorsal}' +
            ' ' +
            '${this.localSquad[n].surname}' +
            ', ' +
            '${this.localSquad[n].name}');
      }
    }

    for (int n = 0; n < this.awaySquad.length; n++) {
      if (this.awaySquad[n].surname == '') {
        awaysq.add(
            '${this.awaySquad[n].dorsal}' + ' ' + '${this.awaySquad[n].name}');
      } else {
        awaysq.add('${this.awaySquad[n].dorsal}' +
            ' ' +
            '${this.awaySquad[n].surname}' +
            ', ' +
            '${this.awaySquad[n].name}');
      }
    }

    Map<String, dynamic> goalscorers = {};
    for (MapEntry<Player, List<int>> map in this.goalScorers.entries) {
      if (map.key.surname.isEmpty) {
        String name = map.key.name;
        goalscorers[name] = map.value;
      } else {
        String name = map.key.surname + ', ' + map.key.name;
        goalscorers[name] = map.value;
      }
    }

    Map<String, dynamic> yellowc = {};
    for (MapEntry<Player, List<int>> map in this.yellowCards.entries) {
      if (map.key.surname.isEmpty) {
        String name = map.key.name;
        yellowc[name] = map.value;
      } else {
        String name = map.key.surname + ', ' + map.key.name;
        yellowc[name] = map.value;
      }
    }

    Map<String, dynamic> redc = {};
    for (MapEntry<Player, List<int>> map in this.redCards.entries) {
      if (map.key.surname.isEmpty) {
        String name = map.key.name;
        redc[name] = map.value;
      } else {
        String name = map.key.surname + ', ' + map.key.name;
        redc[name] = map.value;
      }
    }

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

  toDocument() {
    List<dynamic> localsq = [];
    List<dynamic> awaysq = [];
    for (int n = 0; n < this.localSquad.length; n++) {
      if (this.localSquad[n].surname == '') {
        localsq.add('${this.localSquad[n].dorsal}' +
            ' ' +
            '${this.localSquad[n].name}');
      } else {
        localsq.add('${this.localSquad[n].dorsal}' +
            ' ' +
            '${this.localSquad[n].surname}' +
            ', ' +
            '${this.localSquad[n].name}');
      }
    }

    for (int n = 0; n < this.awaySquad.length; n++) {
      if (this.awaySquad[n].surname == '') {
        awaysq.add(
            '${this.awaySquad[n].dorsal}' + ' ' + '${this.awaySquad[n].name}');
      } else {
        awaysq.add('${this.awaySquad[n].dorsal}' +
            ' ' +
            '${this.awaySquad[n].surname}' +
            ', ' +
            '${this.awaySquad[n].name}');
      }
    }

    Map<dynamic, dynamic> goalscorers = {};
    for (MapEntry<Player, List<int>> map in this.goalScorers.entries) {
      if (map.key.surname.isEmpty) {
        String name = map.key.name;
        goalscorers[name] = map.value;
      } else {
        String name = map.key.surname + ', ' + map.key.name;
        goalscorers[name] = map.value;
      }
    }

    Map<dynamic, dynamic> yellowc = {};
    for (MapEntry<Player, List<int>> map in this.yellowCards.entries) {
      if (map.key.surname.isEmpty) {
        String name = map.key.name;
        yellowc[name] = map.value;
      } else {
        String name = map.key.surname + ', ' + map.key.name;
        yellowc[name] = map.value;
      }
    }

    Map<dynamic, dynamic> redc = {};
    for (MapEntry<Player, List<int>> map in this.redCards.entries) {
      if (map.key.surname.isEmpty) {
        String name = map.key.name;
        redc[name] = map.value;
      } else {
        String name = map.key.surname + ', ' + map.key.name;
        redc[name] = map.value;
      }
    }

    return {
      'id': this.id,
      'season': this.season,
      'journey': this.journey,
      'date': this.date,
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
