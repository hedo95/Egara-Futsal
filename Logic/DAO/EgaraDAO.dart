import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show File;
import 'dart:convert' show json;
import 'dart:io';
import 'package:egarafutsal/Logic/Model/Player.dart';
import 'package:egarafutsal/Logic/Model/Team.dart';

String path = '/Users/jesushedo/Flutter/egarafutsal/Data/',
       playersfile = path + 'Players.json',
       teamsfile = path + 'Teams.json';

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

void appendPlayer(Player player)
{
  var data = getAllPlayersData();
  if (!data.any((item) => item.id == player.id))
  {
    data.add(player);
    exportPlayersData(data);
  }
}

void appendTeam(Team team)
{
  var data = getAllTeamsData();
  if (!data.any((item) => item.id == team.id))
  {
    data.add(team);
    exportTeamsData(data);
  }
}

