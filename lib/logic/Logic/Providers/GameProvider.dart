
import 'package:egaradefinitiu/logic/Logic/Model/Game.dart';
import 'package:flutter/material.dart';

class GameProvider with ChangeNotifier{

  List<Game> _games;

  GameProvider(List<Game> items){
    this.games = items;
  }

  List<Game> get games {
    return _games;
  }

  set games(List<Game> games){
    this._games = games;
    notifyListeners();
  }

}