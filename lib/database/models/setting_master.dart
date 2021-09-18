class SettingMaster{
  String id;
  String title;
  SettingMaster({this.id, this.title});

  SettingMaster.fromMap(Map<String, dynamic> map){
    id = map['id'];
    title = map['title'];
  }
}