class ErrorMaster {
  String id;
  String className;
  String dateTime;
  String title;

  ErrorMaster({this.id, this.className, this.dateTime, this.title});

  ErrorMaster.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    className = map['class_name'];
    dateTime = map['date_time'];
    title = map['title'];
  }
}
