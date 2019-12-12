import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show File;
import 'dart:convert' show json;
import 'dart:io';



class StringConstant
{
  static const String table = "Clasificación";
  static const String nextgame = "Siguiente partido";
  static const String local = "Local";
  static const String away = "Visitante";
  static const String egarafutsal = "Egara Futsal 2019, C.F. SALA";
  static const String pts = "Pts";
  static const String h = 'h';
  static const String team = "Equipo";
  static const String teams = "Equipos";
  static const String players = "Jugadoras";
  static const String player = "Jugadora";
  static const String journeys = "Jornadas";
}

class User
{
  String  username, password, imagepath;

  User(this.username, this.password, this.imagepath);

  User.def()
  {
    this.username = "";
    this.password = "";
    this.imagepath = "";
  }
}

class Player
{
  // Professional data
  String name, surname;
  int idteam, dorsal; /*goals , yellowcards, redcards, playedGames; */ 

  int get goals
  {
    List<Game> games = getAllGamesFromFile().where((item) => item.localTeam.id == this.idteam || item.awayTeam.id == this.idteam).toList();
    int goals = 0;
    for(var game in games)
    {
      for(MapEntry<Player,List<int>> map in game.goalScorers.entries)
      {
        if(map.key.dorsal == this.dorsal && map.key.idteam == this.idteam)
        {
          goals += map.value.length;
        }
      }
    }
    return goals;
  }

  int get ycards
  {
    List<Game> games = getAllGamesFromFile().where((item) => item.localTeam.id == this.idteam || item.awayTeam.id == this.idteam).toList();;
    int ycards = 0;
    for(var game in games)
    {
      for(MapEntry<Player,List<int>> map in game.yellowCards.entries)
      {
        if(map.key.dorsal == this.dorsal && map.key.idteam == this.idteam)
        {
          ycards += map.value.length;
        }
      }
    }
    return ycards;
  }

  int get rcards
  {
    List<Game> games = getAllGamesFromFile().where((item) => item.localTeam.id == this.idteam || item.awayTeam.id == this.idteam).toList();;
    int rcards = 0;
    for(var game in games)
    {
      for(MapEntry<Player,List<int>> map in game.redCards.entries)
      {
        if(map.key.dorsal == this.dorsal && map.key.idteam == this.idteam)
        {
          rcards += map.value.length;
        }
      }
    }
    return rcards;
  }

  int get playedgames
  {
    List<Game> games = getAllGamesFromFile().where((item) => item.localTeam.id == this.idteam || item.awayTeam.id == this.idteam).toList();;
    int played = 0;
    for(var game in games)
    {
      if(game.localSquad.any((item) => item.dorsal == this.dorsal) || game.awaySquad.any((item) => item.dorsal == this.dorsal))
      {
        played++;
      }
    }
    return played;
  }

  Player
  (
    this.idteam,this.name, this.surname, 
    this.dorsal 
  );

  Player.def()
  {
    this.idteam = -1;
    this.name = "";
    this.surname = "";
    this.dorsal = 0;
  }


  toJson()
  {
    return 
    {
      'idteam': this.idteam,
      'name': this.name,
      'surname': this.surname,
      'dorsal': this.dorsal,
    };
  }

  toPrint()
  {
    String teamName = getAllTeamsFromFile().firstWhere((item) => item.id == this.idteam).name;
    {
      print("Name: " + this.name + "\n");
      print("Surname: " + this.surname + "\n");
      print("Team: " +  teamName + '\n');
      print("Dorsal: " + this.dorsal.toString() + "\n");
      print("Goals: " + this.goals.toString() + "\n");
      print("Yellow cards: " + this.ycards.toString() + "\n");
      print("Red cards: " + this.rcards.toString() + "\n");
      print("Played games: " + this.playedgames.toString() + "\n");
      print('');
    }
  }


  //Convert from Json to Object
  factory Player.fromJson(Map<String,dynamic> json)
  {
    return new Player
    (
      json['idteam'] as int,
      json['name'] as String,
      json['surname'] as String, 
      json['dorsal'] as int, 
      // json['totalgames'] as int
    );
  }

}

