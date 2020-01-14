import 'package:cloud_firestore/cloud_firestore.dart';

import '../BO/EgaraBO.dart';
import '../DAO/EgaraDAO.dart';
import 'Game.dart';
import 'Player.dart';

class Team {
  int id;
  String name,
      shortname,
      shield,
      address,
      location,
      zipcode,
      province,
      fieldname,
      fieldtype,
      documentID;
  List<double> coordinates;
  bool parking, wifi, bar;

  // Nos interesa coger los puntos y posición de las dos ultimas jornadas, para el container de la vista Principal.
  int currentPoints(List<Game> games) {
    int points = 0;
    games = games
        .where((item) =>
            (item.localSquad.isNotEmpty || item.awaySquad.isNotEmpty) &&
            (item.localTeam.id == this.id || item.awayTeam.id == this.id))
        .toList();
    for (var game in games) {
      String result = whosWinner(game.localGoals, game.awayGoals);
      if (result == "1" && game.localTeam.id == this.id) {
        points += 3;
      } else if (result == "2" && game.awayTeam.id == this.id) {
        points += 3;
      } else if (result == "X") {
        points++;
      }
    }
    return points;
  }

  int currentPosition(List<Team> teams, List<Game> games) {
    teams.sort(
        (b, a) => a.currentPoints(games).compareTo(b.currentPoints(games)));
    var team = teams.firstWhere((item) => item.id == this.id);
    return teams.indexOf(team) + 1;
  }

  int weekAgoPoints(List<Game> games) {
    int points = 0;
    int journeyWanted =
        games.lastWhere((item) => item.localSquad.isNotEmpty).journey - 1;
    games = games
        .where((item) =>
            item.journey <= journeyWanted &&
            (item.localTeam.id == this.id || item.awayTeam.id == this.id) &&
            (item.localSquad.isNotEmpty || item.awaySquad.isNotEmpty))
        .toList();
    for (var game in games) {
      String result = whosWinner(game.localGoals, game.awayGoals);
      if (result == "1" && game.localTeam.id == this.id) {
        points += 3;
      } else if (result == "2" && game.awayTeam.id == this.id) {
        points += 3;
      } else if (result == "X") {
        points++;
      }
    }
    return points;
  }

  int weekAgoPosition(List<Team> teams, List<Game> games) {
    teams.sort((b, a) =>
        a.weekAgoPoints(games).compareTo(b.weekAgoPoints(games)));
    var team = teams.firstWhere((item) => item.id == this.id);
    return teams.indexOf(team) + 1;
  }

  int currentGoals(List<Game> games) {
    int goals = 0;
    games = games
        .where((item) =>
            item.localSquad.isNotEmpty &&
            (item.localTeam.id == this.id || item.awayTeam.id == this.id))
        .toList();
    for (var game in games) {
      for (MapEntry<Player, List<int>> map in game.goalScorers.entries) {
        if (map.key.idteam == this.id) {
          goals += map.value.length;
        }
      }
    }
    return goals;
  }

  int currentConcededGoals(List<Game> games) {
    int goals = 0;
    games = games
        .where((item) =>
            (item.localTeam.id == this.id || item.awayTeam.id == this.id))
        .toList();
    for (var game in games) {
      for (MapEntry<Player, List<int>> map in game.goalScorers.entries) {
        if (map.key.idteam != this.id) {
          goals += map.value.length;
        }
      }
    }
    return goals;
  }

  int currentYcards(List<Game> games) {
    int ycards = 0;
    games = games
        .where((item) =>
            item.localSquad.isNotEmpty &&
            (item.localTeam.id == this.id || item.awayTeam.id == this.id))
        .toList();
    for (var game in games) {
      for (MapEntry<Player, List<int>> map in game.yellowCards.entries) {
        if (map.key.idteam == this.id) {
          ycards += map.value.length;
        }
      }
    }
    return ycards;
  }

  int currentRcards(List<Game> games) {
    int rcards = 0;
    games = games
        .where((item) =>
            item.localSquad.isNotEmpty &&
            (item.localTeam.id == this.id || item.awayTeam.id == this.id))
        .toList();
    for (var game in games) {
      for (MapEntry<Player, List<int>> map in game.redCards.entries) {
        if (map.key.idteam == this.id) {
          rcards += map.value.length;
        }
      }
    }
    return rcards;
  }

  int totalGames(List<Game> games) {
    games = games
        .where((item) =>
            item.localSquad.isNotEmpty &&
            (item.localTeam.id == this.id || item.awayTeam.id == this.id))
        .toList();
    return games.length;
  }

