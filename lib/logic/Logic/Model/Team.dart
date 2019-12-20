import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show File;
import 'dart:convert' show json;
import 'dart:io';
import 'package:egarafutsal/Logic/BO/EgaraBO.dart';
import 'package:egarafutsal/Logic/DAO/EgaraDAO.dart';
import 'package:egarafutsal/Logic/Model/Player.dart';

int id;
  String name, shield, address, location, zipcode, province, fieldname, fieldtype;

  // Nos interesa coger los puntos y posición de las dos ultimas jornadas, para el container de la vista Principal.    
  int get currentPoints
  {
    int points = 0;
    List<Game> games = getAllGamesFromFile().where((item) => item.localSquad.isNotEmpty && (item.localTeam.id == this.id || item.awayTeam.id == this.id)).toList();
    for(var game in games)
    {
      String result = whosWinner(game.localGoals, game.awayGoals);
      if(result == "1" && game.localTeam.id == this.id)
      {
        points += 3;
      }
      else if(result == "2" && game.awayTeam.id == this.id)
      {
        points += 3;
      }
      else
      {
        points++;
      }
    }
    return points;
  }
  
  int get currentPosition
  {
    List<Team> teams = getAllTeamsFromFile();
    teams.sort((b,a) => a.currentPoints.compareTo(b.currentPoints));
    var egara = teams.firstWhere((item) => item.id == this.id);
    return teams.indexOf(egara) + 1;
  }

  int get lastCurrentPoints
  {
    int points = 0;
    int journeyWanted = getAllGamesFromFile().firstWhere((item) => item.localSquad.isEmpty).journey - 2;
    List<Game> games = getAllGamesFromFile().where((item) => item.journey <= journeyWanted && (item.localTeam.id == this.id || item.awayTeam.id == this.id)).toList();
    for(var game in games)
    {
      String result = whosWinner(game.localGoals, game.awayGoals);
      if(result == "1" && game.localTeam.id == this.id)
      {
        points += 3;
      }
      else if(result == "2" && game.awayTeam.id == this.id)
      {
        points += 3;
      }
      else
      {
        points++;
      }
    }
    return points;
  }

  int get lastCurrentPosition
  {
    List<Team> teams = getAllTeamsFromFile();
    teams.sort((b,a) => a.lastCurrentPoints.compareTo(b.lastCurrentPoints));
    var egara = teams.firstWhere((item) => item.id == this.id);
    return teams.indexOf(egara) + 1;
  }
  
  int get currentGoals
  {
    int goals = 0;
    List<Game> games = getAllGamesFromFile().where((item) => item.localSquad.isNotEmpty && (item.localTeam.id == this.id || item.awayTeam.id == this.id)).toList();
    for(var game in games)
    {
      for(MapEntry<Player,List<int>> map in game.goalScorers.entries)
      {
        if(map.key.idteam == this.id)
        {
          goals += map.value.length;
        }
      }
    }
    return goals;
  }

  int get currentConcededGoals
  {
    int goals = 0;
    List<Game> games = getAllGamesFromFile().where((item) => item.localSquad.isNotEmpty && (item.localTeam.id == this.id || item.awayTeam.id == this.id)).toList();
    for(var game in games)
    {
      for(MapEntry<Player,List<int>> map in game.goalScorers.entries)
      {
        if(map.key.idteam != this.id)
        {
          goals += map.value.length;
        }
      }
    }
    return goals;
  }

  int get currentYcards
  {
    int ycards = 0;
    List<Game> games = getAllGamesFromFile().where((item) => item.localSquad.isNotEmpty && (item.localTeam.id == this.id || item.awayTeam.id == this.id)).toList();
    for(var game in games)
    {
      for(MapEntry<Player,List<int>> map in game.yellowCards.entries)
      {
        if(map.key.idteam == this.id)
        {
          ycards += map.value.length;
        }
      }
    }
    return ycards;
  }

  int get currentRcards
  {
    int rcards = 0;
    List<Game> games = getAllGamesFromFile().where((item) => item.localSquad.isNotEmpty && (item.localTeam.id == this.id || item.awayTeam.id == this.id)).toList();
    for(var game in games)
    {
      for(MapEntry<Player,List<int>> map in game.redCards.entries)
      {
        if(map.key.idteam == this.id)
        {
          rcards += map.value.length;
        }
      }
    }
    return rcards;
  }

  int get totalGames
  {
    List<Game> games = getAllGamesFromFile().where((item) => item.localSquad.isNotEmpty && (item.localTeam.id == this.id || item.awayTeam.id == this.id)).toList();
    return games.length;
  }

  int get wonGames
  {
    int wongames = 0;
    List<Game> games = getAllGamesFromFile().where((item) => item.localSquad.isNotEmpty && (item.localTeam.id == this.id || item.awayTeam.id == this.id)).toList();
    for(var game in games)
    {
      String result = whosWinner(game.localGoals, game.awayGoals);
      if(result == "1" && game.localTeam.id == this.id)
      {
        wongames++;
      }
      if(result == "2" && game.awayTeam.id == this.id)
      {
        wongames++;
      }
    }
    return wongames;
  }

  int get drawnGames
  {
    int drawngames = 0;
    List<Game> games = getAllGamesFromFile().where((item) => item.localSquad.isNotEmpty && (item.localTeam.id == this.id || item.awayTeam.id == this.id)).toList();
    for(var game in games)
    {
      String result = whosWinner(game.localGoals, game.awayGoals);
      if(result == "X")
      {
        drawngames++;
      }
    }
    return drawngames;
  }
  
  int get lostGames
  {
    return this.totalGames - (this.wonGames + this.drawnGames);
  }

  Team
  (
    this.id, this.name, this.shield, this.address, this.location, this.zipcode,
    this.province, this.fieldname, this.fieldtype
  );

  Team.def()
  {
    this.id == getAllTeamsFromFile()[getAllTeamsFromFile().length - 1].id + 1;
    this.name = "";
    this.shield = "";
    this.address = "";
    this.location = "";
    this.zipcode = "";
    this.province = "";
    this.fieldname = "";
    this.fieldtype = "";
  }

  toJson()
  {
    return 
    {
      'id': this.id,
      'name': this.name,
      'shield': this.shield,
      'address': this.address,
      'location': this.location,
      'zipcode': this.zipcode,
      'province': this.province,
      'fieldname': this.fieldname,
      'fieldtype': this.fieldtype,
    };
  }

  toPrint()
  {
    print(this.name + ' => ' +this.currentPoints.toString() + ' points, ' + this.wonGames.toString() + ' won games, ' + this.lostGames.toString() + ' lost games, ' + this.drawnGames.toString() + ' drawn games, '+  this.currentGoals.toString() + ' goals and ' + this.currentConcededGoals.toString() + ' conceded goals. ' + "\n");
    print(' ');
  }

  factory Team.fromJson(Map<String,dynamic> json)
  {
    return new Team
    (
      json['id'] as int,
      json['name'] as String,
      json['shield'] as String,
      json['address'] as String, 
      json['location'] as String, 
      json['zipcode'] as String, 
      json['province'] as String, 
      json['fieldname'] as String,
      json['fieldtype'] as String,
    );
  }
}