class Team
{
  int id;
  String name, shield, address, location, zipcode, province, fieldname, fieldtype;

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
    this.province, this.fieldname, this.fieldtype
  );

  Team.def()
  {
    this.id == getAllTeamsFromFile()[getAllTeamsFromFile().length - 1].id + 1;
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
    return 
    {
      'id': this.id,
      'name': this.name,
      'shield': this.shield,
      'address': this.address,
      'location': this.location,
      'zipcode': this.zipcode,
      'province': this.province,
      'fieldname': this.fieldname,
      'fieldtype': this.fieldtype,
    };
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
      json['fieldname'] as String,
      json['fieldtype'] as String,
    );
  }
}

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

    this.localTeam = getAllTeamsFromFile().firstWhere((item) => item.name == localteam);
    this.awayTeam = getAllTeamsFromFile().firstWhere((item) => item.name == awayteam);

    this.localSquad = mappingDataFromSquad(localsquad, localTeam);
    this.awaySquad = mappingDataFromSquad(awaysquad, awayTeam);

    this.goalScorers = mappingDataFromMaps(goalscorers, this.localSquad, this.awaySquad);
    this.yellowCards = mappingDataFromMaps(yellowcards, this.localSquad, this.awaySquad);
    this.redCards = mappingDataFromMaps(redcards, this.localSquad, this.awaySquad);
    
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

class Journey
{
  int id, journey;
  List<Game> games;

  Journey(this.games)
  {
    for(var game in this.games)
    {
      this.journey = game.journey;
      break;
    }
    this.id = 4000 + (this.journey - 1); // Solo sirve con el registro de una unica temporada
  }

}




// DAO

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
  exportPlayersData(allplayers);
}

