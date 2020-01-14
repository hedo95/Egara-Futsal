import 'package:egaradefinitiu/logic/Logic/Model/Game.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Team.dart';
import 'package:egaradefinitiu/logic/Logic/BO/EgaraBO.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Clasificacion extends StatefulWidget {
  @override
  _ClasificacionState createState() => _ClasificacionState();
}

class _ClasificacionState extends State<Clasificacion> {
  final List<Entry> data = [];

  @override
  Widget build(BuildContext context) {
    var teams = Provider.of<List<Team>>(context);
    var games = Provider.of<List<Game>>(context);
    var tableTeams = getOrderedTable(teams,games);
    for(int n = 0; n < tableTeams.length; n++){
      data.add(new Entry(
        '${n+1}    '+tableTeams[n].shortname,
        tableTeams[n].currentPoints(games).toString() + ' pts',
        <Entry>[
          Entry('              Partidos jugados:',tableTeams[n].totalGames(games).toString()),
          Entry('              Partidos ganados:',tableTeams[n].wonGames(games).toString()),
          Entry('              Partidos empatados:',tableTeams[n].drawnGames(games).toString()),
          Entry('              Partidos perdidos:', tableTeams[n].lostGames(games).toString()),
          Entry('              Goles a favor:', tableTeams[n].currentGoals(games).toString()),
          Entry('              Goles en contra:',tableTeams[n].currentConcededGoals(games).toString()),
        ]
      ));
    }

    return Container(
      color: Color(0xFF3D006A),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => EntryItem(
          data[index],
        ),
        itemCount: data.length,
      ),
    );
  }
} //adfd

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, this.value,
   [this.children = const <Entry>[]]);

  final String title;
  final String value;
  final List<Entry> children;
}


// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);
  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty)
      return ListTile(
        title: Text(
          root.title,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white60,
          ),
        ),
        dense: true,
        trailing: Text(
          root.value.toString(),
          style: TextStyle(
            fontSize: 20,
            color: Colors.white60,
          ),
        ),
      );
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(
        root.title,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white70,
        ),
      ),
      leading: Icon(Icons.add_circle),
      trailing: Text(
        root.value.toString(),
        style: TextStyle(
          fontSize: 20,
          color: Colors.white38,
        ),
      ),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var teams = Provider.of<List<Team>>(context);
    var games = Provider.of<List<Game>>(context);
    var tableTeams = getOrderedTable(teams,games);
    return _buildTiles(entry);
  }
}
