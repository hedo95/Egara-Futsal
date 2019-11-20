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
  int id,localGoals, awayGoals, journey;
  String fieldname;
  Map<double,String> goalScorers; 
  Map<double,String> yellowCards;
  Map<double,String> redCards;
  List<String> localSquad, awaySquad;

  Game
  (
    this.id, this.journey, this.localTeam, this.awayTeam, 
    this.localGoals,this.awayGoals, this.goalScorers, 
    this.yellowCards,this.redCards, 
    List<dynamic> localSquad, List<dynamic> awaySquad
  )
  {
    this.localSquad = new List<String>.from(localSquad.map((item) => item.toString())).toList();
    this.awaySquad = new List<String>.from(awaySquad.map((item) => item.toString())).toList();
    Team localTeam = getAllTeamsData().firstWhere((item) => item.name == this.localTeam);
    Team awayTeam = getAllTeamsData().firstWhere((item) => item.name == this.awayTeam);
    localTeam.goals += this.localGoals;
    awayTeam.goals += this.awayGoals;
    
    if (whosWiner(localTeam, awayTeam).points == -1)
    {
      localTeam.points ++; awayTeam.points++;
      localTeam.drawGames++; awayTeam.drawGames++;
    }
    else
    {
      if(whosWiner(localTeam, awayTeam) == localTeam)
      {
        localTeam.points += 3; localTeam.wonGames++;
        awayTeam.lostGames++;
      }
      else
      {
        awayTeam.points += 3; awayTeam.wonGames++;
        localTeam.lostGames++;
      }
    }
    
    createUpdateTeam
    (
        id: localTeam.id,
        team: localTeam
    );

    createUpdateTeam
    (
        id: awayTeam.id,
        team: awayTeam
    );

    var localPlayers = getAllPlayersData().where((item) => item.idteam == localTeam.id).toList();
    var awayPlayers = getAllPlayersData().where((item) => item.idteam == awayTeam.id).toList();

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

    for (var player in this.localSquad)
    {
      localTeam.players.firstWhere((item) => item.name == player).playedGames++;
      createUpdatePlayer
      (
        id: awayPlayers.firstWhere((item) => item.name == player).id,
        player: awayPlayers.firstWhere((item) => item.name == player)
      );
    }

    for (var player in this.awaySquad)
    {
      awayTeam.players.firstWhere((item) => item.name == player).playedGames++;
      createUpdatePlayer
      (
        id: awayPlayers.firstWhere((item) => item.name == player).id,
        player: awayPlayers.firstWhere((item) => item.name == player)
      );
    }
  }


  Game.def()
  {
    this.id = getId(getAllGamesData());
    this.journey = maxJourney(getAllGamesData()) +1;
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
    this.redCards, this.localSquad, this.awaySquad
  )
  {
    this.id = getId(getAllGamesData());
    Team localTeam = getAllTeamsData().firstWhere((item) => item.name == this.localTeam);
    Team awayTeam = getAllTeamsData().firstWhere((item) => item.name == this.awayTeam);
    localTeam.goals += this.localGoals;
    awayTeam.goals += this.awayGoals;
    
    if (whosWiner(localTeam, awayTeam).points == -1)
    {
      localTeam.points ++; awayTeam.points++;
      localTeam.drawGames++; awayTeam.drawGames++;
    }
    else
    {
      if(whosWiner(localTeam, awayTeam) == localTeam)
      {
        localTeam.points += 3; localTeam.wonGames++;
        awayTeam.lostGames++;
      }
      else
      {
        awayTeam.points += 3; awayTeam.wonGames++;
        localTeam.lostGames++;
      }
    }
    
    createUpdateTeam
    (
        id: localTeam.id,
        team: localTeam
    );

    createUpdateTeam
    (
        id: awayTeam.id,
        team: awayTeam
    );

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

    for (var player in this.localSquad)
    {
      localTeam.players.firstWhere((item) => item.name == player).playedGames++;
      createUpdatePlayer
      (
        id: awayPlayers.firstWhere((item) => item.name == player).id,
        player: awayPlayers.firstWhere((item) => item.name == player)
      );
    }

    for (var player in this.awaySquad)
    {
      awayTeam.players.firstWhere((item) => item.name == player).playedGames++;
      createUpdatePlayer
      (
        id: awayPlayers.firstWhere((item) => item.name == player).id,
        player: awayPlayers.firstWhere((item) => item.name == player)
      );
    }

    appendGame(this);
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
      'redcards': this.redCards,
      'localsquad': this.localSquad,
      'awaysquad': this.awaySquad
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
      json['journey'] as int,
      json['localTeam'] as String,
      json['awayTeam'] as String,
      json['localGoals'] as int,
      json['awayGoals'] as int,
      json['goalScorers'] as Map<double,String>,
      json['yellowCards'] as Map<double,String>,
      json['redCards'] as Map<double,String>,
      json['localsquad'] as List<dynamic>,
      json['awaysquad'] as List<dynamic>
    );
  }

}
