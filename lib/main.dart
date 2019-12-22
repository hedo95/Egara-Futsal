
import 'package:egaradefinitiu/screens/Clasificacion.dart';
import 'package:egaradefinitiu/style/Theme.dart';
import 'package:egaradefinitiu/subscreens/Graficos_jugadoras.dart';
import 'package:egaradefinitiu/widgets/BottomMenu.dart';
import 'package:flutter/material.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  get bottomNavBarIndex => null;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/Graficos_jugadoras': (BuildContext context) => EstadisticaJugadora(),
        '/Clasificacion': (BuildContext context) => Clasificacion(),
        
      },
      theme: ThemeData(
        primaryColor: primaryColor,
        backgroundColor: backgroundColor,
      ),
      home: BottomMenu(),
      
    );
  }
}

/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'logic/Logic/DAO/FirebaseContext.dart';
import 'logic/Logic/Model/Game.dart';


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
                  db.loadGames().then((list){
                    list.sort((a,b) => a.id.compareTo(b.id));
                    list.forEach((item) => print(item.id.toString()));
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
*/