  int wonGames(List<Game> games) {
    int wongames = 0;
    games = games
        .where((item) =>
            item.localSquad.isNotEmpty &&
            (item.localTeam.id == this.id || item.awayTeam.id == this.id))
        .toList();
    for (var game in games) {
      String result = whosWinner(game.localGoals, game.awayGoals);
      if (result == "1" && game.localTeam.id == this.id) {
        wongames++;
      }
      if (result == "2" && game.awayTeam.id == this.id) {
        wongames++;
      }
    }
    return wongames;
  }

  int drawnGames(List<Game> games) {
    int drawngames = 0;
    games = games
        .where((item) =>
            item.localSquad.isNotEmpty &&
            (item.localTeam.id == this.id || item.awayTeam.id == this.id))
        .toList();
    for (var game in games) {
      String result = whosWinner(game.localGoals, game.awayGoals);
      if (result == "X") {
        drawngames++;
      }
    }
    return drawngames;
  }

  int lostGames(List<Game> games) {
    return this.totalGames(games) -
        (this.wonGames(games) + this.drawnGames(games));
  }

  Team(
      this.id,
      this.name,
      this.shortname,
      this.shield,
      this.address,
      this.location,
      this.zipcode,
      this.province,
      List<dynamic> coordinates,
      this.fieldname,
      this.fieldtype,
      this.parking,
      this.wifi,
      this.bar,
      [this.documentID]) {
    this.coordinates = coordinates.cast<double>();
  }

  toDocument() {
    return {
      'id': this.id,
      'name': this.name,
      'shortname':this.shortname,
      'shield': this.shield,
      'address': this.address,
      'location': this.location,
      'zipcode': this.zipcode,
      'province': this.province,
      'coordinates': this.coordinates.cast<dynamic>(),
      'fieldname': this.fieldname,
      'fieldtype': this.fieldtype,
      'parking': this.parking,
      'wifi': this.wifi,
      'bar': this.bar
    };
  }

  toJson() => toDocument();

  toPrint() {
    print('Id: ${this.id}');
    print('Name: ${this.name}');
    print('Shortname: ${this.shortname}');
    print('Address: ${this.address}');
    print('Location: ${this.location}');
    print('Zipcode: ${this.zipcode}');
    print('Province: ${this.province}');
    print('Coordinates: [${this.coordinates[0]}, ${this.coordinates[1]}]');
    print('Field name: ${this.fieldname}');
    print('Field type: ${this.fieldtype}');
    print('Parking: ${this.parking}');
    print('Wifi: ${this.wifi}');
    print('Bar: ${this.bar}');
  }

  toPrintMethods(List<Team> teams, List<Game> games){
    print('Current points: ${currentPoints(games)}');
    print('Current position: ${currentPosition(teams,games)}');
    print('Points from last journey: ${weekAgoPoints(games)}');
    print('Position from last journey: ${weekAgoPosition(teams,games)}');
    print('Current goals: ${currentGoals(games)}');
    print('Current conceded goals: ${currentConcededGoals(games)}');
    print('Current yellow cards: ${currentYcards(games)}');
    print('Current red cards: ${currentRcards(games)}');
    print('Total games: ${totalGames(games)}');
    print('Won games: ${wonGames(games)}');
    print('Drawn games: ${drawnGames(games)}');
    print('Lost games: ${lostGames(games)}');
  }

  factory Team.fromJson(Map<String, dynamic> json) {
    return new Team(
        json['id'] as int,
        json['name'] as String,
        json['shortname'] as String,
        json['shield'] as String,
        json['address'] as String,
        json['location'] as String,
        json['zipcode'] as String,
        json['province'] as String,
        json['coordinates'] as List<dynamic>,
        json['fieldname'] as String,
        json['fieldtype'] as String,
        json['parking'] as bool,
        json['wifi'] as bool,
        json['bar'] as bool);
  }

  static Team fromSnapshot(DocumentSnapshot snap) {
    return new Team(
        snap['id'] as int,
        snap['name'] as String,
        snap['shortname'] as String,
        snap['shield'] as String,
        snap['address'] as String,
        snap['location'] as String,
        snap['zipcode'] as String,
        snap['province'] as String,
        snap['coordinates'] as List<dynamic>,
        snap['fieldname'] as String,
        snap['fieldtype'] as String,
        snap['parking'] as bool,
        snap['wifi'] as bool,
        snap['bar'] as bool,
        snap.documentID);
  }
}
