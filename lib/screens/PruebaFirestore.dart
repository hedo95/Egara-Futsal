import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../logic/Logic/DAO/FirebaseContext.dart';
import '../logic/Logic/Model/Game.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                color: Colors.blue[500],
                onPressed: ()
                {
                  var db = new FirebaseContext();
                  List<Game> games =  [];
                  db.loadGames().then((list){
                    games.addAll(list);
                    games.sort((a,b) => a.id.compareTo(b.id));
                    games.forEach((item) => print(item.id.toString()));
                  });
                }
              ),
              Text('hola Mundo',
              )
            ]
          )
        ),
      ),
    );
  }
}