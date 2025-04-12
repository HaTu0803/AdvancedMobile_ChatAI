class ChatRequest {
  final String content;
  final List<dynamic> files;
  final ChatMetadata metadata;
  final AssistantInfo assistant;

  ChatRequest({
    required this.content,
    this.files = const [],
    required this.metadata,
    required this.assistant,
  });

  Map<String, dynamic> toJson() => {
        'content': content,
        'files': files,
        'metadata': metadata.toJson(),
        'assistant': assistant.toJson(),
      };
}

class ChatMetadata {
  final Conversation conversation;

  ChatMetadata({required this.conversation});

  Map<String, dynamic> toJson() => {
        'conversation': conversation.toJson(),
      };
}

class Conversation {
  final List<ChatMessage> messages;

  Conversation({required this.messages});

  Map<String, dynamic> toJson() => {
        'messages': messages.map((msg) => msg.toJson()).toList(),
      };
}

class ChatMessage {
  final String role; // 'user' hoặc 'model'
  final String content;
  final List<dynamic> files;
  final AssistantInfo assistant;

  ChatMessage({
    required this.role,
    required this.content,
    this.files = const [],
    required this.assistant,
  });

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
        'files': files,
        'assistant': assistant.toJson(),
      };
}

class AssistantInfo {
  final String model;
  final String name;
  final String id;

  AssistantInfo({
    required this.model,
    required this.name,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        'model': model,
        'name': name,
        'id': id,
      };
}

class ChatWithBotResponse {
  final String message;
  final int remainingUsage;

  ChatWithBotResponse({
    required this.message,
    required this.remainingUsage,
  });

  factory ChatWithBotResponse.fromJson(Map<String, dynamic> json) {
    return ChatWithBotResponse(
      message: json['message'],
      remainingUsage: json['remainingUsage'],
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'remainingUsage': remainingUsage,
      };
}

class ChatResponse {
  final String message;
  final int remainingUsage;
  final String conversationId;

  ChatResponse({
    required this.message,
    required this.remainingUsage,
    required this.conversationId,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      message: json['message'],
      remainingUsage: json['remainingUsage'],
      conversationId: json['conversationId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'remainingUsage': remainingUsage,
        'conversationId': conversationId,
      };
}
