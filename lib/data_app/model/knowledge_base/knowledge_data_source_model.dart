import 'package:advancedmobile_chatai/data_app/model/base/base_model.dart';

class UpLoadFileSlack {
  String unitName;
  String slackWorkspace;
  String slackBotToken;

  UpLoadFileSlack({
    required this.unitName,
    required this.slackWorkspace,
    required this.slackBotToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'unitName': unitName,
      'slackWorkspace': slackWorkspace,
      'slackBotToken': slackBotToken,
    };
  }

  factory UpLoadFileSlack.fromJson(Map<String, dynamic> json) {
    return UpLoadFileSlack(
      unitName: json['unitName'],
      slackWorkspace: json['slackWorkspace'],
      slackBotToken: json['slackBotToken'],
    );
  }
}

class UploadWebsite {
  String unitName;
  String webUrl;

  UploadWebsite({
    required this.unitName,
    required this.webUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'unitName': unitName,
      'webUrl': webUrl,
    };
  }

  factory UploadWebsite.fromJson(Map<String, dynamic> json) {
    return UploadWebsite(
      unitName: json['unitName'],
      webUrl: json['webUrl'],
    );
  }
}

class UploadFileResponse extends BaseModel {
  String id;
  String name;
  bool status;
  String userId;
  String knowledgeId;

  UploadFileResponse({
    required String createdAt,
    String? updatedAt,
    String? createdBy,
    String? updatedBy,
    required this.id,
    required this.name,
    required this.status,
    required this.userId,
    required this.knowledgeId,
  }) : super(
          createdAt: createdAt,
          updatedAt: updatedAt,
          createdBy: createdBy,
          updatedBy: updatedBy,
        );

  factory UploadFileResponse.fromJson(Map<String, dynamic> json) {
    return UploadFileResponse(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      id: json['id'],
      name: json['name'],
      status: json['status'],
      userId: json['userId'],
      knowledgeId: json['knowledgeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'id': id,
      'name': name,
      'status': status,
      'userId': userId,
      'knowledgeId': knowledgeId,
    };
  }
}

class UploadFileConfluence {
  String unitName;
  String wikiPageUrl;
  String confluenceUsername;
  String confluenceAccessToken;

  UploadFileConfluence({
    required this.unitName,
    required this.wikiPageUrl,
    required this.confluenceUsername,
    required this.confluenceAccessToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'unitName': unitName,
      'wikiPageUrl': wikiPageUrl,
      'confluenceUsername': confluenceUsername,
      'confluenceAccessToken': confluenceAccessToken,
    };
  }

  factory UploadFileConfluence.fromJson(Map<String, dynamic> json) {
    return UploadFileConfluence(
      unitName: json['unitName'],
      wikiPageUrl: json['wikiPageUrl'],
      confluenceUsername: json['confluenceUsername'],
      confluenceAccessToken: json['confluenceAccessToken'],
    );
  }
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
  final Credentials credentials;

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

class Credentials {
  final String file;

  Credentials({required this.file});

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
}

class DataSourceResponse {
  final List<KnowledgeDataSource> datasources;
  final Meta meta;

  DataSourceResponse({required this.datasources, required this.meta});

  factory DataSourceResponse.fromJson(Map<String, dynamic> json) {
    return DataSourceResponse(
      datasources: (json['data'] as List)
          .map((e) => KnowledgeDataSource.fromJson(e))
          .toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

class KnowledgeDataSource extends BaseModel {
  final String name;
  final String type;
  final int size;
  final bool status;
  final String userId;
  final Metadata metadata;
  final String knowledgeId;
  final DateTime? deletedAt;
  final String id;


  KnowledgeDataSource({
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

  factory KnowledgeDataSource.fromJson(Map<String, dynamic> json) {
    return KnowledgeDataSource(
      name: json['name'],
      type: json['type'],
      size: json['size'],
      status: json['status'],
      userId: json['userId'],
      metadata: Metadata.fromJson(json['metadata']),
      knowledgeId: json['knowledgeId'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      id: json['id'],
    );
  }
}

class Metadata {
  final String fileId;
  final String fileUrl;
  final String mimeType;

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
}

