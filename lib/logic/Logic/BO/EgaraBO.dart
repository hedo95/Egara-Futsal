import '../DAO/EgaraDAO.dart';
import '../Model/Game.dart';
import '../Model/Journey.dart';
import '../Model/Player.dart';
import '../Model/Team.dart';


List<Player> getAllPlayers(List<Game> games)
{
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
  allplayers.sort((a,b) => a.idteam.compareTo(b.idteam));
  return allplayers;
}

int catchArrow(List<Team> teams, List<Game> games) // Devuelve un 1, un 0 o un -1.
{
  Team egara = teams.firstWhere((item) => item.id == 20008);
  int currentPosition = egara.currentPosition(teams,games);
  int lastPosition = egara.lastCurrentPosition(teams,games);
  if (currentPosition > lastPosition) { return 1; }
  else if (currentPosition == lastPosition) { return 0; }
  else { return -1; }
}



int currentJourney(List<Game> games){
  
  List<Journey> journeys = getCalendar(games);
  int result = journeys.lastWhere((item) => !item.games.any((item) => (item.localSquad.isEmpty || item.awaySquad.isEmpty))).journey + 1;
  return result;
}

List<Player> getAllPlayersFromAteam(Team team, List<Game> games)
{
  return getAllPlayers(games).where((item) => item.idteam == team.id).toList();
}

// Funciona 
int maxPlayedJourney(List<Game> games)
{
  // DateTime today = DateTime.now();
  // games.sort((b,a) => a.id.compareTo(b.id));
  // return games.firstWhere((item) => item.awaySquad.isEmpty && item.date.compareTo(today) > 0).journey - 1;
  return games[games.length-1].journey;
}

List<Player> topScorers(List<Game> games)
{
  List<Player> result = [];
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
  result.sort((b,a) => a.goals(games).compareTo(b.goals(games)));
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

Map<Player,List<int>> mappingDataFromMaps2(Map<dynamic,dynamic> obj, List<Player> localsquad, List<Player> awaysquad)
{
  Map<Player,List<int>> result = {};
  List<Player> players = [];
  players.addAll(localsquad + awaysquad);
  if(obj != null)
  {
    for(MapEntry<dynamic,dynamic> map in obj.entries)
    { 
      List<int> value = new List<int>.from(map.value.whereType<dynamic>()).toList();
      String key = map.key;
      String name = getNamesFromMap(key)[0];
      String surname = getNamesFromMap(key)[1];
      Player player = players.firstWhere((item) => (item.name == name && item.surname == surname) || (item.name == name && item.surname == ""));
      result.addAll({player :  value});
    } 
  }
  return result; 
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

List<Team> getHomepageLeagueContainer(List<Team> teams, List<Game> games)
{ 
  Team egara = teams.firstWhere((item) => item.id == 20008);
  int pos = egara.currentPosition(teams,games); 
  Team teamA, teamB;
  if(pos == 1)
  {
    teamA = teams.firstWhere((item) => item.currentPosition(teams,games) == pos + 1);
    teamB = teams.firstWhere((item) => item.currentPosition(teams,games) == pos + 2);
    return [egara, teamA, teamB];
  }
  else if(pos == 12)
  {
    teamA = teams.firstWhere((item) => item.currentPosition(teams,games) == pos - 1);
    teamB = teams.firstWhere((item) => item.currentPosition(teams,games) == pos - 2);
    return [teamB, teamA, egara];
  }
  else
  {
    teamA = teams.firstWhere((item) => item.currentPosition(teams,games) == pos - 1);
    teamB = teams.firstWhere((item) => item.currentPosition(teams,games) == pos + 1);
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

