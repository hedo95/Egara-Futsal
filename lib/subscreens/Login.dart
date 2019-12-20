import 'package:egaradefinitiu/widgets/LoginLayout.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Icon(Icons.check, color: Colors.white, size: 80),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                ),
              ),
              child: Row(
                children: <Widget>[
                  LoginLayout(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
