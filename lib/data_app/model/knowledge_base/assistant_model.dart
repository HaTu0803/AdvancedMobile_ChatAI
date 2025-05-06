import 'package:advancedmobile_chatai/data_app/model/base/base_model.dart';

class AiModel {
  final String id;
  final String name;
  final String? model;
  final String? iconPath;
  final bool? isDefault;

  AiModel({
    required this.id,
    required this.name,
    this.model,
    this.iconPath,
    this.isDefault = false,
  });

  factory AiModel.fromJson(Map<String, dynamic> json) {
    final isDefaultValue = json['isDefault'] ?? false;
    return AiModel(
      id: json['id'],
      name: json['name'],
      model: isDefaultValue ? 'dify' : 'knowledge-base',
      iconPath: json['iconPath'] ?? 'images/icons/your_bots.svg',
      isDefault: isDefaultValue,
    );
  }

  Map<String, dynamic> toJson() {
    final isDefaultValue = isDefault ?? false;
    return {
      'id': id,
      'name': name,
      'model': isDefaultValue ? 'dify' : 'knowledge-base',
      'iconPath': iconPath ?? 'images/icons/your_bots.svg',
      'isDefault': isDefaultValue,
    };
  }
}

class Assistant {
  String assistantName;
  String? instructions;
  String? description;

  Assistant({
    required this.assistantName,
    this.instructions,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'assistantName': assistantName,
      'instructions': instructions,
      'description': description,
    };
  }

  factory Assistant.fromJson(Map<String, dynamic> json) {
    return Assistant(
      assistantName: json['assistantName'],
      instructions: json['instructions'],
      description: json['description'],
    );
  }
}

class GetAssistants extends BaseQueryParams {
  bool? is_favorite;
  bool? is_published;

  GetAssistants({
    String? q,
    String? order,
    String? order_field,
    int? offset,
    int? limit,
    this.is_favorite,
    this.is_published,
  }) : super(
          q: q,
          order: order,
          order_field: order_field,
          offset: offset,
          limit: limit,
        );

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    // Only add non-null values from base class
    final baseMap = super.toJson();
    baseMap.forEach((key, value) {
      if (value != null) {
        map[key] = value;
      }
    });

    // Only add non-null values of GetAssistants
    if (is_favorite != null) map['is_favorite'] = is_favorite;
    if (is_published != null) map['is_published'] = is_published;

    return map;
  }

  factory GetAssistants.fromJson(Map<String, dynamic> json) {
    return GetAssistants(
      q: json['q'],
      order: json['order'],
      order_field: json['order_field'],
      offset: json['offset'],
      limit: json['limit'],
      is_favorite: json['is_favorite'],
      is_published: json['is_published'],
    );
  }
}

class KnowledgeToAssistant {
  String assistantId;
  String knowledgeId;

  KnowledgeToAssistant({
    required this.assistantId,
    required this.knowledgeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'assistantId': assistantId,
      'knowledgeId': knowledgeId,
    };
  }

  factory KnowledgeToAssistant.fromJson(Map<String, dynamic> json) {
    return KnowledgeToAssistant(
      assistantId: json['assistantId'],
      knowledgeId: json['knowledgeId'],
    );
  }
}

class ThreadAssistant {
  String assistantId;
  String? firstMessage;

  ThreadAssistant({
    required this.assistantId,
    this.firstMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'assistantId': assistantId,
      'firstMessage': firstMessage,
    };
  }

  factory ThreadAssistant.fromJson(Map<String, dynamic> json) {
    return ThreadAssistant(
      assistantId: json['assistantId'],
      firstMessage: json['firstMessage'],
    );
  }
}

class AskAssistant {
  String message;
  String openAiThreadId;
  String additionalInstruction;

  AskAssistant({
    required this.message,
    required this.openAiThreadId,
    required this.additionalInstruction,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'openAiThreadId': openAiThreadId,
      'additionalInstruction': additionalInstruction,
    };
  }

  factory AskAssistant.fromJson(Map<String, dynamic> json) {
    return AskAssistant(
      message: json['message'],
      openAiThreadId: json['openAiThreadId'],
      additionalInstruction: json['additionalInstruction'],
    );
  }
}

class AssistantResponse extends BaseModel {
  final String id;
  final String assistantName;
  final String? openAiAssistantId;
  final String? instructions;
  final String? description;
  final String? openAiThreadIdPlay;
  final bool? isDefault;
  final bool? isFavorite;

