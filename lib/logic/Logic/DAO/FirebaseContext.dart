import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show File;
import 'dart:convert' show json;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/Game.dart';
import '../Model/Player.dart';
import '../Model/Team.dart';

class FirebaseContext
{
  final gamesCollection = Firestore.instance.collection('Games');
  final teamsCollection = Firestore.instance.collection('Teams');
  final playersCollection = Firestore.instance.collection('Players');

  Future<void> addNewGame(Game item) async
  {
    try
    {
      await gamesCollection.add(item.toDocument());
      print('Partido añadido correctamente');

    }
    catch(e) 
    {
      print(e.toString());
    }
  }

  Future<void> addNewTeam(Team item) async
  {
    try
    {
      await teamsCollection.add(item.toDocument());
      print('Equipo añadido correctamente');

    }
    catch(e) 
    {
      print(e.toString());
    }
  }

  Future<void> addGamesOverWritting(List<Game> items) async
  {
    for(int n = 0; n < items.length; n++)
    {
      addNewGame(items[n]);
    }
  }

  Future<void> addTeamsOverWritting(List<Team> items) async
  {
    for(int n = 0; n < items.length; n++)
    {
      addNewTeam(items[n]);
    }
  }

  Future<void> deleteGame(Game item) async
  {
    try
    {
      gamesCollection.document(item.documentID).delete();
      print('Partido eliminado correctamente');
    }
    catch(e) 
    {
      print('No se ha podido eliminar el partido');
    }
  }

  Future<void> deleteTeam(Team item) async
  {
    try
    {
      gamesCollection.document(item.documentID).delete();
      print('Partido eliminado correctamente');
    }
    catch(e) 
    {
      print('No se ha podido eliminar el partido');
    }
  }

  Future<void> updateGame(Game item) async
  {
    try
    {
      gamesCollection.document(item.documentID).updateData(item.toDocument());
      print('Partido actualizado correctamente');
    }
    catch(e) 
    {
      print('No se ha podido actualizar el partido');
    }
  }

  Future<void> updateTeam(Team item) async
  {
    try
    {
       teamsCollection.document(item.documentID).updateData(item.toDocument());
      print('Equipo actualizado correctamente');
    }
    catch(e) 
    {
      print('No se ha podido actualizar el equipo');
    }
  }

  Future<List<Game>> loadGames() async
  {
    QuerySnapshot qShot = await gamesCollection.getDocuments();
    return qShot.documents.map((game) => Game.fromSnapshot(game)).toList();
  }

  Future<List<Team>> loadTeams() async
  {
    QuerySnapshot qShot = await teamsCollection.getDocuments();
    return qShot.documents.map((team) => Team.fromSnapshot(team)).toList();
  }

  Future<void> exportTeamsToLocal() async
  {
    try
    {
      loadTeams().then((onValue){
        onValue.sort((a,b) => a.id.compareTo(b.id));
        List<dynamic> jsonData = [];
        onValue.forEach((item) => jsonData.add(json.encode(item.toJson())));
        File('lib/Data/Games.json').writeAsStringSync(jsonData.toString(), mode: FileMode.write);
        print('Fichero exportado correctamente.');
      });
    }
    catch(e)
    {
      print('No se han podido migrar los equipos. ' + e);
    }
  }
}


 // Stream<List<Game>> loadGames()
  // {
  //   return gamesCollection.snapshots().map((snapshot) {
  //     return snapshot.documents.map((game) => Game.fromSnapshot(game)).toList();
  //   });
  // }

