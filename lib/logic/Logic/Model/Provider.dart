import 'Game.dart';
import 'Player.dart';
import 'Team.dart';

class Provider {
  List<Game> games;
  List<Team> teams;
  List<Player> players;

  Provider.games(this.games) {
    this.games.sort((a, b) => a.id.compareTo(b.id));
  }

  Provider.players(this.players) {
    this.players.sort((a, b) => a.idteam.compareTo(b.idteam));
  }

  Provider.teams(this.teams) {
    this.teams.sort((a, b) => a.id.compareTo(b.id));
  }
}
