import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show File;
import 'dart:convert' show json;
import 'dart:io';
import 'package:egarafutsal/Logic/BO/EgaraBO.dart';
import 'package:egarafutsal/Logic/DAO/EgaraDAO.dart';
import 'package:egarafutsal/Logic/Model/Player.dart';

class Team
{
  int id;
  String name, shield, address, location, zipcode, province, fieldname, fieldtype;
  List<Player> players = [];

  int points = 0, goals = 0, concededGoals = 0, yellowcards = 0, redcards = 0,
      wonGames = 0, drawnGames = 0, lostGames = 0, totalgames = 0;

  Team
  (
    this.id, this.name, this.shield, this.address, this.location, this.zipcode,
    this.province, this.fieldname, this.fieldtype
  )
  {
    this.points = 0;
    this.concededGoals = 0;
    this.yellowcards = 0;
    this.redcards = 0;
    this.wonGames = 0;
    this.drawnGames = 0;
    this.lostGames = 0;
    this.totalgames = 0;
  }

  Team.fromGame
  (
    this.id, this.name
  )
  {
    this.points = 0;
    this.concededGoals = 0;
    this.yellowcards = 0;
    this.redcards = 0;
    this.wonGames = 0;
    this.drawnGames = 0;
    this.lostGames = 0;
    this.totalgames = 0;
  }

  Team.def()
  {
    this.id = getId(getAllTeamsData());
    this.name = "";
    this.points = 0;
    this.goals = 0;
    this.concededGoals = 0;
    this.wonGames = 0;
    this.lostGames = 0;
    this.drawnGames = 0;
    this.yellowcards = 0;
    this.redcards = 0;
    this.totalgames = 0;
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
    print("Id: " + this.id.toString() + "\n");
    print("Name: " + this.name + "\n");
    print("Address: " + this.address + "\n");
    print("Location: " + this.location + "\n");
    print("Zipcode: " + this.zipcode + "\n");
    print("Province: " + this.province + "\n");
    print("Fieldname: " + this.fieldname + "\n");
    print("Fieldtype: " + this.fieldtype + "\n");
    print("Players: " + "\n");
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
