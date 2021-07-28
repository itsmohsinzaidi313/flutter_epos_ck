class ErrorDetail{

  String id;
  String errorMasterId;
  String error;

  ErrorDetail({this.id, this.errorMasterId, this.error});

  ErrorDetail.fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.errorMasterId = map['error_master_id'];
    this.error = map['error'];
  }
}