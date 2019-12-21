import 'package:cloud_firestore/cloud_firestore.dart';
import '../BO/EgaraBO.dart';
import '../DAO/EgaraDAO.dart';
import 'Game.dart';
import 'Player.dart';


class Team
{
  int id;
  String name, shield, address, location, zipcode, 
         province, fieldname, fieldtype, documentID;
  List<double> coordenadas;
  bool parking;

  // Nos interesa coger los puntos y posición de las dos ultimas jornadas, para el container de la vista Principal.    
  int get currentPoints
  {
    int points = 0;
    List<Game> games = getAllGamesFromFile().where((item) => item.localSquad.isNotEmpty && (item.localTeam.id == this.id || item.awayTeam.id == this.id)).toList();
    for(var game in games)
    {
      String result = whosWinner(game.localGoals, game.awayGoals);
      if(result == "1" && game.localTeam.id == this.id)
      {
        points += 3;
      }
      else if(result == "2" && game.awayTeam.id == this.id)
      {
        points += 3;
      }
      else
      {
        points++;
      }
    }
    return points;
  }
  
  int get currentPosition
  {
    List<Team> teams = getAllTeamsFromFile();
    teams.sort((b,a) => a.currentPoints.compareTo(b.currentPoints));
    var egara = teams.firstWhere((item) => item.id == this.id);
    return teams.indexOf(egara) + 1;
  }

  int get lastCurrentPoints
  {
    int points = 0;
    int journeyWanted = getAllGamesFromFile().firstWhere((item) => item.localSquad.isEmpty).journey - 2;
    List<Game> games = getAllGamesFromFile().where((item) => item.journey <= journeyWanted && (item.localTeam.id == this.id || item.awayTeam.id == this.id)).toList();
    for(var game in games)
    {
      String result = whosWinner(game.localGoals, game.awayGoals);
      if(result == "1" && game.localTeam.id == this.id)
      {
        points += 3;
      }
      else if(result == "2" && game.awayTeam.id == this.id)
      {
        points += 3;
      }
      else
      {
        points++;
      }
    }
    return points;
  }

  int get lastCurrentPosition
  {
    List<Team> teams = getAllTeamsFromFile();
    teams.sort((b,a) => a.lastCurrentPoints.compareTo(b.lastCurrentPoints));
    var egara = teams.firstWhere((item) => item.id == this.id);
    return teams.indexOf(egara) + 1;
  }
  
  int get currentGoals
  {
    int goals = 0;
    List<Game> games = getAllGamesFromFile().where((item) => item.localSquad.isNotEmpty && (item.localTeam.id == this.id || item.awayTeam.id == this.id)).toList();
    for(var game in games)
    {
      for(MapEntry<Player,List<int>> map in game.goalScorers.entries)
      {
        if(map.key.idteam == this.id)
        {
          goals += map.value.length;
        }
      }
    }
    return goals;
  }

  int get currentConcededGoals
  {
    int goals = 0;
    List<Game> games = getAllGamesFromFile().where((item) => item.localSquad.isNotEmpty && (item.localTeam.id == this.id || item.awayTeam.id == this.id)).toList();
    for(var game in games)
    {
      for(MapEntry<Player,List<int>> map in game.goalScorers.entries)
      {
        if(map.key.idteam != this.id)
        {
          goals += map.value.length;
        }
      }
    }
    return goals;
  }

  int get currentYcards
  {
    int ycards = 0;
    List<Game> games = getAllGamesFromFile().where((item) => item.localSquad.isNotEmpty && (item.localTeam.id == this.id || item.awayTeam.id == this.id)).toList();
    for(var game in games)
    {
      for(MapEntry<Player,List<int>> map in game.yellowCards.entries)
      {
        if(map.key.idteam == this.id)
        {
          ycards += map.value.length;
        }
      }
    }
    return ycards;
  }

  int get currentRcards
  {
    int rcards = 0;
    List<Game> games = getAllGamesFromFile().where((item) => item.localSquad.isNotEmpty && (item.localTeam.id == this.id || item.awayTeam.id == this.id)).toList();
    for(var game in games)
    {
      for(MapEntry<Player,List<int>> map in game.redCards.entries)
      {
        if(map.key.idteam == this.id)
        {
          rcards += map.value.length;
        }
      }
    }
    return rcards;
  }

