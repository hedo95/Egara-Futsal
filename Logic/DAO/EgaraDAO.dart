import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show File;
import 'dart:convert' show json;
import 'dart:io';
import 'package:egarafutsal/Logic/Model/Player.dart';
import 'package:egarafutsal/Logic/Model/Team.dart';
import 'package:egarafutsal/Logic/Model/Game.dart';
import 'package:egarafutsal/Logic/Model/Journey.dart';
import 'package:egarafutsal/Logic/Model/User.dart';
import 'package:egarafutsal/Logic/BO/EgaraBO.dart';

String path = '/Users/jesushedo/Desktop/Q7/Android/Lib/EF_Backend/Data/',
       playersfile = path + 'Players.json',
       teamsfile = path + 'Teams.json',
       gamesfile = path + 'Games.json';




List<Player> getAllPlayersFromFile()
{
  exportPlayersFromGames();
  var jsonString = File(playersfile).readAsStringSync();
  List jsonData = json.decode(jsonString);
  return new List<Player>.from(jsonData.map((item) => new Player.fromJson(item)).toList());
}

List<Team> getAllTeamsFromFile()
{
  var jsonString = File(teamsfile).readAsStringSync();
  List jsonData = json.decode(jsonString);
  return new List<Team>.from(jsonData.map((item) => new Team.fromJson(item)).toList());
}

List<Game> getAllGamesFromFile()
{
  var jsonString = File(gamesfile).readAsStringSync();
  List jsonData = json.decode(jsonString);
  return new List<Game>.from(jsonData.map((item) => new Game.fromJson(item))).toList();
}

void exportPlayersFromGames() // Funciona
{
  List<Game> games = getAllGamesFromFile();
  List<Player> allplayers = [];
  for(var game in games)
  {
    for (var player in game.localSquad)
    {
      // Hacemos una especie de .distinct() para los jugadores de los encuentros
      if (!allplayers.any((item) => item.name == player.name && item.surname == player.surname  && player.dorsal == item.dorsal ))
      {
        allplayers.add(player);
      }
    }
    for (var player in game.awaySquad)
    {
      if (!allplayers.any((item) => item.name == player.name && item.surname == player.surname && player.dorsal == item.dorsal))
      {
        allplayers.add(player);
      }
    }
  }
  exportPlayersData(toAssignId(allplayers));
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
  for(int n = 0; n < jsonData.length; n++)
  {
    File(teamsfile).writeAsStringSync(jsonData[n].toString(), mode: FileMode.append);
  }
}

void exportGamesData(List<Game> data)
{
  data.sort((a,b) => a.id.compareTo(b.id));
  List<dynamic> jsonData = [];
  data.forEach((item) => jsonData.add(json.encode(item.toJson())));
  for(int n = 0; n < jsonData.length; n++)
  {
    File(gamesfile).writeAsStringSync(jsonData[n].toString(), mode: FileMode.append);
  }
}

void appendPlayer(Player obj)
{
  List<Player> data = getAllPlayersFromFile();
  if (!data.any((item) => (item.id == obj.id) || (item.dorsal == obj.dorsal)))
  {
    data.add(obj);
    exportPlayersData(data);
  }
}

void appendTeam(Team obj)
{
  List<Team> data = getAllTeamsFromFile();
  if (!data.any((item) => (item.id == obj.id) || (item.name == obj.name)))
  {
    data.add(obj);
    exportTeamsData(data);
  }
}

void appendGame(Game obj)
{
  List<Game> data = getAllGamesFromFile();
  if (!data.any((item) => item.id == obj.id))
  {
    data.add(obj);
    exportGamesData(data);
  }
}

