import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show File;
import 'dart:convert' show json;
import 'dart:io';
import 'package:egarafutsal/Logic/Model/Player.dart';

int id, journey;
  List<Game> games;

  Journey(this.games)
  {
    for(var game in this.games)
    {
      this.journey = game.journey;
      break;
    }
    this.id = 4000 + (this.journey - 1); // Solo sirve con el registro de una unica temporada
  }
