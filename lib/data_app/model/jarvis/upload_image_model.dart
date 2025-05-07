class UploadImage {
  final String filename;
  final String mimetype;

  UploadImage({
    required this.filename,
    required this.mimetype,
  });

  factory UploadImage.fromJson(Map<String, dynamic> json) {
    return UploadImage(
      filename: json['filename'],
      mimetype: json['mimetype'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'mimetype': mimetype,
    };
  }
}

class UploadImageResponse {
  final String path;
  final Map<String, String> headers;
  final int maximumFileSize;
  final String url;

  UploadImageResponse({
    required this.path,
    required this.headers,
    required this.maximumFileSize,
    required this.url,
  });

  factory UploadImageResponse.fromJson(Map<String, dynamic> json) {
    return UploadImageResponse(
      path: json['path'] as String,
      headers: Map<String, String>.from(json['headers']),
      maximumFileSize: json['maximumFileSize'] as int,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'headers': headers,
      'maximumFileSize': maximumFileSize,
      'url': url,
    };
  }
}


class UploadImageSuccessResponse {
  final DateTime accessibleTo;
  final String directory;
  final String mime;
  final String name;
  final String originalName;
  final String ownerId;
  final int size;
  final String url;

  UploadImageSuccessResponse({
    required this.accessibleTo,
    required this.directory,
    required this.mime,
    required this.name,
    required this.originalName,
    required this.ownerId,
    required this.size,
    required this.url,
  });

  factory UploadImageSuccessResponse.fromJson(Map<String, dynamic> json) {
    return UploadImageSuccessResponse(
      accessibleTo: DateTime.parse(json['accessibleTo'] as String),
      directory: json['directory'] as String,
      mime: json['mime'] as String,
      name: json['name'] as String,
      originalName: json['originalName'] as String,
      ownerId: json['ownerId'] as String,
      size: json['size'] as int,
      url: json['url'] as String,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'accessibleTo': accessibleTo.toIso8601String(),
      'directory': directory,
      'mime': mime,
      'name': name,
      'originalName': originalName,
      'ownerId': ownerId,
      'size': size,
      'url': url,
    };
  }
}
