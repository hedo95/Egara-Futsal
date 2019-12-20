import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show File;
import 'dart:convert' show json;
import 'dart:io';
import 'package:egarafutsal/Logic/BO/EgaraBO.dart';
import 'package:egarafutsal/Logic/DAO/EgaraDAO.dart';

class Player
{
  // Professional data
  String name, surname;
  int idteam, dorsal; /*goals , yellowcards, redcards, playedGames; */ 

  int get goals
  {
    List<Game> games = getAllGamesFromFile().where((item) => item.localTeam.id == this.idteam || item.awayTeam.id == this.idteam).toList();
    int goals = 0;
    for(var game in games)
    {
      for(MapEntry<Player,List<int>> map in game.goalScorers.entries)
      {
        if(map.key.dorsal == this.dorsal && map.key.idteam == this.idteam)
        {
          goals += map.value.length;
        }
      }
    }
    return goals;
  }

  int get ycards
  {
    List<Game> games = getAllGamesFromFile().where((item) => item.localTeam.id == this.idteam || item.awayTeam.id == this.idteam).toList();;
    int ycards = 0;
    for(var game in games)
    {
      for(MapEntry<Player,List<int>> map in game.yellowCards.entries)
      {
        if(map.key.dorsal == this.dorsal && map.key.idteam == this.idteam)
        {
          ycards += map.value.length;
        }
      }
    }
    return ycards;
  }

  int get rcards
  {
    List<Game> games = getAllGamesFromFile().where((item) => item.localTeam.id == this.idteam || item.awayTeam.id == this.idteam).toList();;
    int rcards = 0;
    for(var game in games)
    {
      for(MapEntry<Player,List<int>> map in game.redCards.entries)
      {
        if(map.key.dorsal == this.dorsal && map.key.idteam == this.idteam)
        {
          rcards += map.value.length;
        }
      }
    }
    return rcards;
  }

  int get playedgames
  {
    List<Game> games = getAllGamesFromFile().where((item) => item.localTeam.id == this.idteam || item.awayTeam.id == this.idteam).toList();;
    int played = 0;
    for(var game in games)
    {
      if(game.localSquad.any((item) => item.dorsal == this.dorsal) || game.awaySquad.any((item) => item.dorsal == this.dorsal))
      {
        played++;
      }
    }
    return played;
  }

  Player
  (
    this.idteam,this.name, this.surname, 
    this.dorsal 
  );

  Player.def()
  {
    this.idteam = -1;
    this.name = "";
    this.surname = "";
    this.dorsal = 0;
  }


  toJson()
  {
    return 
    {
      'idteam': this.idteam,
      'name': this.name,
      'surname': this.surname,
      'dorsal': this.dorsal,
    };
  }

  toPrint()
  {
    String teamName = getAllTeamsFromFile().firstWhere((item) => item.id == this.idteam).name;
    {
      print("Name: " + this.name + "\n");
      print("Surname: " + this.surname + "\n");
      print("Team: " +  teamName + '\n');
      print("Dorsal: " + this.dorsal.toString() + "\n");
      print("Goals: " + this.goals.toString() + "\n");
      print("Yellow cards: " + this.ycards.toString() + "\n");
      print("Red cards: " + this.rcards.toString() + "\n");
      print("Played games: " + this.playedgames.toString() + "\n");
      print('');
    }
  }


  //Convert from Json to Object
  factory Player.fromJson(Map<String,dynamic> json)
  {
    return new Player
    (
      json['idteam'] as int,
      json['name'] as String,
      json['surname'] as String, 
      json['dorsal'] as int, 
      // json['totalgames'] as int
    );
  }

}
