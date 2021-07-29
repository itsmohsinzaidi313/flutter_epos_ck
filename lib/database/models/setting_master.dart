class SettingMaster{
  String id;
  String title;
  SettingMaster({this.id, this.title});

  SettingMaster.fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.title = map['title'];
  }
}