import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show File;
import 'dart:convert' show json;
import 'dart:io';
import 'package:egarafutsal/Logic/BO/EgaraBO.dart';
import 'package:egarafutsal/Logic/DAO/EgaraDAO.dart';

class Game
{
  String localTeam, awayTeam;
  int id,localGoals, awayGoals;
  String fieldname;
  List<List<dynamic>> events; // events.forEach((event) => event[0] = "What"; event[1] = "Who" ; event[2] = Minute);

  Game(this.localTeam, this.awayTeam, this.localGoals, this.awayGoals, List<dynamic> actions)
  {
    this.id = getId(getAllGamesData());

    for(var action in actions)
    {
      this.events.add(action);
    }
  }

  Game.def()
  {
    this.localTeam = "";
    this.awayTeam = "";
    this.localGoals = 0;
    this.awayGoals = 0;
    this.events = [];
  }

  toJson()
  {
    return
    {
      'localTeam': this.localTeam,
      'awayTeam': this.awayTeam,
      'localGoals': this.localGoals,
      'awayGoals': this.awayGoals,
      'events': this.events
    };
  }

  toPrint()
  {
    print("Id: " + this.id.toString() + "\n");
    print("Local team: " + this.localTeam + "\n");
    print("Away team: " + this.awayTeam + "\n");
    print("Local goals: " + this.localGoals.toString() + "\n");
    print("Away goals: " + this.awayGoals.toString() + "\n");
    for(var event in this.events)
    {
      print(event[0] + ' ' + event[1] + " minuto " + event[2].toString() + "\n");
    }
    print(' ');
  }
}
