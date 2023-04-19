class FileDetails {
  bool? success;
  int? code;
  Data? data;

  FileDetails({this.success, this.code, this.data});

  FileDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? documentId;
  String? docType;
  String? name;

  Data({this.documentId, this.docType, this.name});

  Data.fromJson(Map<String, dynamic> json) {
    documentId = json['document_id'];
    docType = json['doc_type'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['document_id'] = this.documentId;
    data['doc_type'] = this.docType;
    data['name'] = this.name;
    return data;
  }
}
