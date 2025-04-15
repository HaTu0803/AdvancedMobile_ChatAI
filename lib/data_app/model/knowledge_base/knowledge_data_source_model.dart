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
