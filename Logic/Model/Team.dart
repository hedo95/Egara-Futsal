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
  List<Player> players;

  Team(this.id, this.name, this.shield, this.address, this.location, 
       this.zipcode, this.province, this.fieldname, this.fieldtype, List<dynamic> playersid)
  {
    playersid = new List<int>.from(playersid.map((item) => int.parse(item)));
    playersid.forEach((player) => this.players.add(getAllPlayersData().firstWhere((item) => item.id == player)));
  }

  Team.def()
  {
    this.id = getId(getAllTeamsData());
    this.name = "";
    this.shield = "";
    this.address = "";
    this.location = "";
    this.zipcode = "";
    this.province = "";
    this.fieldname = "";
    this.fieldtype = "";
    this.players = [];
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
      'players': this.players.map((player) => player.id).toList()
    };
  }

  factory Team.fromJson(Map<String,dynamic> json)
  {
    return new Team(json['id'] as int,
                  json['name'] as String,
                  json['shield'] as String,
                  json['address'] as String, 
                  json['location'] as String, 
                  json['zipcode'] as String, 
                  json['province'] as String, 
                  json['fieldname'] as String,
                  json['fieldtype'] as String,
                  json['players'] as List<dynamic>);
  }
}
