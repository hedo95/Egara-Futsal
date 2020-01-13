import 'package:egaradefinitiu/screens/Clasificacion.dart';
import 'package:egaradefinitiu/screens/Equipos.dart';
import 'package:egaradefinitiu/screens/HomePage.dart';
import 'package:egaradefinitiu/screens/Jornadas.dart';
import 'package:egaradefinitiu/style/Theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class BottomMenu extends StatefulWidget {
  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  ValueNotifier<int> _currentIndex = new ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      HomePage(),
      Equipos(),
      Clasificacion(),
      Jornadas(),
    ];
    // 1. Necessitem un ValueNotifier perquè l'índex de la pantalla canviarà i volem que es notifiquin els canvis
    // 2. Volem que aquest índex el vegin tots els widgets de sota de BottomNavigationBar (ChangeNotifierProvider)
    // 3. Cada cop que el índex canviï (desde qualsevol lloc), volem reconstruir la pantalla.
    return ChangeNotifierProvider<ValueNotifier<int>>.value(
      value: _currentIndex,
      child: Builder(
        builder: (context) {
          final index = Provider.of<ValueNotifier<int>>(context).value;
          return Scaffold(
            body: _children[index],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: index,
              onTap: onTabTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Color(0xFF270049),
              //fixedColor: Color(0xFF270049),
              unselectedItemColor: Color(0xFF4b1a77),
              iconSize: 30,

              items: [
                BottomNavigationBarItem(
                  activeIcon: ShaderMask(
                    shaderCallback: (Rect bounds) {
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
                    shaderCallback: (Rect bounds) {
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
                    shaderCallback: (Rect bounds) {
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
                    shaderCallback: (Rect bounds) {
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
        },
      ),
    );
  }

  void onTabTapped(int index) {
    /*setState(() {
      _currentindex = index;
    });*/
    _currentIndex.value = index;
  }
}
