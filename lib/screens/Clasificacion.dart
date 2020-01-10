import 'package:egaradefinitiu/logic/Logic/DAO/EgaraDAO.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Game.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Player.dart';
import 'package:egaradefinitiu/style/Theme.dart';
import 'package:egaradefinitiu/widgets/Cabecera.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Clasificacion extends StatefulWidget {
  @override
  _ClasificacionState createState() => _ClasificacionState();
}

class _ClasificacionState extends State<Clasificacion> {
  @override
  Widget build(BuildContext context) {
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
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  Entry(
    '1. Egara futsal',
    <Entry>[
      Entry('partidos jugados:'),
      Entry('Partidos ganados:'),
      Entry('Partidos empatados:'),
      Entry('Partidos perdidos:'),
      Entry('Goles a favor:'),
      Entry('Goles en contra:'),
    ],
    
  ),
  Entry(
    '2. Premiá ',
    <Entry>[
      Entry('partidos jugados:'),
      Entry('Partidos ganados:'),
      Entry('Partidos empatados:'),
      Entry('Partidos perdidos:'),
      Entry('Goles a favor:'),
      Entry('Goles en contra:'),
    ],
  ),
  Entry(
    '3. Terrassa F.C',
    <Entry>[
      Entry('partidos jugados:'),
      Entry('Partidos ganados:'),
      Entry('Partidos empatados:'),
      Entry('Partidos perdidos:'),
      Entry('Goles a favor:'),
      Entry('Goles en contra:'),
    ],
  ),
];

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
          "2",
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
        "23pts",
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
    // TODO: implement build
    return null;
  }
}