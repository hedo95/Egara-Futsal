

class User {
  int id;
  String username, password, imagepath;

  User(this.username, this.password, this.imagepath) : this.id = 0000;

  User.def() {
    this.id = 00000;
    this.username = "";
    this.password = "";
    this.imagepath = "";
  }
}
