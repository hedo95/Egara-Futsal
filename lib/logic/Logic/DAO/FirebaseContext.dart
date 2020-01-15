import 'dart:convert';
import 'dart:convert' show json;
import 'dart:io' show File;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/Game.dart';
import '../Model/Team.dart';

class FirebaseContext {
  final gamesCollection = Firestore.instance.collection('Games');
  final teamsCollection = Firestore.instance.collection('Teams');

  Future<void> addNewGame(Game item) async {
    try {
      await gamesCollection.add(item.toDocument());
      print('Partido añadido correctamente');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addNewTeam(Team item) async {
    try {
      await teamsCollection.add(item.toDocument());
      print('Equipo añadido correctamente');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addAllGames(List<Game> items) async {
    items.sort((a, b) => a.id.compareTo(b.id));
    items.forEach((item) => addNewGame(item));
  }

  Future<void> addAllTeams(List<Team> items) async {
    items.sort((a, b) => a.id.compareTo(b.id));
    items.forEach((item) => addNewTeam(item));
  }

  Future<void> deleteGame(Game item) async {
    try {
      gamesCollection.document(item.documentID).delete();
      print('Partido eliminado correctamente');
    } catch (e) {
      print('No se ha podido eliminar el partido');
    }
  }

  Future<void> deleteTeam(Team item) async {
    try {
      gamesCollection.document(item.documentID).delete();
      print('Partido eliminado correctamente');
    } catch (e) {
      print('No se ha podido eliminar el partido');
    }
  }

  Future<void> updateGame(Game item) async {
    try {
      gamesCollection.document(item.documentID).updateData(item.toDocument());
      print('Partido actualizado correctamente');
    } catch (e) {
      print('No se ha podido actualizar el partido');
    }
  }

  Future<void> updateTeam(Team item) async {
    try {
      teamsCollection.document(item.documentID).updateData(item.toDocument());
      print('Equipo actualizado correctamente');
    } catch (e) {
      print('No se ha podido actualizar el equipo');
    }
  }

  Stream<List<Game>> loadGames() {
    return gamesCollection.snapshots().map((snapshot) {
      return snapshot.documents.map((game) => Game.fromSnapshot(game)).toList();
    });
  }

  Stream<List<Team>> loadTeams() {
    return teamsCollection.snapshots().map((snapshot) {
      return snapshot.documents.map((team) => Team.fromSnapshot(team)).toList();
    });
  }

  Future<void> exportTeamsToLocal() async {
    try {
      loadTeams().listen((onValue) {
        onValue.sort((a, b) => a.id.compareTo(b.id));
        List<dynamic> jsonData = [];
        onValue.forEach((item) => jsonData.add(json.encode(item.toJson())));
        File('Egara-Futsal/assets/Data/Games.json')
            .writeAsStringSync(jsonData.toString(), mode: FileMode.write);
        print('Fichero exportado correctamente.');
      });
    } catch (e) {
      print('No se han podido migrar los equipos. ' + e);
    }
  }
}
