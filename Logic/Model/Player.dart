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
  int id, idteam, dorsal, goals = 0, yellowcards = 0, redcards = 0, playedGames = 0;
  bool keeper = false, mister = false;

  Player
  (
    this.id, this.idteam,this.name, this.surname, 
    this.dorsal, this.goals, 
    this.yellowcards, this.redcards, this.playedGames
  );

  Player.game
  (
    String name, String surname, int dorsal, int idteam
  )
  {
    this.id = 10000;
    this.idteam = idteam;
    this.name = name;
    this.surname = surname;
    this.dorsal = dorsal;
    this.goals = 0;
    this.yellowcards = 0;
    this.redcards = 0;
    this.playedGames = 0;
  }


  Player.def()
  {
    this.id = getId(getAllPlayersData());
    this.idteam = -1;
    this.name = "";
    this.surname = "";
    this.dorsal = 0;
    this.goals = 0;
    this.yellowcards = 0;
    this.redcards = 0;
    this.playedGames = 0;
  }

  toJson()
  {
    return 
    {
      'id': this.id,
      'idteam': this.idteam,
      'name': this.name,
      'surname': this.surname,
      'dorsal': this.dorsal,
      'goals': this.goals,
      'yellowcards': this.yellowcards,
      'redcards': this.redcards,
      'playedgames': this.playedGames
    };
  }

  toPrint()
  {
    String teamName = getAllTeamsData().firstWhere((item) => item.id == this.idteam).name;
    {
      print("Id: " + this.id.toString() + "\n");
      print("Name: " + this.name + "\n");
      print("Surname: " + this.surname + "\n");
      print("Team: " +  teamName + '\n');
      print("Dorsal: " + this.dorsal.toString() + "\n");
      print("Goals: " + this.goals.toString() + "\n");
      print("Yellow cards: " + this.yellowcards.toString() + "\n");
      print("Red cards: " + this.redcards.toString() + "\n");
      print("Played games: " + this.playedGames.toString() + "\n");
      print('');
    }
  }


  //Convert from Json to Object
  factory Player.fromJson(Map<String,dynamic> json)
  {
    return new Player
    (
      json['id'] as int,
      json['idteam'] as int,
      json['name'] as String,
      json['surname'] as String, 
      json['dorsal'] as int, 
      json['goals'] as int,
      json['yellowcards'] as int,
      json['redcards'] as int,
      json['playedgames'] as int
    );
  }

}
