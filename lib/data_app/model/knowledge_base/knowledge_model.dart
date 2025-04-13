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

  KnowledgeResponse({
    required String createdAt,
    String? updatedAt,
    String? createdBy,
    String? updatedBy,
    required this.userId,
    required this.knowledgeName,
    required this.description,
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

  UnitsOfKnowledgeResponse({
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

  factory UnitsOfKnowledgeResponse.fromJson(Map<String, dynamic> json) {
    return UnitsOfKnowledgeResponse(
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
