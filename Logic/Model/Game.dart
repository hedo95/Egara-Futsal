import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show File;
import 'dart:convert' show json;
import 'dart:io';
import 'package:egarafutsal/Logic/BO/EgaraBO.dart';
import 'package:egarafutsal/Logic/DAO/EgaraDAO.dart';
import 'package:egarafutsal/Logic/Model/Team.dart';

class Game
{
  String localTeam, awayTeam;
  int id,localGoals, awayGoals;
  String fieldname;
  Map<double,String> goalScorers; 
  Map<double,String> yellowCards;
  Map<double,String> redCards;

  Game
  (
    this.id, this.localTeam, this.awayTeam, 
    this.localGoals,this.awayGoals, this.goalScorers, 
    this.yellowCards,this.redCards
  );


  Game.def()
  {
    this.localTeam = "";
    this.awayTeam = "";
    this.localGoals = 0;
    this.awayGoals = 0;
    this.goalScorers = {};
    this.yellowCards = {};
    this.redCards = {};
  }

  // Constructor that update teams and players data from the game
  Game.add
  (
    this.localTeam, this.awayTeam, this.localGoals,
    this.awayGoals, this.goalScorers, this.yellowCards,
    this.redCards
  )
  {
    var teams = getAllTeamsData();
    teams.firstWhere((item) => item.name == this.localTeam).goals += this.localGoals;
    teams.firstWhere((item) => item.name == this.awayTeam).goals += this.awayGoals;

    if(this.localGoals > this.awayGoals)
    {
      teams.firstWhere((item) => item.name == this.localTeam).points += 3;
    }
    else if (this.localGoals < this.awayGoals)
    {
      teams.firstWhere((item) => item.name == this.awayTeam).points += 3;
    }
    else
    {
      teams.firstWhere((item) => item.name == this.localTeam).points += 1;
      teams.firstWhere((item) => item.name == this.awayTeam).points += 1;
    }

    exportTeamsData(teams);

    var localPlayers = getAllTeamsData().firstWhere((item) => item.name == this.localTeam).players.toList();
    var awayPlayers = getAllTeamsData().firstWhere((item) => item.name == this.awayTeam).players.toList();

    for (var value in this.goalScorers.values)
    {
      if (localPlayers.any((item) => item.name == value))
      {
        localPlayers.firstWhere((item) => item.name == value).goals += 1;
        createUpdatePlayer
        (
          id: localPlayers.firstWhere((item) => item.name == value).id,
          player: localPlayers.firstWhere((item) => item.name == value)
        );
      }
      else
      {
        awayPlayers.firstWhere((item) => item.name == value).goals += 1;
        createUpdatePlayer
        (
          id: awayPlayers.firstWhere((item) => item.name == value).id,
          player: awayPlayers.firstWhere((item) => item.name == value)
        );
      }
    }

    for (var value in this.yellowCards.values)
    {
      if (localPlayers.any((item) => item.name == value))
      {
        localPlayers.firstWhere((item) => item.name == value).yellowcards += 1;
        createUpdatePlayer
        (
          id: localPlayers.firstWhere((item) => item.name == value).id,
          player: localPlayers.firstWhere((item) => item.name == value)
        );
      }
      else
      {
        awayPlayers.firstWhere((item) => item.name == value).yellowcards += 1;
        createUpdatePlayer
        (
          id: awayPlayers.firstWhere((item) => item.name == value).id,
          player: awayPlayers.firstWhere((item) => item.name == value)
        );
      }
    }

    for (var value in this.redCards.values)
    {
      if (localPlayers.any((item) => item.name == value))
      {
        localPlayers.firstWhere((item) => item.name == value).redcards += 1;
        createUpdatePlayer
        (
          id: localPlayers.firstWhere((item) => item.name == value).id,
          player: localPlayers.firstWhere((item) => item.name == value)
        );
      }
      else
      {
        awayPlayers.firstWhere((item) => item.name == value).redcards += 1;
        createUpdatePlayer
        (
          id: awayPlayers.firstWhere((item) => item.name == value).id,
          player: awayPlayers.firstWhere((item) => item.name == value)
        );
      }
    }
  }

  toJson()
  {
    return
    {
      'localTeam': this.localTeam,
      'awayTeam': this.awayTeam,
      'localGoals': this.localGoals,
      'awayGoals': this.awayGoals,
      'goalScorers': this.goalScorers,
      'yellowcards': this.yellowCards,
      'redcards': this.redCards
    };
  }

  toPrint()
  {
    print("Id: " + this.id.toString() + "\n");
    print("Local team: " + this.localTeam + "\n");
    print("Away team: " + this.awayTeam + "\n");
    print("Local goals: " + this.localGoals.toString() + "\n");
    print("Away goals: " + this.awayGoals.toString() + "\n");
    print('Goal scorers:' + "\n");
    this.goalScorers.forEach((min, player) => print("${player}  ${min}'" + '\n'));
    print('Yellow cards:' + '\n');
    this.yellowCards.forEach((min, player) => print("${player}  ${min}'" + '\n'));
    print('Red cards:' + '\n');
    this.redCards.forEach((min, player) => print("${player}  ${min}'" + '\n'));
    print(' ');
  }

  factory Game.fromJson(Map<String,dynamic> json)
  {
    return new Game
    (
      json['id'] as int,
      json['localTeam'] as String,
      json['awayTeam'] as String,
      json['localGoals'] as int,
      json['awayGoals'] as int,
      json['goalScorers'] as Map<double,String>,
      json['yellowCards'] as Map<double,String>,
      json['redCards'] as Map<double,String>,
    );
  }

}
