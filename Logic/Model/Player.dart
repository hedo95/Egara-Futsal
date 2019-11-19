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
  String position, name, surname, function;
  int id, dorsal, goals, yellowcards, redcards, playedGames;

  Player
  (
    this.id, this.name, this.surname, this.function, 
    this.dorsal,this.position, this.goals, 
    this.yellowcards, this.redcards, this.playedGames
  );


  Player.def()
  {
    this.id = getId(getAllPlayersData());
    this.name = "";
    this.surname = "";
    this.function = "";
    this.dorsal = 0;
    this.position = "";
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
      'name': this.name,
      'surname': this.surname,
      'function': this.function,
      'dorsal': this.dorsal,
      'position': this.position,
      'goals': this.goals,
      'yellowcards': this.yellowcards,
      'redcards': this.redcards,
      'playedgames': this.playedGames
    };
  }

  toPrint()
  {
    if(this.function == "Player")
    {
      print("Id: " + this.id.toString() + "\n");
      print("Name: " + this.name + "\n");
      print("Surname: " + this.surname + "\n");
      print("Function: " + this.function + "\n");
      print("Dorsal: " + this.dorsal.toString() + "\n");
      print("Position: " + this.position.toString() + "\n");
      print("Goals: " + this.goals.toString() + "\n");
      print("Yellow cards: " + this.yellowcards.toString() + "\n");
      print("Red cards: " + this.redcards.toString() + "\n");
      print("Played games: " + this.playedGames.toString() + "\n");
      print('');
    }
    else // function == "Coach"
    {
      print("Id: " + this.id.toString() + "\n");
      print("Name: " + this.name + "\n");
      print("Surname: " + this.surname + "\n");
      print("Function: " + this.function + "\n");
      print('');
    }
  }


  //Convert from Json to Object
  factory Player.fromJson(Map<String,dynamic> json)
  {
    return new Player
    (
      json['id'] as int,
      json['name'] as String,
      json['surname'] as String,
      json['function'] as String, 
      json['dorsal'] as int, 
      json['position'] as String,
      json['goals'] as int,
      json['yellowcards'] as int,
      json['redcards'] as int,
      json['playedgames'] as int
    );
  }

}
