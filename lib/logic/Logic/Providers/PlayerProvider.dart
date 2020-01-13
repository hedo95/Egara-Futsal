import 'package:egaradefinitiu/logic/Logic/Model/Game.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Player.dart';
import 'package:flutter/material.dart';

import '../BO/EgaraBO.dart';

class PlayerProvider with ChangeNotifier {
  List<Player> _players;

  PlayerProvider(List<Game> items) {
    this.players = getAllPlayers(items);
  }

  List<Player> get players {
    return this._players;
  }

  set players(List<Player> players) {
    this._players = players;
    notifyListeners();
  }
}
