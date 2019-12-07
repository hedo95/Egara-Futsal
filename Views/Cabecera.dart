import 'package:egara/Theme.dart';
import 'package:flutter/material.dart';


class Cabecera extends StatelessWidget {
  const Cabecera({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 20.0,
        top: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(height: 20.0),
          Icon(
            MyFlutterApp.user,
            color: Colors.white,
            size: 30.0,
          ),
        ],
      ),
    );
  }
}
