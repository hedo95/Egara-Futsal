import 'dart:convert';
import 'dart:convert' show json;
import 'dart:io' show File;
import 'dart:io';

import '../Model/Game.dart';
import '../Model/Player.dart';
import '../Model/Team.dart';


String path = '/Users/xavi/UPC/PrimerQuatri4t/Android/Projectes Flutter/Egara-Futsal/assets/Data',
       playersfile = path + '/Players.json',
       teamsfile = path + '/Teams.json',
       gamesfile = path + '/Games.json';

List<Player> getAllPlayersFromFile()
{
  exportPlayersFromGames();
  var jsonString = File(playersfile).readAsStringSync();
  List jsonData = json.decode(jsonString);
  return new List<Player>.from(
      jsonData.map((item) => new Player.fromJson(item)).toList());
}

List<Team> getAllTeamsFromFile() {
  var jsonString = File(teamsfile).readAsStringSync();
  List jsonData = json.decode(jsonString);
  return new List<Team>.from(
      jsonData.map((item) => new Team.fromJson(item)).toList());
}

List<Game> getAllGamesFromFile() {
  var jsonString = File(gamesfile).readAsStringSync();
  List jsonData = json.decode(jsonString);
  return new List<Game>.from(jsonData.map((item) => new Game.fromJson(item)))
      .toList();
  // List<Game> result = [];
  // var db = new FirebaseContext();
  // db.loadGames2().then((item) => result = item);
  // return result;
}

void exportPlayersFromGames() // Funciona
{
  List<Game> games = getAllGamesFromFile();
  List<Player> allplayers = [];
  for (var game in games) {
    for (var player in game.localSquad) {
      // Hacemos una especie de .distinct() para los jugadores de los encuentros
      if (!allplayers.any((item) =>
          item.name == player.name &&
          item.surname == player.surname &&
          player.dorsal == item.dorsal)) {
        allplayers.add(player);
      }
    }
    for (var player in game.awaySquad) {
      if (!allplayers.any((item) =>
          item.name == player.name &&
          item.surname == player.surname &&
          player.dorsal == item.dorsal)) {
        allplayers.add(player);
      }
    }
  }
  exportPlayersData(allplayers);
}

void exportPlayersData(List<Player> data) {
  data.sort((a, b) => a.idteam.compareTo(b.idteam));
  List<dynamic> jsonData = [];
  data.forEach((item) => jsonData.add(json.encode(item.toJson())));
  File(playersfile).writeAsStringSync(jsonData.toString());
}

void exportTeamsData(List<Team> data) {
  data.sort((a, b) => a.id.compareTo(b.id));
  List<dynamic> jsonData = [];
  data.forEach((item) => jsonData.add(json.encode(item.toJson())));
  for (int n = 0; n < jsonData.length; n++) {
    File(teamsfile)
        .writeAsStringSync(jsonData[n].toString(), mode: FileMode.append);
  }
}

void exportGamesData(List<Game> data) {
  data.sort((a, b) => a.id.compareTo(b.id));
  List<dynamic> jsonData = [];
  data.forEach((item) => jsonData.add(json.encode(item.toJson())));
  File(gamesfile).writeAsStringSync(jsonData.toString());
}

void appendPlayer(Player obj) {
  List<Player> data = getAllPlayersFromFile();
  if (!data.any(
      (item) => (item.idteam == obj.idteam) && (item.dorsal == obj.dorsal))) {
    data.add(obj);
    exportPlayersData(data);
  }
}

void appendTeam(Team obj) {
  List<Team> data = getAllTeamsFromFile();
  if (!data.any((item) => (item.id == obj.id) || (item.name == obj.name))) {
    data.add(obj);
    exportTeamsData(data);
  }
}

void appendGame(Game obj) {
  List<Game> data = getAllGamesFromFile();
  if (!data.any((item) => item.id == obj.id)) {
    data.add(obj);
    exportGamesData(data);
  }
}
