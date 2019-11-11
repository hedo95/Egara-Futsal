import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show File;
import 'dart:convert' show json;
import 'dart:io';

class Player
{
  // Professional data (Rest of players)
  String position, name, surname, nationality;
  int id, dorsal;

  // Personal data (Our players)
  DateTime birthday;
  double height, weight;
  String dni, ss, address, phone, mail;
  
  
  // Constructors
  Player
  (
    this.id, this.name, this.surname, this.dorsal, this.position,
    this.nationality, this.birthday, this.height, this.weight,
    this.dni, this.ss, this.address, this.phone, this.mail
  );

  Player.professional
  (
    this.id, this.name, this.surname, this.dorsal, this.position
  );

  
  
  
  // from Object to Json
  toJson()
  {
    return 
    {
      'id': this.id,
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

  toJsonProfessional()
  {
    return
    {
      'id': this.id,
      'name': this.name,
      'surname': this.surname,
      'dorsal': this.dorsal,
      'position': this.position
    };
  }

  
  
  // Print the object 
  toPrint()
  {
    print("Id: " + this.id.toString() + "\n");
    print("Name: " + this.name + "\n");
    print("Surname: " + this.surname + "\n");
    print("Dorsal: " + this.dorsal.toString() + "\n");
    print("Position: " + this.position.toString() + "\n");
    print("Nationality: " + this.nationality + "\n");
    print("Birthday : " + this.birthday.toString().substring(0,this.birthday.toString().length - 13) + "\n");
    print("Height: " + this.height.toString() + "\n");
    print("Weight: " + this.weight.toString() + "\n");
    print("Dni/Nif: " + this.dni + "\n");
    print("SS: " + this.ss + "\n");
    print("Address: " + this.address + "\n");
    print("Phone: " + this.phone + "\n");
    print("Mail: " + this.mail + "\n");
    print('');
  }

  toPrintProfessionalData()
  {
    print("Id: " + this.id.toString() + "\n");
    print("Name: " + this.name + "\n");
    print("Surname: " + this.surname + "\n");
    print("Dorsal: " + this.dorsal.toString() + "\n");
    print("Position: " + this.position.toString() + "\n");
    print('');
  }


  //Convert from Json to Object
  factory Player.fromJson(Map<String,dynamic> json)
  {
    return new Player(json['id'] as int,
                  json['name'] as String,
                  json['surname'] as String, 
                  json['dorsal'] as int, 
                  json['position'] as String, 
                  json['nationality'] as String,
                  DateTime.parse(json['birthday']), 
                  json['height'] as double,
                  json['weight'] as double,
                  json['dni'] as String,
                  json['ss'] as String,
                  json['address'] as String,
                  json['phone'] as String,
                  json['mail'] as String);
  }
  
  
  factory Player.fromJsonProfessional(Map<String,dynamic> json)
  {
    return new Player.professional(json['id'] as int,
                  json['name'] as String,
                  json['surname'] as String, 
                  json['dorsal'] as int, 
                  json['position'] as String);
  }
}
