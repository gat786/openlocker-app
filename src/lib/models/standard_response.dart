class StandardResponse {
  int? errorCode;
  dynamic data;
  bool? success;
  String? message;

  StandardResponse({this.errorCode, this.data, this.success, this.message});

  static StandardResponse fromJson(Map<String, dynamic> json) {
    var standardResponse = new StandardResponse();
    standardResponse.errorCode = json['errorCode'];
    standardResponse.data = json['data'];
    standardResponse.success = json['success'];
    standardResponse.message = json['message'];
    return standardResponse;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}