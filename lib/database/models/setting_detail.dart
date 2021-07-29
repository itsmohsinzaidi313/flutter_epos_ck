class SettingDetail {
  int id;
  int userId;
  int shiftId;
  int connectionStatus;
  int loginStatus;
  int registerStatus;

  SettingDetail(
      {this.userId, this.shiftId, this.connectionStatus, this.loginStatus, this.registerStatus});

  SettingDetail.fromMap(Map<String, dynamic> map){
    this.id = map[''];
    this.userId = map[''];
    this.connectionStatus = map[''];
    this.loginStatus = map[''];
    this.shiftId = map[''];
    this.registerStatus = map[''];
  }
}


































