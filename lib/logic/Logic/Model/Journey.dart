import 'Game.dart';

class Journey {
  int id, journey;
  List<Game> games = [];

  Journey(this.games) {
    for (var game in this.games) {
      this.journey = game.journey;
      break;
    }
    this.id = 4000 +
        (this.journey - 1); // Solo sirve con el registro de una unica temporada
  }
}