void exportPlayersData(List<Player> data)
{
  data.sort((a,b) => a.surname.compareTo(b.surname));
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
  if (!data.any((item) => (item.idteam == obj.idteam) && (item.dorsal == obj.dorsal)))
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







// BO

int catchArrow() // Devuelve un 1, un 0 o un -1.
{
  Team egara = getAllTeamsFromFile().firstWhere((item) => item.id == 20008);
  int currentPosition = egara.currentPosition;
  int lastPosition = egara.lastCurrentPosition;
  if (currentPosition > lastPosition) { return 1; }
  else if (currentPosition == lastPosition) { return 0; }
  else { return -1; }
}


List<Player> getAllPlayersFromAteam(Team team)
{
  int id = team.id;
  return getAllPlayersFromFile().where((item) => item.idteam == id).toList();
}

// Funciona 
int maxPlayedJourney()
{
  return getAllGamesFromFile()[getAllGamesFromFile().length - 2].journey;
}

List<Player> topScorers()
{
  List<Player> result = [];
  List<Game> games = getAllGamesFromFile();
  for(var game in games)
  {
    for(var player in game.goalScorers.keys.toList())
    {
      // El siguiente if es un distinct para no introducir jugadores repetidos en la lista final
      if (!result.any((item) => item.idteam == player.idteam && item.dorsal == player.dorsal))
      {
        result.add(player);
      }
    }
  }
  result.sort((b,a) => a.goals.compareTo(b.goals));
  return result;
}

// Clasificamos los partidis por jornadas.
List<Journey> getCalendar(List<Game> games)
{
  List<Journey> result = [];
  games.sort((a,b) => a.journey.compareTo(b.journey));
  int max = games[games.length - 1].journey;
  for(int n = 1; n <= max; n++)
  {
    result.add(new Journey(games.where((item) => item.journey == n).toList()));
  }

  return result;
}

// Determina el ganador, para asignar puntos por encuentro
String whosWinner(int localGoals, int awayGoals)
{
  if (localGoals > awayGoals)
  {
     return "1";
  }

  else if (localGoals < awayGoals)
  {
    return "2";
  }

  else
  {
    return "X";
  }

}

Map<Player,List<int>> mappingDataFromMaps(Map<String,dynamic> obj, List<Player> localsquad, List<Player> awaysquad)
{
  Map<Player,List<int>> result = {};
  List<Player> players = [];
  players.addAll(localsquad + awaysquad);
  for(MapEntry<String,dynamic> map in obj.entries)
  { 
    List<int> value = new List<int>.from(map.value.whereType<dynamic>()).toList();
    String name = getNamesFromMap(map.key)[0];
    String surname = getNamesFromMap(map.key)[1];
    Player player = players.firstWhere((item) => (item.name == name && item.surname == surname) || (item.name == name && item.surname == ""));
    result.addAll({player :  value});
  } 

  return result; 
}

List<Player> mappingDataFromSquad(List<dynamic> squad, Team team)
{
  List<Player> result = [];

  for(String player in squad)
  {
    String name = getNamesSurnamesFromSquad(player)[0];
    String surname = getNamesSurnamesFromSquad(player)[1];
    int dorsal = getDorsal(player);
    int idteam = team.id;
    result.add(new Player(idteam, name, surname, dorsal));
  }

  return result;
}

int getDorsal(String fullname)
{
  int index = fullname.indexOf(' ');
  return int.parse(fullname.substring(0,index));
}

List<String> getNamesFromMap(String fullname)
{
  List<String> result = [];
  int index = fullname.indexOf(',');
  if(index == -1)
  {
    result.add(fullname);
    result.add("");
  }
  else
  {
    String name = fullname.substring(index+2, fullname.length);
    result.add(name);
    String surname = fullname.substring(0, index);
    result.add(surname);
  }

  return result;
}

List<String> getNamesSurnamesFromSquad(String fullname)
{
  List<String> result = [];

  int index = fullname.indexOf(',');

  if(index == -1)
  {
    index = fullname.indexOf(' ') + 1;
    String name = fullname.substring(index, fullname.length);
    String surname = "";
    result.add(name);
    result.add(surname);

  }

  else
  {
    int begin = fullname.indexOf(' ')+1;
    String name = fullname.substring(index+2, fullname.length);
    result.add(name); 
    String surname = fullname.substring(begin, index);
    result.add(surname);
  }
  return result;
}

List<Team> getHomepageLeagueContainer()
{ 
  List<Team> teams = getAllTeamsFromFile();
  Team egara = getAllTeamsFromFile().firstWhere((item) => item.id == 20008);
  int pos = egara.currentPosition; 
  Team teamA, teamB;
  if(pos == 1)
  {
    teamA = teams.firstWhere((item) => item.currentPosition == pos + 1);
    teamB = teams.firstWhere((item) => item.currentPosition == pos + 2);
    return [egara, teamA, teamB];
  }
  else if(pos == 12)
  {
    teamA = teams.firstWhere((item) => item.currentPosition == pos - 1);
    teamB = teams.firstWhere((item) => item.currentPosition == pos - 2);
    return [teamB, teamA, egara];
  }
  else
  {
    teamA = teams.firstWhere((item) => item.currentPosition == pos - 1);
    teamB = teams.firstWhere((item) => item.currentPosition == pos + 1);
    return [teamA, egara, teamB];
  }
}

List<int> getlast5results()
{
  List<Game> games = getAllGamesFromFile();
  List<int> list = [];
  List<Game> egaraGames = games.where((item) => (item.localTeam.id == 20008 || item.awayTeam.id == 20008) && (item.localSquad.isNotEmpty)).toList(); // Partidos del egara jugados.
  for(var game in egaraGames)
  {
    String result = whosWinner(game.localGoals, game.awayGoals);
    if(result == "1")
    {
      if(game.localTeam.id == 20008)
      {
        list.add(1);
      }
      else
      {
        list.add(-1);
      }
    }
    else if(result == "2")
    {
      if(game.awayTeam.id == 20008)
      {
        list.add(1);
      }
      else
      {
        list.add(-1);
      }
    }
    else
    {
      list.add(0);
    }
  }
  return list;
}

Player createUpdatePlayer({int id, Player player})
{
  if (id == null && player == null)
  {
    return createUpdatePlayer(player: new Player.def());
  }
  else if(id != null && player == null)
  {
    try
    {
      Player foundPlayer = getAllPlayersFromFile().firstWhere((item) => item.idteam == player.idteam && item.dorsal == player.dorsal);
      return createUpdatePlayer(player: foundPlayer);
    }
    catch (Exception)
    {
      return Exception('No se ha encontrado el modelo con id: ' + id.toString() + '\n');
    }
  }
  else 
  {
    var data = getAllPlayersFromFile();
    if (data.any((item) => item.idteam == player.idteam && item.dorsal == player.dorsal))
    {
      int index = data.indexWhere((item) => item.idteam == player.idteam && item.dorsal == player.dorsal);
      data.removeAt(index);
      data.add(player);
      exportPlayersData(data);
      return player;
    }
    else
    {
      data.add(player);
      exportPlayersData(data);
      return player;
    }
  }
}

Team createUpdateTeam({int id, Team team})
{
  if (id == null && team == null)
  {
    return createUpdateTeam(team: new Team.def());
  }
  else if(id != null && team == null)
  {
    try
    {
      Team foundTeam = getAllTeamsFromFile().firstWhere((item) => item.id == id);
      return createUpdateTeam(team: foundTeam);
    }
    catch (Exception)
    {
      return Exception('No se ha encontrado el equipo con id: ' + id.toString() + '\n');
    }
  }
  else 
  {
    var data = getAllTeamsFromFile();
    if (data.any((item) => item.id == team.id))
    {
      int index = data.indexWhere((item) => item.id == team.id);
      data.removeAt(index);
      data.add(team);
      exportTeamsData(data);
      return team;
    }
    else
    {
      data.add(team);
      exportTeamsData(data);
      return team;
    }
  }
}

bool deletePlayer(Player player)
{
  var data = getAllPlayersFromFile();
  try
  {
    Player item = data.firstWhere((item) => item.idteam == player.idteam && item.dorsal == player.dorsal);
    data.remove(item);
    exportPlayersData(data);
    return true;
  }
  catch (Exception)
  {
    return false;
  }
}

bool deleteTeam(Team team)
{
  var data = getAllTeamsFromFile();
  try
  {
    Team item = data.firstWhere((item) => item.id == team.id);
    data.remove(item);
    exportTeamsData(data);
    return true;
  }
  catch (Exception)
  {
    return false;
  }
}

bool deleteGame(Game match)
{
  var data = getAllGamesFromFile();
  try
  {
    Game item = data.firstWhere((item) => item.id == match.id);
    data.remove(item);
    exportGamesData(data);
    return true;
  }
  catch (Exception)
  {
    return false;
  }
}




void main() 
{
  // List<Player> players = getAllPlayersFromFile();
  // exportPlayersFromGames();
  // Player oumaima = players.firstWhere((item) => item.surname == "BEDDOUH");
  
  // print(oumaima.goals.toString() + ' Goals from Oumaima.' + '\n');

  // print("Get last 5 results: ");
  // getlast5results().forEach((item) => print(item.toString() + ' '));
  // print(' ');
  // print('Egara events: ');
  // Team egara = getAllTeamsFromFile().firstWhere((item) => item.id == 20008);
  // print(egara.currentPoints.toString() + " Current points.");
  // print(egara.currentPosition.toString() + " Current position.");
  // print(egara.lastCurrentPoints.toString() + " Last current points.");
  // print(egara.lastCurrentPosition.toString() + " Last current position.");
  // print(egara.currentGoals.toString() + " Current goals.");
  // print(egara.currentConcededGoals.toString() + " Current conceded goals.");
  // print(egara.currentYcards.toString() + " Current yellow cards.");
  // print(egara.currentRcards.toString() + " Current red cards.");
  // print(egara.totalGames.toString() + " Total games.");
  // print(egara.wonGames.toString() + " Won games.");
  // print(egara.drawnGames.toString() + " Drawn games.");
  // print(egara.lostGames.toString() + " Lost games.");
  // print(' ');
  // List<Team> teams = getHomepageLeagueContainer();
  // print(teams[0].currentPosition.toString()+ ' '+teams[0].name);
  // print(teams[1].currentPosition.toString()+ ' '+teams[1].name);
  // print(teams[2].currentPosition.toString()+ ' '+teams[2].name);
  
  // print(' ');
  // print('Maximos goleadores vigentes: ' + '\n');
  // topScorers().forEach((item) => print(item.name + ' ' + item.surname + ': ' + item.goals.toString() + ' goals.'));

  List<Team> teams = getAllTeamsFromFile();
  teams.sort((b,a) => a.currentPoints.compareTo(b.currentPoints));
  teams.forEach((f) => f.toPrint());

}
