import 'dart:convert';
import 'dart:convert' show json;
import 'dart:io' show File;
import 'dart:io';

import '../Model/Game.dart';
import '../Model/Player.dart';
import '../Model/Team.dart';


// String path = '/Users/jesushedo/Flutter/Egara-Futsal/assets/Data',
//        playersfile = path + '/Players.json',
//        teamsfile = path + '/Teams.json',
//        gamesfile = path + '/Games.json';


// List<Team> getAllTeamsFromFile() {
//   var jsonString = File(teamsfile).readAsStringSync();
//   List jsonData = json.decode(jsonString);
//   return new List<Team>.from(
//       jsonData.map((item) => new Team.fromJson(item)).toList());
// }

// List<Game> getAllGamesFromFile() {
//   var jsonString = File(gamesfile).readAsStringSync();
//   List jsonData = json.decode(jsonString);
//   return new List<Game>.from(jsonData.map((item) => new Game.fromJson(item)))
//       .toList();
// }




// void exportTeamsData(List<Team> data) {
//   data.sort((a, b) => a.id.compareTo(b.id));
//   List<dynamic> jsonData = [];
//   data.forEach((item) => jsonData.add(json.encode(item.toJson())));
//   for (int n = 0; n < jsonData.length; n++) {
//     File(teamsfile)
//         .writeAsStringSync(jsonData[n].toString(), mode: FileMode.append);
//   }
// }

// void exportGamesData(List<Game> data) {
//   data.sort((a, b) => a.id.compareTo(b.id));
//   List<dynamic> jsonData = [];
//   data.forEach((item) => jsonData.add(json.encode(item.toJson())));
//   File(gamesfile).writeAsStringSync(jsonData.toString());
// }
