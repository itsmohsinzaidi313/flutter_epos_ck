class ErrorMaster {
  String id;
  String className;
  String dateTime;
  String title;

  ErrorMaster({this.id, this.className, this.dateTime, this.title});

  ErrorMaster.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.className = map['class_name'];
    this.dateTime = map['date_time'];
    this.title = map['title'];
  }
}
