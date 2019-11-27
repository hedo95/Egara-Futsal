import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show File;
import 'dart:convert' show json;
import 'dart:io';
import 'package:egarafutsal/Logic/Model/Player.dart';

class Journey
{
  int journey;
  List<Game> games;

  Journey(this.games)
  {
    for(var game in this.games)
    {
      this.journey = game.journey;
      break;
    }
  }

}
