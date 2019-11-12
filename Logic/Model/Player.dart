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
  int id, dorsal;
  

  Player
  (
    this.id, this.name, this.surname, 
    this.function, this.dorsal,this.position
  );

  Player.def()
  {
    this.id = getId(getAllPlayersData());
    this.name = "";
    this.surname = "";
    this.function = "";
    this.dorsal = 0;
    this.position = "";
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
      print('');
    }
    else
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
    return new Player(json['id'] as int,
                  json['name'] as String,
                  json['surname'] as String,
                  json['function'] as String, 
                  json['dorsal'] as int, 
                  json['position'] as String);
  }


}
