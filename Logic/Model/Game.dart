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
  int localGoals, awayGoals;
  String fieldname;
  List<List<dynamic>> events; // events.forEach((event) => event[0] = "What"; event[1] = "Who" ; event[2] = Minute);

  Game(this.localTeam, this.awayTeam, this.localGoals, this.awayGoals, List<dynamic> actions)
  {
    for(var action in actions)
    {
      this.events.add(action);
    }
  }
}