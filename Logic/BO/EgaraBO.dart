import 'dart:convert';
import 'dart:core' as prefix0;
import 'dart:core';
import 'dart:ffi';
import 'dart:io' show File;
import 'dart:convert' show json;
import 'dart:io';
import 'package:egarafutsal/Logic/Model/Player.dart';
import 'package:egarafutsal/Logic/Model/Team.dart';
import 'package:egarafutsal/Logic/Model/Game.dart';
import 'package:egarafutsal/Logic/Model/Journey.dart';
import 'package:egarafutsal/Logic/Model/User.dart';
import 'package:egarafutsal/Logic/DAO/EgaraDAO.dart';

void exportPlayersFromGames()
{
  List<Game> games = getAllGamesData();
  List<Player> allplayers = [];
  for(var game in games)
  {
    for (var player in game.localSquad)
    {
      // Hacemos una especie de .distinct() para los jugadores de los encuentros
      if (!allplayers.any((item) => item.name == player.name && player.surname == player.surname && player.dorsal == item.dorsal))
      {
        allplayers.add(player);
      }
    }
    for (var player in game.awaySquad)
    {
      if (!allplayers.any((item) => item.name == player.name && player.surname == player.surname && player.dorsal == item.dorsal))
      {
        allplayers.add(player);
      }
    }
  }

  exportPlayersData(toAssignId(allplayers));
}

List<Player> toAssignId(List<Player> players)
{
  for(int n = 0; n < players.length; n++)
  {
    players[n].id += n;
  }

  return players;
}

int twolastResultsComparative()
{
  String egarafutsal = "Egara Futsal 2019, C.F. SALA";
  // Asignamos con numeros que ha hecho el egarafutsal en cada jornada, si ha ganado es un 1, si ha empatado 0, si ha perdido -1
  int one, two;
  List<Journey> calendar = getCalendar(getAllGamesData());
  // Cogemos las dos ultimas jornadas
  Journey present = calendar[calendar.length - 1];
  Journey past = calendar[calendar.length - 2];
  // Cogemos nuestros dos partidos y obtenemos su resultado en forma de quiniela.
  Game lastgame = present.games.firstWhere((item) => item.localTeam.name == egarafutsal || item.awayTeam.name == egarafutsal);
  String result1 = whosWinner(lastgame.localGoals, lastgame.awayGoals);
  if(lastgame.awayTeam.name == egarafutsal && result1 == "1")
  {
    one = -1;
  }
  else if(lastgame.awayTeam.name == egarafutsal && result1 == "2")
  {
    one = 1;
  }
  else if(lastgame.localTeam.name == egarafutsal && result1 == "1")
  {
    one = 1;
  }
  else if(lastgame.localTeam.name == egarafutsal && result1 == "2")
  {
    one = -1;
  }
  else
  {
    one = 0;
  }
  Game beforelastgame = past.games.firstWhere((item) => item.localTeam.name == egarafutsal || item.awayTeam.name == egarafutsal);
  String result2 = whosWinner(beforelastgame.localGoals, beforelastgame.awayGoals);
  if(beforelastgame.awayTeam.name == egarafutsal && result2 == "1")
  {
    two = -1;
  }
  else if(beforelastgame.awayTeam.name == egarafutsal && result2 == "2")
  {
    two = 1;
  }
  else if(beforelastgame.localTeam.name == egarafutsal && result2 == "1")
  {
    two = 1;
  }
  else if(beforelastgame.localTeam.name == egarafutsal && result2 == "2")
  {
    two = -1;
  }
  else
  {
    two = 0;
  }
  // Ahora compararemos el one y el two.
  if(one == two)
  {
    return 0;
  }
  else if(one > two)
  {
    return 1;
  }
  else
  {
    return -1;
  }
}

int getId(var data) 
{
  return data[data.length-1].id++;
}

int getTeamId(List<Team> teams)
{
  return teams[teams.length-1].id + 1;
}

int getIdfromTeam(Team team) => team.id; 

int gamesCounter(Team team)
{
  return team.wonGames + team.drawnGames + team.lostGames;
}

int maxJourney(List<Game> games)
{
  int max = 0;
  for(var game in games)
  {
    if (game.journey > max)
    {
      max = game.journey;
    }
  }
  return max;
}

List<Player> getPlayersRepeats(List<Game> games)
{
  List<Player> players = [];
  games.sort((a,b) => a.journey.compareTo(b.journey));
  int max = games[games.length-1].journey;
  for(var game in games)
  {
    game.localSquad.forEach((item) => players.add(item));
    game.awaySquad.forEach((item) => players.add(item));
  }

  players.sort((a,b) => a.surname.compareTo(b.surname));
  int count = 0;
  String name = players[0].name, surname = players[0].surname;
  count++;
  List<Player> result = [];
  for(int n = 1; n < players.length; n++)
  {
    if(players[n].name == name && players[n].surname == surname)
    {
      count++;
    }
    else
    {
      count = 0;
    }
    if (count > max)
    {
      result.add(players[n]);
    }
  }

  return result;
}

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

String whosWinner(int localGoals, int awayGoals)
{
  if (localGoals> awayGoals)
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

Map<String,List<int>> gettingMappedMaps(Map<String,dynamic> obj)
{
    var mappedMap = new Map<String,List<int>>();
    for(MapEntry<String,dynamic> map in obj.entries)
    {
      List<int> values = new List<int>.from(map.value);
      if (mappedMap == null)
      {
        mappedMap = {map.key : values};
      }
      else
      {
        mappedMap.addAll({map.key : values});
      }
    }

    return mappedMap;
}

Map<Player,List<int>> mappingDataFromMaps(Map<String,dynamic> obj, List<Player> localsquad, List<Player> awaysquad)
{
  Map<Player,List<int>> result = {};
  List<Player> players = [];
  players.addAll(localsquad + awaysquad);
  for(MapEntry<String,dynamic> map in obj.entries)
  { 
    List<int> value = new List<int>.from(map.value.whereType<List<dynamic>>()).toList();
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
    String name = getNamesSurnames(player)[0];
    String surname = getNamesSurnames(player)[1];
    int dorsal = getDorsal(player);
    int idteam = team.id;
    result.add(new Player.game(name, surname, dorsal, idteam));
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

List<String> getNamesSurnames(String fullname)
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
      Player foundPlayer = getAllPlayersData().firstWhere((item) => item.id == id);
      return createUpdatePlayer(player: foundPlayer);
    }
    catch (Exception)
    {
      return Exception('No se ha encontrado el modelo con id: ' + id.toString() + '\n');
    }
  }
  else 
  {
    var data = getAllPlayersData();
    if (data.any((item) => item.id == player.id))
    {
      int index = data.indexWhere((item) => item.id == player.id);
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
      Team foundTeam = getAllTeamsData().firstWhere((item) => item.id == id);
      return createUpdateTeam(team: foundTeam);
    }
    catch (Exception)
    {
      return Exception('No se ha encontrado el equipo con id: ' + id.toString() + '\n');
    }
  }
  else 
  {
    var data = getAllTeamsData();
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
  var data = getAllPlayersData();
  try
  {
    Player item = data.firstWhere((item) => item.id == player.id);
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
  var data = getAllTeamsData();
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
  var data = getAllGamesData();
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