  int get totalGames
  {
    List<Game> games = getAllGamesFromFile().where((item) => item.localSquad.isNotEmpty && (item.localTeam.id == this.id || item.awayTeam.id == this.id)).toList();
    return games.length;
  }

  int get wonGames
  {
    int wongames = 0;
    List<Game> games = getAllGamesFromFile().where((item) => item.localSquad.isNotEmpty && (item.localTeam.id == this.id || item.awayTeam.id == this.id)).toList();
    for(var game in games)
    {
      String result = whosWinner(game.localGoals, game.awayGoals);
      if(result == "1" && game.localTeam.id == this.id)
      {
        wongames++;
      }
      if(result == "2" && game.awayTeam.id == this.id)
      {
        wongames++;
      }
    }
    return wongames;
  }

  int get drawnGames
  {
    int drawngames = 0;
    List<Game> games = getAllGamesFromFile().where((item) => item.localSquad.isNotEmpty && (item.localTeam.id == this.id || item.awayTeam.id == this.id)).toList();
    for(var game in games)
    {
      String result = whosWinner(game.localGoals, game.awayGoals);
      if(result == "X")
      {
        drawngames++;
      }
    }
    return drawngames;
  }
  
  int get lostGames
  {
    return this.totalGames - (this.wonGames + this.drawnGames);
  }

  Team
  (
    this.id, this.name, this.shield, this.address, this.location, this.zipcode,
    this.province, List<dynamic> coordenadas, this.fieldname, this.fieldtype,
    this.parking
  )
  {
    this.coordenadas = coordenadas.cast<double>();
  }

  Team.db
  (
    this.id, this.name, this.shield, this.address, this.location, this.zipcode,
    this.province, this.fieldname, this.fieldtype, this.documentID
  );

  Team.def()
  {
    this.id = getAllTeamsFromFile()[getAllTeamsFromFile().length - 1].id + 1;
    this.name = "";
    this.shield = "";
    this.address = "";
    this.location = "";
    this.zipcode = "";
    this.province = "";
    this.fieldname = "";
    this.fieldtype = "";
  }

  toJson()
  {
    List<dynamic> coordenadas = [];
    this.coordenadas.forEach((coordenada) => coordenadas.add(coordenada));
    return 
    {
      'id': this.id,
      'name': this.name,
      'shield': this.shield,
      'address': this.address,
      'location': this.location,
      'zipcode': this.zipcode,
      'province': this.province,
      'coordenadas': coordenadas,
      'fieldname': this.fieldname,
      'fieldtype': this.fieldtype,
      'parking': this.parking
    };
  }

  toDocument()
  {
    toJson();
  }

  toPrint()
  {
    //print("Id: " + this.id.toString() + "\n");
    print(this.name + ' => ' +this.currentPoints.toString() + ' points, ' + this.wonGames.toString() + ' won games, ' + this.lostGames.toString() + ' lost games, ' + this.drawnGames.toString() + ' drawn games, '+  this.currentGoals.toString() + ' goals and ' + this.currentConcededGoals.toString() + ' conceded goals. ' + "\n");
    //print("Address: " + this.address + "\n");
    //print("Location: " + this.location + "\n");
    // print("Zipcode: " + this.zipcode + "\n");
    // print("Province: " + this.province + "\n");
    // print("Fieldname: " + this.fieldname + "\n");
    // print("Fieldtype: " + this.fieldtype + "\n");
    // print("Players: " + "\n");
    print(' ');
  }

  factory Team.fromJson(Map<String,dynamic> json)
  {
    return new Team
    (
      json['id'] as int,
      json['name'] as String,
      json['shield'] as String,
      json['address'] as String, 
      json['location'] as String, 
      json['zipcode'] as String, 
      json['province'] as String, 
      json['coordenadas'] as List<dynamic>,
      json['fieldname'] as String,
      json['fieldtype'] as String,
      json['parking'] as bool
    );
  }

  static Team fromSnapshot(DocumentSnapshot snap)
  {
    return new Team.db
    (
      snap['id'] as int,
      snap['name'] as String,
      snap['shield'] as String,
      snap['address'] as String, 
      snap['location'] as String, 
      snap['zipcode'] as String, 
      snap['province'] as String, 
      snap['fieldname'] as String,
      snap['fieldtype'] as String,
      snap.documentID
    );
  }
}
