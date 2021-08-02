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
    id = map[''];
    userId = map[''];
    connectionStatus = map[''];
    loginStatus = map[''];
    shiftId = map[''];
    registerStatus = map[''];
  }
}


































