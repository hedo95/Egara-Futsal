import 'dart:io';
import 'package:egaradefinitiu/logic/Logic/DAO/FirebaseContext.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Game.dart';
import 'package:egaradefinitiu/logic/Logic/Model/Team.dart';
import 'package:egaradefinitiu/style/Theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'TeamView.dart';


class Equipos extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    List<Team> teams = Provider.of<List<Team>>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF270049),
        title: Text('Equipos', style: titulocabecera),
      ),
          body: Container(
            // decoration: BoxDecoration(
            //   gradient: colorGradiente,
            // ),
            color: Color(0xFF3D006A),
            child: Padding(
              padding: EdgeInsets.all(2),
              child: Scrollbar(
                child: GridView.builder(
                  padding: EdgeInsets.all(22),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Columnas
                      childAspectRatio: 1, // H/W
                      crossAxisSpacing: 60, // separacion vertical entre items
                      mainAxisSpacing: 50 // Separacion horiontal entre items
                      ),
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => TeamView(
                                      teams[index],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                alignment: Alignment.topCenter,
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(80),                                
                                  //color: Color(0xFF381254),                                
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Image.asset('assets/escudos/${teams[index].id}.png')
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            teams[index].shortname,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.greenAccent, fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
      ),
    );
  }
}