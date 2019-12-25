
import 'package:egaradefinitiu/logic/Logic/Model/Game.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Player.dart';
import '../BO/EgaraBO.dart';
import 'package:flutter/material.dart';

class PlayerProvider with ChangeNotifier{

  List<Player> _players;

  PlayerProvider(List<Game> games){
    this._players = getAllPlayers(games);
  }

  get players {
    return this._players;
  }

  set players(List<Player> players){
    this._players = players;
    notifyListeners();
  }

}