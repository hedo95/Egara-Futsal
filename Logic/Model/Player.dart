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
  String position, name, surname, nationality, function;
  int id, dorsal;
  

  // Personal data
  DateTime birthday;
  double height, weight;
  String dni, ss, address, phone, mail;

  Player
  (
    this.id, this.name, this.surname, this.function, this.dorsal,
    this.position, this.nationality, this.birthday, this.height, 
    this.weight, this.dni, this.ss, this.address, this.phone, this.mail
  );

  Player.def()
  {
    this.id = getId(getAllPlayersData());
    this.name = "";
    this.surname = "";
    this.function = "";
    this.dorsal = 0;
    this.position = "";
    this.nationality = "";
    this.birthday = DateTime.parse('0000-00-00 00:00:00');
    this.height = 0;
    this.weight = 0;
    this.dni = "";
    this.ss = "";
    this.address = "";
    this.phone = "";
    this.mail = "";
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
      'nationality': this.nationality,
      'birthday': this.birthday,
      'height': this.height,
      'weight': this.weight,
      'dni': this.dni,
      'ss': this.ss,
      'address': this.address,
      'phone': this.phone,
      'mail': this.mail
    };
  }

  toPrintAll()
  {
    print("Id: " + this.id.toString() + "\n");
    print("Name: " + this.name + "\n");
    print("Surname: " + this.surname + "\n");
    print("Function: " + this.function + "\n");
    print("Dorsal: " + this.dorsal.toString() + "\n");
    print("Position: " + this.position.toString() + "\n");
    print("Nationality: " + this.nationality + "\n");
    print("Birthday : " + this.birthday.toString().substring(0,this.birthday.toString().length - 13) + "\n");
    print("Height: " + this.height.toString() + "\n");
    print("Weight: " + this.weight.toString() + "\n");
    print("Dni/Nif: " + this.dni + "\n");
    print("SS: " + this.ss + "\n");
    print("Address: " + this.address + "\n");
    print("Phone: " + this.phone + "\n");
    print("Mail: " + this.mail + "\n");
    print('');
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
                  json['position'] as String, 
                  json['nationality'] as String,
                  DateTime.parse(json['birthday']), 
                  json['height'] as double,
                  json['weight'] as double,
                  json['dni'] as String,
                  json['ss'] as String,
                  json['address'] as String,
                  json['phone'] as String,
                  json['mail'] as String);
  }


}
