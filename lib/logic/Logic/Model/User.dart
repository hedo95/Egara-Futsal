import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show File;
import 'dart:convert' show json;
import 'dart:io';

class User
{
  int id;
  String  username, password, imagepath;

  User(this.username, this.password, this.imagepath) : this.id = 0000;

  User.def()
  {
    this.id = 00000;
    this.username = "";
    this.password = "";
    this.imagepath = "";
  }
}
