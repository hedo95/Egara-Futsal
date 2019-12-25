
import 'package:egaradefinitiu/logic/Logic/Model/Team.dart';
import 'package:flutter/material.dart';

class TeamProvider with ChangeNotifier{

  List<Team> _teams;

  TeamProvider(List<Team> teams){
    this.teams = teams;
  }

  List<Team> get teams {
    return _teams;
  }

  set teams(List<Team> teams){
    this._teams = teams;
    notifyListeners();
  }

}