import 'package:egaradefinitiu/style/Theme.dart';
import 'package:egaradefinitiu/widgets/Cabecera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            Cabecera(),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Container(
                decoration: estiloContenedor,
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 200,
                      width: 400,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right:200),
                      child: Image.asset('assets/escudos/Egara_escudo.png'),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
/*
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
      color: Color(0xFF3D006A),
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Cabecera(),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF270049),
                              offset: Offset(-10, 10),
                            ),
                          ],
                          gradient: colorGradiente,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(right: 200),
                          child: Image.asset('assets/Background.png'),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 130, top: 20),
                              child: Text(
                                'Egara F.C',
                                style: TextStyle(
                                  fontSize: 50.0,
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                SizedBox(width: 170),
                                Container(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF381254),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.arrow_drop_up,
                                              color: Colors.green,
                                              size: 40.0,
                                            ),
                                            Text(
                                              '4',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white38,
                                              ),
                                            ),
                                            SizedBox(width: 70),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                '24 Pts',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white38,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.mood_bad,
                                              color: Colors.red[800],
                                              size: 20,
                                            ),
                                            SizedBox(width: 20),
                                            Text(
                                              '2-0',
                                              style: TextStyle(
                                                color: Colors.white38,
                                                fontSize: 30,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                                height: 50,
                                                width: 50,
                                                color: Colors.black),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Siguiente Partido',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: 400,
                        decoration: BoxDecoration(
                          color: Color(0xFF4b1a77),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF270049),
                              offset: Offset(-10, 10),
                            ),
                          ],
                        ),
                        child: Container(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Local',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white38,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    'Visitante',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white38,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '21/12/2019',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white38,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '19:00 h',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white38,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Camp Nou,   Barcelona',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white38,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Clasificación',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: (){
                    
                    Provider.of<ValueNotifier<int>>(context).value = 2;
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 200,
                          width: 400,
                          decoration: BoxDecoration(
                            color: Color(0xFF4b1a77),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF270049),
                                offset: Offset(-10, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 300,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xFF270049),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      '7.',
                                      style: TextStyle(
                                        color: Colors.white38,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Container(
                                        height: 40,
                                        width: 40,
                                        color: Colors.black),
                                    Text(
                                      'hola',
                                      style: TextStyle(
                                        color: Colors.white38,
                                      ),
                                    ),
                                    SizedBox(width: 40),
                                    Text(
                                      '26 pts',
                                      style: TextStyle(
                                        color: Colors.white38,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: 300,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xFF270049),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text('7.',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 20,
                                        )),
                                    Container(
                                        height: 40,
                                        width: 40,
                                        color: Colors.black),
                                    Text(
                                      'hola',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(width: 40),
                                    Text(
                                      '26 pts',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: 300,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Color(0xFF270049),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text('7.',
                                        style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 20,
                                        )),
                                    Container(
                                        height: 40,
                                        width: 40,
                                        color: Colors.black),
                                    Text(
                                      'hola',
                                      style: TextStyle(
                                        color: Colors.white38,
                                      ),
                                    ),
                                    SizedBox(width: 40),
                                    Text(
                                      '26 pts',
                                      style: TextStyle(
                                        color: Colors.white38,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/
