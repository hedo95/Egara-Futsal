import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show File;
import 'dart:convert' show json;
import 'dart:io';

class OurPlayer
{
  // Professional data
  String position, name, surname, nationality;
  int dorsal;

  // Personal data
  DateTime birthday;
  double height, weight;
  String dni, ss, address, phone, mail;

  OurPlayer
  (
    this.name, this.surname, this.dorsal, this.position,
    this.nationality, this.birthday, this.height, this.weight,
    this.dni, this.ss, this.address, this.phone, this.mail
  );

  OurPlayer.professional
  (
    this.name, this.surname, this.dorsal, this.position
  );

  OurPlayer.personal
  (
    this.nationality, this.birthday, this.height, this.weight, 
    this.dni, this.ss, this.address, this.phone, this.mail
  );

  toJson()
  {
    return 
    {
      'name': this.name,
      'surname': this.surname,
      'dorsal': this.dorsal,
      'position': this.position,
      'nationality': this.nationality,
      'birthday': this.birthday,
      'height': this.height,
      'weight': this.weight,
      'dni': this.dni,
      'ss': this.ss,
      'address': this.address,
      'phone': this.phone,
      'mail': this.mail
    };
  }

}