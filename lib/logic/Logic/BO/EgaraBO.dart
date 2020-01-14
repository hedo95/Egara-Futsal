import 'dart:collection';

import '../DAO/EgaraDAO.dart';
import '../Model/Game.dart';
import '../Model/Journey.dart';
import '../Model/Player.dart';
import '../Model/Team.dart';

List<Player> getAllPlayers(List<Game> games) {
  List<Player> allplayers = [];
  for (var game in games) {
    for (var player in game.localSquad) {
      // Hacemos una especie de .distinct() para los jugadores de los encuentros
      if (!allplayers.any((item) =>
          item.idteam == player.idteam && player.dorsal == item.dorsal)) {
        allplayers.add(player);
      }
    }
    for (var player in game.awaySquad) {
      if (!allplayers.any((item) =>
          item.idteam == player.idteam && player.dorsal == item.dorsal)) {
        allplayers.add(player);
      }
    }
  }
  allplayers.sort((a, b) => a.idteam.compareTo(b.idteam));
  return allplayers;
}

int catchArrow(List<Team> teams,
    List<Game> games) // Devuelve cuantas pos ha subido o bajado
{
  Team egara = teams.firstWhere((item) => item.id == 20008);
  int currentPosition = egara.currentPosition(teams, games);
  int lastPosition = egara.weekAgoPosition(teams, games);
  return lastPosition - currentPosition;
}

int currentJourney(List<Game> games) {
  List<Journey> journeys = getCalendar(games);
  int result = journeys
          .lastWhere((journey) => !journey.games.any(
              (game) => (game.localSquad.isEmpty || game.awaySquad.isEmpty)))
          .journey +
      1;
  return result;
}

List<Player> getAllPlayersFromAteam(Team team, List<Game> games) {
  return getAllPlayers(games).where((item) => item.idteam == team.id).toList();
}

// Funciona
int maxPlayedJourney(List<Game> games) {
  games.sort((a, b) => a.id.compareTo(b.id));
  return games
      .lastWhere(
          (item) => item.localSquad.isNotEmpty && item.awaySquad.isNotEmpty)
      .journey;
}

Map<Player, int> topScorers(List<Game> games) {
  Map<Player, int> result = {};
  for (var game in games) {
    for (var player in game.goalScorers.keys.toList()) {
      // El siguiente if es un distinct para no introducir jugadores repetidos en la lista final
      if (!result.keys.any((item) =>
          item.dorsal == player.dorsal && item.idteam == player.idteam)) {
        result.addAll({player: game.goalScorers[player].length});
      } else {
        Player obj = result.keys.firstWhere((item) =>
            item.dorsal == player.dorsal && item.idteam == player.idteam);
        result[obj] += game.goalScorers[player].length;
      }
    }
  }
  var goals = result.values
      .toSet()
      .toList(); // Lista de goles irrepetidos. Lo metemos en una lista para tener el metodo 'sort()'.
  goals.sort((b, a) => a.compareTo(b)); // Ordenamos de mayor a menor
  goals.removeRange(3, goals.length); // Nos quedamos con los 3 maximos goles
  result.removeWhere((k, v) => !goals.contains(
      v)); // Borramos jugadores que no hayan marcado los 3 maximos goles
  var sortedKeys = result.keys.toList(
      growable: false) // Ordenamos los goleadores de mayor a menor por goles
    ..sort((k2, k1) => result[k1].compareTo(result[k2]));
  LinkedHashMap<Player, int> sortedMap =
      new LinkedHashMap<Player, int>.fromIterable(sortedKeys,
          key: (k) => k, value: (k) => result[k]);

  return sortedMap;
}

// Clasificamos los partidis por jornadas.
List<Journey> getCalendar(List<Game> games) {
  List<Journey> result = [];
  games.sort((a, b) => a.journey.compareTo(b.journey));
  int max = games[games.length - 1].journey;
  for (int n = 1; n <= max; n++) {
    result.add(new Journey(games.where((item) => item.journey == n).toList()));
  }

  return result;
}

