import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show File;
import 'dart:convert' show json;
import 'dart:io';
import 'package:egarafutsal/Logic/Model/Player.dart';
import 'package:egarafutsal/Logic/Model/Team.dart';
import 'package:egarafutsal/Logic/Model/Game.dart';

String path = '/Users/jesushedo/Flutter/egarafutsal/Data/',
       playersfile = path + 'Players.json',
       teamsfile = path + 'Teams.json',
       gamesfile = path + 'Games.json';




List<Player> getAllPlayersData()
{
  var jsonString = File(playersfile).readAsStringSync();
  List jsonData = json.decode(jsonString);
  return new List<Player>.from(jsonData.map((item) => new Player.fromJson(item)).toList());
}

List<Team> getAllTeamsData()
{
  var jsonString = File(teamsfile).readAsStringSync();
  List jsonData = json.decode(jsonString);
  return new List<Team>.from(jsonData.map((item) => new Team.fromJson(item)).toList());
}

List<Game> getAllGamesData()
{
  var jsonString = File(gamesfile).readAsStringSync();
  List jsonData = json.decode(jsonString);
  return new List<Game>.from(jsonData.map((item) => new Game.fromJson(item)).toList());
}




void exportPlayersData(List<Player> data)
{
  data.sort((a,b) => a.id.compareTo(b.id));
  List<dynamic> jsonData = [];
  data.forEach((item) => jsonData.add(json.encode(item.toJson())));
  File(playersfile).writeAsStringSync(jsonData.toString());
}

void exportTeamsData(List<Team> data)
{
  data.sort((a,b) => a.id.compareTo(b.id));
  List<dynamic> jsonData = [];
  data.forEach((item) => jsonData.add(json.encode(item.toJson())));
  File(teamsfile).writeAsStringSync(jsonData.toString());
}

void exportGamesData(List<Game> data)
{
  data.sort((a,b) => a.id.compareTo(b.id));
  List<dynamic> jsonData = [];
  data.forEach((item) => jsonData.add(json.encode(item.toJson())));
  File(gamesfile).writeAsStringSync(jsonData.toString());
}




void appendPlayer(Player obj)
{
  var data = getAllPlayersData();
  if (!data.any((item) => item.id == obj.id))
  {
    data.add(obj);
    exportPlayersData(data);
  }
}

void appendTeam(Team obj)
{
  var data = getAllTeamsData();
  if (!data.any((item) => item.id == obj.id))
  {
    data.add(obj);
    exportTeamsData(data);
  }
}

void appendGame(Game obj)
{
  var data = getAllGamesData();
  if (!data.any((item) => item.id == obj.id))
  {
    data.add(obj);
    exportGamesData(data);
  }
}
