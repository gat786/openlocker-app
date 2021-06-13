class FilesResponse {
  List<String>? folderPrefix;
  List<File>? files;

  FilesResponse({this.folderPrefix, this.files});

  FilesResponse.fromJson(Map<String, dynamic> json) {
    folderPrefix = json['folderPrefix'].cast<String>();
    if (json['files'] != null) {
      files = new List.empty();
      json['files'].forEach((v) {
        files?.add(new File.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['folderPrefix'] = this.folderPrefix;
    if (this.files != null) {
      data['files'] = this.files?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FlatFilesResponse {
  List<File> files = List.empty(growable: true);

  FlatFilesResponse({required this.files});

  FlatFilesResponse.fromJson(List<dynamic> json){
    json.forEach((value) {
      File file = new File();
       file.fileName = value['fileName'];
       file.createdOn = value['createdOn'];
       file.contentType = value['contentType'];
       file.contentLength = value['contentLength'];
       file.lastModified = value['lastModified'];
       files.add(file);
    });
  }
}

class File {
  String? fileName;
  String? lastModified;
  int? contentLength;
  String? contentType;
  String? createdOn;
  String fileNameWithoutPrefix() {
    return this.fileName!.split('/').last;
  }

  File(
      {this.fileName,
        this.lastModified,
        this.contentLength,
        this.contentType,
        this.createdOn});

  File.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
    lastModified = json['lastModified'];
    contentLength = json['contentLength'];
    contentType = json['contentType'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileName'] = this.fileName;
    data['lastModified'] = this.lastModified;
    data['contentLength'] = this.contentLength;
    data['contentType'] = this.contentType;
    data['createdOn'] = this.createdOn;
    return data;
  }
}