// Determina el ganador, para asignar puntos por encuentro
String whosWinner(int localGoals, int awayGoals) {
  if (localGoals > awayGoals) {
    return '1';
  } else if (localGoals < awayGoals) {
    return '2';
  } else {
    return 'X';
  }
}

Map<Player, List<int>> mappingDataFromMaps2(Map<dynamic, dynamic> obj,
    List<Player> localsquad, List<Player> awaysquad) {
  Map<Player, List<int>> result = {};
  List<Player> players = [];
  players.addAll(localsquad + awaysquad);
  if (obj != null) {
    for (MapEntry<dynamic, dynamic> map in obj.entries) {
      List<int> value =
          new List<int>.from(map.value.whereType<dynamic>()).toList();
      String key = map.key;
      String name = getNamesFromMap(key)[0];
      String surname = getNamesFromMap(key)[1];
      Player player = players.firstWhere((item) =>
          (item.name == name && item.surname == surname) ||
          (item.name == name && item.surname == ""));
      result.addAll({player: value});
    }
  }
  return result;
}

Map<Player, List<int>> mappingDataFromMaps(
    Map<String, dynamic> obj, List<Player> localsquad, List<Player> awaysquad) {
  Map<Player, List<int>> result = {};
  List<Player> players = [];
  players.addAll(localsquad + awaysquad);
  for (MapEntry<String, dynamic> map in obj.entries) {
    List<int> value =
        new List<int>.from(map.value.whereType<dynamic>()).toList();
    String name = getNamesFromMap(map.key)[0];
    String surname = getNamesFromMap(map.key)[1];
    Player player = players.firstWhere((item) =>
        (item.name == name && item.surname == surname) ||
        (item.name == name && item.surname == ""));
    result.addAll({player: value});
  }

  return result;
}

List<Player> mappingDataFromSquad(List<dynamic> squad, Team team) {
  List<Player> result = [];

  for (String player in squad) {
    String name = getNamesSurnamesFromSquad(player)[0];
    String surname = getNamesSurnamesFromSquad(player)[1];
    int dorsal = getDorsal(player);
    int idteam = team.id;
    result.add(new Player(idteam, name, surname, dorsal));
  }

  return result;
}

int getDorsal(String fullname) {
  int index = fullname.indexOf(' ');
  return int.parse(fullname.substring(0, index));
}

List<String> getNamesFromMap(String fullname) {
  List<String> result = [];
  int index = fullname.indexOf(',');
  if (index == -1) {
    result.add(fullname);
    result.add("");
  } else {
    String name = fullname.substring(index + 2, fullname.length);
    result.add(name);
    String surname = fullname.substring(0, index);
    result.add(surname);
  }

  return result;
}

List<String> getNamesSurnamesFromSquad(String fullname) {
  List<String> result = [];

  int index = fullname.indexOf(',');

  if (index == -1) {
    index = fullname.indexOf(' ') + 1;
    String name = fullname.substring(index, fullname.length);
    String surname = "";
    result.add(name);
    result.add(surname);
  } else {
    int begin = fullname.indexOf(' ') + 1;
    String name = fullname.substring(index + 2, fullname.length);
    result.add(name);
    String surname = fullname.substring(begin, index);
    result.add(surname);
  }
  return result;
}

List<Team> getHomepageLeagueContainer(List<Team> teams, List<Game> games) {
  Team egara = teams.firstWhere((item) => item.id == 20008);
  int pos = egara.currentPosition(teams, games);
  Team teamA, teamB;
  if (pos == 1) {
    teamA = teams
        .firstWhere((item) => item.currentPosition(teams, games) == pos + 1);
    teamB = teams
        .firstWhere((item) => item.currentPosition(teams, games) == pos + 2);
    return [egara, teamA, teamB];
  } else if (pos == 12) {
    teamA = teams
        .firstWhere((item) => item.currentPosition(teams, games) == pos - 1);
    teamB = teams
        .firstWhere((item) => item.currentPosition(teams, games) == pos - 2);
    return [teamB, teamA, egara];
  } else {
    teamA = teams
        .firstWhere((item) => item.currentPosition(teams, games) == pos - 1);
    teamB = teams
        .firstWhere((item) => item.currentPosition(teams, games) == pos + 1);
    return [teamA, egara, teamB];
  }
}

