import 'dart:convert';
import 'dart:core' as prefix0;
import 'dart:core';
import 'dart:ffi';
import 'dart:io' show File;
import 'dart:convert' show json;
import 'dart:io';
import 'package:egarafutsal/Logic/Model/Player.dart';
import 'package:egarafutsal/Logic/Model/Team.dart';
import 'package:egarafutsal/Logic/Model/Game.dart';
import 'package:egarafutsal/Logic/DAO/EgaraDAO.dart';

int getId(var data) 
{
  return data[data.length-1].id + 1;
}

Team whosWiner(Team localTeam, Team awayTeam)
{
  if (localTeam.goals > awayTeam.goals)
  {
     return localTeam;
  }

  else if (localTeam.goals < awayTeam.goals)
  {
    return awayTeam;
  }

  else
  {
    return new Team.def();
  }

}

Player createUpdatePlayer({int id, Player player})
{
  if (id == null && player == null)
  {
    return createUpdatePlayer(player: new Player.def());
  }
  else if(id != null && player == null)
  {
    try
    {
      Player foundPlayer = getAllPlayersData().firstWhere((item) => item.id == id);
      return createUpdatePlayer(player: foundPlayer);
    }
    catch (Exception)
    {
      return Exception('No se ha encontrado el modelo con id: ' + id.toString() + '\n');
    }
  }
  else 
  {
    var data = getAllPlayersData();
    if (data.any((item) => item.id == player.id))
    {
      int index = data.indexWhere((item) => item.id == player.id);
      data.removeAt(index);
      data.add(player);
      exportPlayersData(data);
      return player;
    }
    else
    {
      data.add(player);
      exportPlayersData(data);
      return player;
    }
  }
}

Team createUpdateTeam({int id, Team team})
{
  if (id == null && team == null)
  {
    return createUpdateTeam(team: new Team.def());
  }
  else if(id != null && team == null)
  {
    try
    {
      Team foundTeam = getAllTeamsData().firstWhere((item) => item.id == id);
      return createUpdateTeam(team: foundTeam);
    }
    catch (Exception)
    {
      return Exception('No se ha encontrado el equipo con id: ' + id.toString() + '\n');
    }
  }
  else 
  {
    var data = getAllTeamsData();
    if (data.any((item) => item.id == team.id))
    {
      int index = data.indexWhere((item) => item.id == team.id);
      data.removeAt(index);
      data.add(team);
      exportTeamsData(data);
      return team;
    }
    else
    {
      data.add(team);
      exportTeamsData(data);
      return team;
    }
  }
}

bool deletePlayer(Player player)
{
  var data = getAllPlayersData();
  try
  {
    Player item = data.firstWhere((item) => item.id == player.id);
    data.remove(item);
    exportPlayersData(data);
    return true;
  }
  catch (Exception)
  {
    return false;
  }
}

bool deleteTeam(Team team)
{
  var data = getAllTeamsData();
  try
  {
    Team item = data.firstWhere((item) => item.id == team.id);
    data.remove(item);
    exportTeamsData(data);
    return true;
  }
  catch (Exception)
  {
    return false;
  }
}

bool deleteGame(Game match)
{
  var data = getAllGamesData();
  try
  {
    Game item = data.firstWhere((item) => item.id == match.id);
    data.remove(item);
    exportGamesData(data);
    return true;
  }
  catch (Exception)
  {
    return false;
  }
}


