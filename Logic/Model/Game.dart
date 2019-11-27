import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show File;
import 'dart:convert' show json;
import 'dart:io';
import 'package:egarafutsal/Logic/BO/EgaraBO.dart';
import 'package:egarafutsal/Logic/DAO/EgaraDAO.dart';
import 'package:egarafutsal/Logic/Model/Team.dart';

class Game
{
  Team localTeam, awayTeam;
  int id,localGoals, awayGoals, journey;
  List<int> season;
  DateTime date;
  Map<Player,List<int>> goalScorers; 
  Map<Player,List<int>> yellowCards;
  Map<Player,List<int>> redCards;
  List<Player> localSquad, awaySquad;



  Game
  (
    List<dynamic> season, this.date, this.journey,
    String localteam, String awayteam, 
    this.localGoals,this.awayGoals, Map<String,dynamic> goalscorers, 
    Map<String,dynamic> yellowcards, Map<String,dynamic> redcards, 
    List<dynamic> localsquad, List<dynamic> awaysquad,
    [this.id]
  )
  {
    this.season = new List<int>.from(season.whereType<List<dynamic>>()).toList();
    this.localSquad = []; this.awaySquad = [];

    this.localTeam = getAllTeamsData().firstWhere((item) => item.name == localteam);
    this.awayTeam = getAllTeamsData().firstWhere((item) => item.name == awayteam);

    this.localSquad = mappingDataFromSquad(localsquad, localTeam);
    this.awaySquad = mappingDataFromSquad(awaysquad, awayTeam);

    this.goalScorers = mappingDataFromMaps(goalscorers, this.localSquad, this.awaySquad);
    this.yellowCards = mappingDataFromMaps(yellowcards, this.localSquad, this.awaySquad);
    this.redCards = mappingDataFromMaps(redcards, this.localSquad, this.awaySquad);
    
  }


  Game.def()
  {
    this.id = getId(getAllGamesData());
    this.journey = maxJourney(getAllGamesData()) +1;
    this.localTeam = Team.def();
    this.awayTeam = Team.def();
    this.localGoals = 0;
    this.awayGoals = 0;
    this.goalScorers = {};
    this.yellowCards = {};
    this.redCards = {};
  }

  toJson()
  {
    return
    {
      'localTeam': this.localTeam,
      'awayTeam': this.awayTeam,
      'localGoals': this.localGoals,
      'awayGoals': this.awayGoals,
      'goalScorers': this.goalScorers,
      'yellowcards': this.yellowCards,
      'redcards': this.redCards,
      'localsquad': this.localSquad,
      'awaysquad': this.awaySquad
    };
  }

  // toPrint()
  // {
  //   print("Id: " + this.id.toString() + "\n");
  //   print("Local team: " + this.localTeam + "\n");
  //   print("Away team: " + this.awayTeam + "\n");
  //   print("Local goals: " + this.localGoals.toString() + "\n");
  //   print("Away goals: " + this.awayGoals.toString() + "\n");
  // }

  factory Game.fromJson(Map<String,dynamic> json)
  {
    return new Game
    (
      json['season'] as List<dynamic>,
      DateTime.parse(json['date']),
      json['journey'] as int,
      json['localTeam'] as String,
      json['awayTeam'] as String,
      json['localGoals'] as int,
      json['awayGoals'] as int,
      json['goalScorers'] as Map<String,dynamic>,
      json['yellowCards'] as Map<String,dynamic>,
      json['redCards'] as Map<String,dynamic>,
      json['localsquad'] as List<dynamic>,
      json['awaysquad'] as List<dynamic>,
      json['id'] as int
    );
  }

}
