import 'dart:core';
import 'Game.dart';

class Player {
  // Professional data
  String name, surname;
  int idteam, dorsal;

  Player(this.idteam, this.name, this.surname, this.dorsal);

  int goals(List<Game> games) {
    games = games
        .where((item) =>
            item.localTeam.id == this.idteam || item.awayTeam.id == this.idteam)
        .toList();
    int goals = 0;
    for (var game in games) {
      for (MapEntry<Player, List<int>> map in game.goalScorers.entries) {
        if (map.key.dorsal == this.dorsal && map.key.idteam == this.idteam) {
          goals += map.value.length;
        }
      }
    }
    return goals;
  }

  int ycards(List<Game> games) {
    games = games
        .where((item) =>
            item.localTeam.id == this.idteam || item.awayTeam.id == this.idteam)
        .toList();
    
    int ycards = 0;
    for (var game in games) {
      for (MapEntry<Player, List<int>> map in game.yellowCards.entries) {
        if (map.key.dorsal == this.dorsal && map.key.idteam == this.idteam) {
          ycards += map.value.length;
        }
      }
    }
    return ycards;
  }

  int rcards(List<Game> games) {
    games = games
        .where((item) =>
            item.localTeam.id == this.idteam || item.awayTeam.id == this.idteam)
        .toList();
    
    int rcards = 0;
    for (var game in games) {
      for (MapEntry<Player, List<int>> map in game.redCards.entries) {
        if (map.key.dorsal == this.dorsal && map.key.idteam == this.idteam) {
          rcards += map.value.length;
        }
      }
    }
    return rcards;
  }

  int playedgames(List<Game> games) {
    games = games
        .where((item) =>
            item.localTeam.id == this.idteam || item.awayTeam.id == this.idteam)
        .toList();
    
    int played = 0;
    for (var game in games) {
      if (game.localSquad.any((item) => item.dorsal == this.dorsal) ||
          game.awaySquad.any((item) => item.dorsal == this.dorsal)) {
        played++;
      }
    }
    return played;
  }

  int totalgames(List<Game> games) {
    return games
        .where((item) =>
            (item.localTeam.id == this.idteam ||
                item.awayTeam.id == this.idteam) &&
            (item.awaySquad.isNotEmpty || item.localSquad.isNotEmpty))
        .toList()
        .length;
  }

}
