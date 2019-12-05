// BO

List<Player> toAssignId(List<Player> players) // Funciona
{
  for(int n = 0; n < players.length; n++)
  {
    players[n].id += n;
  }

  return players;
}

int twolastResultsComparative() // Funciona
{
  String egarafutsal = "Egara Futsal 2019, C.F. SALA";
  // Asignamos con numeros que ha hecho el egarafutsal en cada jornada, si ha ganado es un 1, si ha empatado 0, si ha perdido -1
  int one, two;
  List<Journey> calendar = getCalendar(getAllGamesFromFile());
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

int catchArrow() // Devuelve un 1, un 0 o un -1.
{
  List<Journey> journeys = getAllTeamsData();
  int journeyB = journeys[journeys.length - 1].journey;
  int journeyA = journeys[journeys.length - 2].journey;
  int currentPosition = journeys.firstWhere((item) => item.journey == journeyB).teams.firstWhere((item) => item.id == 20008).position;
  int lastPosition = journeys.firstWhere((item) => item.journey == journeyA).teams.firstWhere((item) => item.id == 20008).position;
  if (currentPosition > lastPosition) { return 1; }
  else if (currentPosition == lastPosition) { return 0; }
  else { return -1; }
}

// Asignar automaticamente un 'id', cogiendo el anterior sumandole 1.
int getId(var data) 
{
  return data[data.length-1].id++;
}

int getIdfromTeam(Team team) => team.id; 

//Cogemos los equipos con los datos personales de su fichero, y datos estadisticos del fichero de los partidos.
List<Journey> getAllTeamsData() // Funciona
{
  List<Game> games = getAllGamesFromFile().where((item) => item.localSquad.isNotEmpty).toList(); // Partidods jugados
  List<Team> teams = getAllTeamsFromFile().toList();
  List<Journey> journeys = getCalendar(games);
  for(var journey in journeys)
  {
    for(var match in journey.games)
    {
      Team localTeam = teams.firstWhere((item) => item.name == match.localTeam.name);
      Team awayTeam = teams.firstWhere((item) => item.name == match.awayTeam.name);
      localTeam.totalgames++;
      awayTeam.totalgames++;
      localTeam.goals += match.localGoals;
      localTeam.concededGoals += match.awayGoals;
      awayTeam.goals += match.localGoals;
      awayTeam.concededGoals += match.localGoals;
      for(MapEntry<Player,List<int>> map in match.yellowCards.entries)
      {
        if (map.key.idteam == localTeam.id)
        {
          localTeam.yellowcards++;
        }
        else
        {
          awayTeam.yellowcards++;
        }
      }
      for(MapEntry<Player,List<int>> map in match.redCards.entries)
      {
        if (map.key.idteam == localTeam.id)
        {
          localTeam.redcards++;
        }
        else
        {
          awayTeam.redcards++;
        }
      }
      String result = whosWinner(match.localGoals, match.awayGoals);
      if(result == "1")
      {
        localTeam.points += 3; 
        localTeam.wonGames++;
        awayTeam.lostGames++;
      }
      else if(result == "2")
      {
        awayTeam.points += 3;
        awayTeam.wonGames++;
        localTeam.lostGames;;
      }
      else
      {
        localTeam.points++; awayTeam.points++;
        localTeam.drawnGames++; awayTeam.drawnGames++;
      }

      int localTeamindex = teams.indexOf(localTeam);
      teams.removeAt(localTeamindex);
      teams.add(localTeam);
      
      int awayTeamindex = teams.indexOf(awayTeam);
      teams.removeAt(awayTeamindex);
      teams.add(awayTeam);
    }
    teams.sort((b,a) => a.points.compareTo(b.points)); // Ordenamos por puntos
    for(int k = 0; k < teams.length; k++)
    {
      teams[k].position = k+1; // Asignamos posición de la tabla 
    }
    journey.addTeams(teams);
  }
  
  return journeys;
}

// Cogemos los jugadores con los datos personales de su fichero, y datos estadisticos del fichero de los partidos.
List<Journey> getAllPlayersData()
{
  List<Game> games = getAllGamesFromFile();
  List<Player> players = getAllPlayersFromFile();
  var journeys = getCalendar(games);
  for(var journey in journeys)
  {
    for(var match in journey.games)
    {
      for(var player in match.localSquad)
      {
        players.firstWhere((item) => item.dorsal == player.dorsal && item.idteam == player.idteam).playedGames++;
      }
      for(var player in match.awaySquad)
      {
        players.firstWhere((item) => item.dorsal == player.dorsal && item.idteam == player.idteam).playedGames++;
      }
      for(MapEntry<Player,List<int>> map in match.yellowCards.entries)
      {
        players.firstWhere((item) => item.dorsal == map.key.dorsal && item.idteam == map.key.idteam).yellowcards++;
      }
      for(MapEntry<Player,List<int>> map in match.redCards.entries)
      {
        players.firstWhere((item) => item.dorsal == map.key.dorsal && item.idteam == map.key.idteam).redcards++;
      }
      for(MapEntry<Player,List<int>> map in match.goalScorers.entries)
      {
        players.firstWhere((item) => item.dorsal == map.key.dorsal && item.idteam == map.key.idteam).goals++;
      }
    }
    players.sort((b,a) => a.goals.compareTo(b.goals));
    journey.addPlayers(players);
  }
  return journeys;
}


List<Journey> getAllJourneys()
{
  var result = getAllTeamsData(); // Aquí tenemos partidos y equipos mapeados.
  for(var journey in result)
  {
    List<Player> players = getAllPlayersData().firstWhere((item) => item.journey == journey.journey).players;
    journey.addPlayers(players);  // Introducimos juagodres mapeados
  }
  return result; // Lista por jornadas de todos los datos de la App mapeados: Partidos, equipos y jugadores clasificados por jornadas. 
}

// Funciona 
int maxJourney(List<Game> games)  => games.firstWhere((item) => item.localSquad.isEmpty).journey - 1;


List<Player> getPlayersRepeats(List<Game> games) // Funciona, para cuando se cuela algún string repeat en games.json
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

List<Team> getHomepageLeagueContainer()
{
  List<Journey> journeys = getAllTeamsData();
  int index = journeys.length - 1;
  List<Team> teams = journeys[index].teams;
  int pos = teams.indexWhere((item) => item.id == 20008); // Sacamos el indice del Egara futsal
  if(pos == 0)
  {
    return [teams[pos], teams[pos+1], teams[pos+2]];
  }
  else if(pos == (getAllTeamsData().length - 1))
  {
    return [teams[pos-2], teams[pos-1], teams[pos]];
  }
  else
  {
    return [teams[pos-1], teams[pos], teams[pos+1]];
  }
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
      Player foundPlayer = getAllPlayersFromFile().firstWhere((item) => item.id == id);
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

