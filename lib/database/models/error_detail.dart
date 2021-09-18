class ErrorDetail{

  String id;
  String errorMasterId;
  String error;

  ErrorDetail({this.id, this.errorMasterId, this.error});

  ErrorDetail.fromMap(Map<String, dynamic> map){
    id = map['id'];
    errorMasterId = map['error_master_id'];
    error = map['error'];
  }
}