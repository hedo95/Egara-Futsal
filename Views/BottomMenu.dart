import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Clasificacion.dart';
import 'Equipos.dart';
import 'HomePage.dart';
import 'Jornadas.dart';
import 'Theme.dart';

class BottomMenu extends StatefulWidget {
  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  int _currentindex = 0;
  final List<Widget> _children = [
    HomePage(),
    Equipos(),
    Clasificacion(),
    Jornadas(), 
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _children[_currentindex],
      
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentindex,
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFF270049),
          //fixedColor: Color(0xFF270049),
          unselectedItemColor: Color(0xFF4b1a77),
          iconSize: 30,
          
          
          items:  [
            BottomNavigationBarItem(
              activeIcon: ShaderMask(
                shaderCallback: (Rect bounds){
                  return RadialGradient(
                    center: Alignment.bottomCenter,
                    radius: 2,
                    colors: <Color>[
                      Colors.red,
                      Colors.purple,
                    ],
                    tileMode: TileMode.repeated,

                  ).createShader(bounds);
                },
                child: Icon(MyFlutterApp.home),
              ),
              icon: Icon(MyFlutterApp.home, color: Color(0xFF4b1a77)),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              activeIcon: ShaderMask(
                shaderCallback: (Rect bounds){
                  return RadialGradient(
                    center: Alignment.bottomCenter,
                    radius: 3.3,
                    colors: <Color>[
                      Colors.red,
                      Colors.purple,
                    ],
                    tileMode: TileMode.repeated,

                  ).createShader(bounds);
                },
                child: Icon(MyFlutterApp.soccer),
              ),
              icon: Icon(MyFlutterApp.soccer, color: Color(0xFF4b1a77)),
              title: Text('Equipos'),
            ),
            BottomNavigationBarItem(
              activeIcon: ShaderMask(
                shaderCallback: (Rect bounds){
                  return RadialGradient(
                    center: Alignment.bottomCenter,
                    radius: 3.5,
                    colors: <Color>[
                      Colors.red,
                      Colors.purpleAccent,
                    ],
                    tileMode: TileMode.repeated,

                  ).createShader(bounds);
                },
                child: Icon(MyFlutterApp.chart_bars),
              ),
              icon: Icon(MyFlutterApp.chart_bars, color: Color(0xFF4b1a77)),
              title: Text('Clasificación'),
            ),
            BottomNavigationBarItem(
              activeIcon: ShaderMask(
                shaderCallback: (Rect bounds){
                  return RadialGradient(
                    center: Alignment.bottomCenter,
                    radius: 3.2,
                    colors: <Color>[
                      Colors.red,
                      Colors.purple,
                    ],
                    tileMode: TileMode.repeated,

                  ).createShader(bounds);
                },
                child: Icon(MyFlutterApp.trophy),
              ),
              icon: Icon(MyFlutterApp.trophy, color: Color(0xFF4b1a77)),
              title: Text('Jornadas'),
            ),
          ],
        
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentindex = index;
    });
  }
}