  AssistantResponse({
    required String createdAt,
    String? updatedAt,
    String? createdBy,
    String? updatedBy,
    required this.id,
    required this.assistantName,
     this.openAiAssistantId,
    this.instructions,
    this.description,
    this.openAiThreadIdPlay,
    this.isDefault,
    this.isFavorite,
  }) : super(
          createdAt: createdAt,
          updatedAt: updatedAt,
          createdBy: createdBy,
          updatedBy: updatedBy,
        );
  AssistantResponse copyWith({
    String? id,
    String? assistantName,
    String? openAiAssistantId,
    String? instructions,
    String? description,
    String? openAiThreadIdPlay,
    bool? isDefault,
    bool? isFavorite,
    String? createdAt,
    String? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) {
    return AssistantResponse(
      id: id ?? this.id,
      assistantName: assistantName ?? this.assistantName,
      openAiAssistantId: openAiAssistantId ?? this.openAiAssistantId,
      instructions: instructions ?? this.instructions,
      description: description ?? this.description,
      openAiThreadIdPlay: openAiThreadIdPlay ?? this.openAiThreadIdPlay,
      isDefault: isDefault ?? this.isDefault,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  factory AssistantResponse.fromJson(Map<String, dynamic> json) {
    return AssistantResponse(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      id: json['id'],
      assistantName: json['assistantName'],
      openAiAssistantId: json['openAiAssistantId'],
      instructions: json['instructions'],
      description: json['description'],
      openAiThreadIdPlay: json['openAiThreadIdPlay'],
      isDefault: json['isDefault'],
      isFavorite: json['isFavorite'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'id': id,
      'assistantName': assistantName,
      'openAiAssistantId': openAiAssistantId,
      'instructions': instructions,
      'description': description,
      'openAiThreadIdPlay': openAiThreadIdPlay,
      'isDefault': isDefault,
      'isFavorite': isFavorite,
    };
  }
}

class AssistantListResponse {
  final List<AssistantResponse> data;
  final Meta meta;

  AssistantListResponse({
    required this.data,
    required this.meta,
  });

  factory AssistantListResponse.fromJson(Map<String, dynamic> json) {
    return AssistantListResponse(
      data: (json['data'] as List)
          .map((item) => AssistantResponse.fromJson(item))
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

class KnowledgeAssistantResponse extends BaseModel {
  String userId;
  String knowledgeName;
  String description;

  KnowledgeAssistantResponse({
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
  factory KnowledgeAssistantResponse.fromJson(Map<String, dynamic> json) {
    return KnowledgeAssistantResponse(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      userId: json['userId'],
      knowledgeName: json['knowledgeName'],
      description: json['description'],
    );
  }
}

class KnowledgeAssistantListResponse {
  List<KnowledgeAssistantResponse> data;
  Meta meta;

  KnowledgeAssistantListResponse({
    required this.data,
    required this.meta,
  });

  factory KnowledgeAssistantListResponse.fromJson(Map<String, dynamic> json) {
    return KnowledgeAssistantListResponse(
      data: (json['data'] as List)
          .map((item) => KnowledgeAssistantResponse.fromJson(item))
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

class ThreadAssistantResponse extends BaseModel {
  final String id;
  final String assistantId;
  final String openAiThreadId;
  final String threadName;

  ThreadAssistantResponse({
    required String createdAt,
    String? updatedAt,
    String? createdBy,
    String? updatedBy,
    required this.id,
    required this.assistantId,
    required this.openAiThreadId,
    required this.threadName,
  }) : super(
          createdAt: createdAt,
          updatedAt: updatedAt,
          createdBy: createdBy,
          updatedBy: updatedBy,
        );

  factory ThreadAssistantResponse.fromJson(Map<String, dynamic> json) {
    return ThreadAssistantResponse(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      id: json['id'],
      assistantId: json['assistantId'],
      openAiThreadId: json['openAiThreadId'],
      threadName: json['threadName'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'id': id,
      'assistantId': assistantId,
      'openAiThreadId': openAiThreadId,
      'threadName': threadName,
    };
  }
}

class ThreadAssistantListResponse {
  final List<ThreadAssistantResponse> data;
  final Meta meta;

  ThreadAssistantListResponse({
    required this.data,
    required this.meta,
  });

  factory ThreadAssistantListResponse.fromJson(Map<String, dynamic> json) {
    return ThreadAssistantListResponse(
      data: (json['data'] as List)
          .map((item) => ThreadAssistantResponse.fromJson(item))
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

class MessageContent {
  final String type;
  final MessageText text;

  MessageContent({
    required this.type,
    required this.text,
  });

  factory MessageContent.fromJson(Map<String, dynamic> json) {
    return MessageContent(
      type: json['type'],
      text: MessageText.fromJson(json['text']),
    );
  }
}

class MessageText {
  final String value;
  final List<dynamic> annotations;

  MessageText({
    required this.value,
    required this.annotations,
  });

  factory MessageText.fromJson(Map<String, dynamic> json) {
    return MessageText(
      value: json['value'],
      annotations: json['annotations'] ?? [],
    );
  }
}

class RetrieveMessageOfThreadResponse {
  final String role;
  final int createdAt;
  final List<MessageContent> content;

  RetrieveMessageOfThreadResponse({
    required this.role,
    required this.createdAt,
    required this.content,
  });

  factory RetrieveMessageOfThreadResponse.fromJson(Map<String, dynamic> json) {
    return RetrieveMessageOfThreadResponse(
      role: json['role'],
      createdAt: json['createdAt'],
      content: (json['content'] as List)
          .map((item) => MessageContent.fromJson(item))
          .toList(),
    );
  }
}