List<int> getlast5results(List<Game> games) {
  List<int> list = [];
  List<Game> egaraGames = games
      .where((item) =>
          (item.localTeam.id == 20008 || item.awayTeam.id == 20008) &&
          (item.localSquad.isNotEmpty || item.awaySquad.isNotEmpty))
      .toList(); // Partidos del egara jugados.
  egaraGames.sort((b, a) => a.id.compareTo(b.id));
  if (egaraGames.length > 5) {
    egaraGames.removeRange(5, egaraGames.length);
  }
  for (var game in egaraGames) {
    String result = whosWinner(game.localGoals, game.awayGoals);
    if (result == "1") {
      if (game.localTeam.id == 20008) {
        list.add(1);
      } else {
        list.add(-1);
      }
    } else if (result == "2") {
      if (game.awayTeam.id == 20008) {
        list.add(1);
      } else {
        list.add(-1);
      }
    } else {
      list.add(0);
    }
  }
  return list;
}

String add0(int digit) {
  if (digit < 10 && digit > -10) {
    return '0$digit';
  } else {
    return '$digit';
  }
}

String givmeDaWeeklyDay(int n) {
  Map<int, String> weekdaysMap = {};
  weekdaysMap[1] = 'L';
  weekdaysMap[2] = 'M';
  weekdaysMap[3] = 'X';
  weekdaysMap[4] = 'J';
  weekdaysMap[5] = 'V';
  weekdaysMap[6] = 'S';
  weekdaysMap[7] = 'D';
  if (n > 0 && n <= 12) {
    return '${weekdaysMap[n]}';
  } else {
    return 'None';
  }
}

String getJourneyResult(Game game) {
  if (game.localSquad.isEmpty || game.awaySquad.isEmpty) {
    return '${givmeDaWeeklyDay(game.date.weekday)} ${add0(game.date.hour)}:${add0(game.date.minute)}';
  } else {
    return '${game.localGoals}-${game.awayGoals}';
  }
}

String givmeDaMonth(int n) {
  Map<int, String> months = {};
  months[1] = 'Enero';
  months[2] = 'Febrero';
  months[3] = 'Marzo';
  months[4] = 'Abril';
  months[5] = 'Mayo';
  months[6] = 'Junio';
  months[7] = 'Julio';
  months[8] = 'Agosto';
  months[9] = 'Setiembre';
  months[10] = 'Octubre';
  months[11] = 'Noviembre';
  months[12] = 'Diciembre';
  if (n > 0 && n <= 12) {
    return '${months[n]}';
  } else {
    return 'None';
  }
}

String getJourneyDate(List<Game> journeyGames) {
  journeyGames.sort((a, b) => a.date.compareTo(b.date));
  DateTime startDate = journeyGames[0].date;
  DateTime endDate = journeyGames[journeyGames.length - 1].date;
  if (endDate.difference(startDate).inDays > 1) {
    // Por si contiene algún partido jugado en otra fecha, le sumamos un dia a la fecha inicial.
    DateTime endDate = startDate.add(new Duration(days: 1));
    return '${add0(startDate.day)}-${add0(endDate.day)} ${givmeDaMonth(endDate.month)}';
  } else {
    return '${add0(startDate.day)}-${add0(endDate.day)} ${givmeDaMonth(endDate.month)}';
  }
}

Game getNextMatch(List<Game> games, Team team) {
  games.sort((a, b) => a.id.compareTo(b.id));
  return games.firstWhere((item) =>
      (item.localTeam.id == team.id || item.awayTeam.id == team.id) &&
      (item.localSquad.isEmpty || item.awaySquad.isEmpty));
}

Game getLastMatch(List<Game> games, Team team) {
  games.sort((a, b) => a.id.compareTo(b.id));
  return games.lastWhere((item) =>
      (item.localTeam.id == team.id || item.awayTeam.id == team.id) &&
      (item.localSquad.isNotEmpty || item.awaySquad.isNotEmpty));
}
