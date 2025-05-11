import 'package:advancedmobile_chatai/data_app/model/base/base_model.dart';
abstract class BaseMetadata {
  Map<String, dynamic> toJson();
}

class DataSourceRequest {
  final List<DataSource> datasources;

  DataSourceRequest({required this.datasources});

  Map<String, dynamic> toJson() {
    return {
      'datasources': datasources.map((ds) => ds.toJson()).toList(),
    };
  }
}

class DataSource {
  final String type;
  final String name;
  final FileCredentials credentials;

  DataSource({
    required this.type,
    required this.name,
    required this.credentials,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'credentials': credentials.toJson(),
    };
  }
}

class FileCredentials {
  final String file;

  FileCredentials({required this.file});

  Map<String, dynamic> toJson() {
    return {
      'file': file,
    };
  }
}

class FileModelResponse {
  final List<FileModel> files;

  FileModelResponse({required this.files});

  factory FileModelResponse.fromJson(Map<String, dynamic> json) {
    return FileModelResponse(
      files: (json['files'] as List)
          .map((e) => FileModel.fromJson(e))
          .toList(),
    );
  }


}
class FileModel {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String name;
  final String extension;
  final String mimeType;
  final int size;
  final String owner;
  final String url;

  FileModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.extension,
    required this.mimeType,
    required this.size,
    required this.owner,
    required this.url,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      name: json['name'],
      extension: json['extension'],
      mimeType: json['mime_type'],
      size: json['size'],
      owner: json['owner'],
      url: json['url'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'name': name,
      'extension': extension,
      'mime_type': mimeType,
      'size': size,
      'owner': owner,
      'url': url,
    };
  }

}

class DataSourceResponse {
  final List<KnowledgeDataSource> data;
  final Meta meta;

  DataSourceResponse({required this.data, required this.meta});

  factory DataSourceResponse.fromJson(Map<String, dynamic> json) {
    return DataSourceResponse(
      data: (json['data'] as List)
          .map((e) => KnowledgeDataSource.fromJson(e))
          .toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }
}
class KnowledgeDataSource {
  final String name;
  final String type;
  final int size;
  final bool status;
  final String userId;
  final BaseMetadata metadata;
  final String knowledgeId;
  final String? deletedAt;
  final String id;
  final String createdAt;
  final String? updatedAt;
  final String? createdBy;
  final String? updatedBy;

  KnowledgeDataSource({
    required this.name,
    required this.type,
    required this.size,
    required this.status,
    required this.userId,
    required this.metadata,
    required this.knowledgeId,
    required this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    required this.id,
  });

  factory KnowledgeDataSource.fromJson(Map<String, dynamic> json) {
    BaseMetadata metadata;
    if (json['type'] == 'confluence') {
      metadata = MetadataConfluence.fromJson(json['metadata']);
    } else if (json['type'] == 'local_file') {
      metadata = Metadata.fromJson(json['metadata']);
    }
    else {
      metadata = Metadata.fromJson(json['metadata']);
    }

    return KnowledgeDataSource(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      size: json['size'] ?? 0,
      status: json['status'] ?? false,
      userId: json['userId'] ?? '',
      metadata: metadata,
      knowledgeId: json['knowledgeId'] ?? '',
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt']).toIso8601String()
          : null,
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'size': size,
      'status': status,
      'userId': userId,
      'metadata': metadata.toJson(),
      'knowledgeId': knowledgeId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'deletedAt': deletedAt,
      'id': id,
    };
  }
}

class Metadata extends BaseMetadata {
  final String? fileId;
  final String? fileUrl;
  final String? mimeType;

  Metadata({
    required this.fileId,
    required this.fileUrl,
    required this.mimeType,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      fileId: json['fileId'],
      fileUrl: json['fileUrl'],
      mimeType: json['mimeType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileId': fileId,
      'fileUrl': fileUrl,
      'mimeType': mimeType,
    };
  }

}



class ConfluenceCredentials {
  final String url;
  final String username;
  final String token;

  ConfluenceCredentials({required this.url, required this.username, required this.token});

  factory ConfluenceCredentials.fromJson(Map<String, dynamic> json) {
    return ConfluenceCredentials(
      url: json['url'],
      username: json['username'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'username': username,
      'token': token,
    };
  }
}

class DataSourceConfluence {
  final String type;
  final String name;
  final ConfluenceCredentials credentials;

  DataSourceConfluence({required this.type, required this.name, required this.credentials});

  factory DataSourceConfluence.fromJson(Map<String, dynamic> json) {
    return DataSourceConfluence(
      type: json['type'],
      name: json['name'],
      credentials: ConfluenceCredentials.fromJson(json['credentials']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'credentials': credentials.toJson(),
    };
  }
}

class DataSourcesModel {
  final List<DataSourceConfluence> datasources;

  DataSourcesModel({required this.datasources});

  factory DataSourcesModel.fromJson(Map<String, dynamic> json) {
    var list = json['datasources'] as List;
    List<DataSourceConfluence> datasourceList = list.map((i) => DataSourceConfluence.fromJson(i)).toList();

    return DataSourcesModel(datasources: datasourceList);
  }

  Map<String, dynamic> toJson() {
    return {
      'datasources': datasources.map((i) => i.toJson()).toList(),
    };
  }
}


class ConfluenceResponse extends BaseModel {
  final String name;
  final String type;
  final int size;
  final bool status;
  final String userId;
  final MetadataConfluence metadata;
  final String knowledgeId;
  final String? deletedAt;
  final String id;

  ConfluenceResponse({
    required this.name,
    required this.type,
    required this.size,
    required this.status,
    required this.userId,
    required this.metadata,
    required this.knowledgeId,
    required String createdAt,
    String? updatedAt,
    String? createdBy,
    String? updatedBy,
    this.deletedAt,
    required this.id,
  }) : super(
    createdAt: createdAt,
    updatedAt: updatedAt,
    createdBy: createdBy,
    updatedBy: updatedBy,
  );

  factory ConfluenceResponse.fromJson(Map<String, dynamic> json) {
    return ConfluenceResponse(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      size: json['size'] ?? 0,
      status: json['status'] ?? false,
      userId: json['userId'] ?? '',
      metadata: MetadataConfluence.fromJson(json['metadata'] ?? {}),
      knowledgeId: json['knowledgeId'] ?? '',
      createdBy: json['createdBy'] ,
      updatedBy: json['updatedBy'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']).toIso8601String() : null,
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'size': size,
      'status': status,
      'userId': userId,
      'metadata': metadata.toJson(),
      'knowledgeId': knowledgeId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'deletedAt': deletedAt,
      'id': id,
    };
  }
}
class MetadataConfluence extends BaseMetadata {
  final String datasourceId;

  MetadataConfluence({
    required this.datasourceId,
  });

  factory MetadataConfluence.fromJson(Map<String, dynamic> json) {
    return MetadataConfluence(
      datasourceId: json['datasourceId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'datasourceId': datasourceId,
    };
  }
}
