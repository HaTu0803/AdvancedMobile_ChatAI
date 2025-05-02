import 'package:advancedmobile_chatai/data_app/model/base/base_model.dart';

class Knowledge {
  String knowledgeName;
  String? description;

  Knowledge({
    required this.knowledgeName,
    this.description,
  });

  factory Knowledge.fromJson(Map<String, dynamic> json) {
    return Knowledge(
      knowledgeName: json['knowledgeName'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'knowledgeName': knowledgeName,
      'description': description,
    };
  }
}

class KnowledgeResponse extends BaseModel {
  String userId;
  String knowledgeName;
  String description;
  int numUnits;
  int totalSize;
  String id;
  KnowledgeResponse({
    required String createdAt,
    String? updatedAt,
    String? createdBy,
    String? updatedBy,
    required this.userId,
    required this.knowledgeName,
    required this.description,
    required this.numUnits,
    required this.totalSize,
    required this.id,
  }) : super(
          createdAt: createdAt,
          updatedAt: updatedAt,
          createdBy: createdBy,
          updatedBy: updatedBy,
        );

  factory KnowledgeResponse.fromJson(Map<String, dynamic> json) {
    return KnowledgeResponse(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      userId: json['userId'],
      knowledgeName: json['knowledgeName'],
      description: json['description'],
      numUnits: json['numUnits'] ?? 0,
      totalSize: json['totalSize'] ?? 0,
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'userId': userId,
      'knowledgeName': knowledgeName,
      'description': description,
      'numUnits': numUnits,
      'totalSize': totalSize,
      'id': id,
    };
  }
}

class KnowledgeListResponse {
  final List<KnowledgeResponse> data;
  final Meta meta;

  KnowledgeListResponse({
    required this.data,
    required this.meta,
  });

  factory KnowledgeListResponse.fromJson(Map<String, dynamic> json) {
    return KnowledgeListResponse(
      data: (json['data'] as List)
          .map((item) => KnowledgeResponse.fromJson(item))
          .toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

class UnitsOfKnowledgeResponse extends BaseModel {
  String id;
  String name;
  bool status;
  String userId;
  String knowledgeId;
  String? type;
  int? size;
  List<String>? openAiFileIds;
  Map<String, dynamic>? metadata;
  String? deletedAt;
  String? imagePath;

  UnitsOfKnowledgeResponse({
    required String createdAt,
    String? updatedAt,
    String? createdBy,
    String? updatedBy,
    this.deletedAt,
    required this.id,
    required this.name,
    this.type,
    this.size,
    required this.status,
    required this.userId,
    required this.knowledgeId,
    this.openAiFileIds,
    this.metadata,
    this.imagePath
  }) : super(
    createdAt: createdAt,
    updatedAt: updatedAt,
    createdBy: createdBy,
    updatedBy: updatedBy,
  );

  factory UnitsOfKnowledgeResponse.fromJson(Map<String, dynamic> json) {
    final type = json['type'];

    // Mapping type -> image
    final imageMap = {
      'local_file': 'images/file.png',
      'web': 'images/web.png',
      'google_drive': 'images/google_drive.png',
      'github': 'images/github.png',
      'gitlab': 'images/gitlab.png',
      'slack': 'images/slack.png',
      'confluence': 'images/confluence.png',
    };

    return UnitsOfKnowledgeResponse(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      deletedAt: json['deletedAt'],
      id: json['id'],
      name: json['name'],
      type: json['type'],
      size: json['size'] is int ? json['size'] : int.tryParse(json['size'].toString()),
      status: json['status'],
      userId: json['userId'],
      knowledgeId: json['knowledgeId'],
      openAiFileIds: (json['openAiFileIds'] as List?)?.map((e) => e.toString()).toList(),
      metadata: json['metadata'] != null ? Map<String, dynamic>.from(json['metadata']) : null,
      imagePath: imageMap[type] ?? 'images/file.png',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'deletedAt': deletedAt,
      'id': id,
      'name': name,
      'type': type,
      'size': size,
      'status': status,
      'userId': userId,
      'knowledgeId': knowledgeId,
      'openAiFileIds': openAiFileIds,
      'metadata': metadata,
    };
  }
}

class UnitsOfKnowledgeListResponse {
  final List<UnitsOfKnowledgeResponse> data;
  final Meta meta;

  UnitsOfKnowledgeListResponse({
    required this.data,
    required this.meta,
  });

  factory UnitsOfKnowledgeListResponse.fromJson(Map<String, dynamic> json) {
    return UnitsOfKnowledgeListResponse(
      data: (json['data'] as List)
          .map((item) => UnitsOfKnowledgeResponse.fromJson(item))
          .toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}
