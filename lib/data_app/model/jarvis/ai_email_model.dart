class EmailRequestModel {
  final String mainIdea;
  final String action;
  final String email;
  final MetadataRequest metadata;
  // final AssistantDto? assistant;

  EmailRequestModel({
    required this.mainIdea,
    required this.action,
    required this.email,
    required this.metadata,
    // this.assistant,
  });

  factory EmailRequestModel.fromJson(Map<String, dynamic> json) {
    return EmailRequestModel(
      mainIdea: json['mainIdea'],
      action: json['action'],
      email: json['email'],
      metadata: MetadataRequest.fromJson(json['metadata']),
      // assistant: json['assistant'] != null
      //     ? AssistantDto.fromJson(json['assistant'])
      //     : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mainIdea': mainIdea,
      'action': action,
      'email': email,
      'metadata': metadata.toJson(),
      // 'assistant': assistant?.toJson(), // Use null-aware operator
    };
  }
}

class MetadataRequest {
  final List<dynamic> context;
  final String subject;
  final String sender;
  final String receiver;
  final Style style;
  final String language;

  MetadataRequest({
    required this.context,
    required this.subject,
    required this.sender,
    required this.receiver,
    required this.style,
    required this.language,
  });

  factory MetadataRequest.fromJson(Map<String, dynamic> json) {
    return MetadataRequest(
      context: json['context'] ?? [],
      subject: json['subject'],
      sender: json['sender'],
      receiver: json['receiver'],
      style: Style.fromJson(json['style']),
      language: json['language'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'context': context,
      'subject': subject,
      'sender': sender,
      'receiver': receiver,
      'style': style.toJson(),
      'language': language,
    };
  }
}

class Style {
  final String length;
  final String formality;
  final String tone;

  Style({
    required this.length,
    required this.formality,
    required this.tone,
  });

  factory Style.fromJson(Map<String, dynamic> json) {
    return Style(
      length: json['length'],
      formality: json['formality'],
      tone: json['tone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'formality': formality,
      'tone': tone,
    };
  }
}

class AssistantDto {
  final String? id; // enum optional
  final String model; // enum required, default 'dify'

  AssistantDto({
    this.id,
    this.model = 'dify',
  });

  factory AssistantDto.fromJson(Map<String, dynamic> json) {
    return AssistantDto(
      id: json['id'],
      model: json['model'] ?? 'dify',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
    };
  }
}

class SuggestReplyIdeas {
  final String action;
  final String email;
  final MetadataSuggest metadata;
  // final AssistantDto? assistant;

  SuggestReplyIdeas(
      {required this.action,
      required this.email,
      required this.metadata,
      // this.assistant
      });

  factory SuggestReplyIdeas.fromJson(Map<String, dynamic> json) {
    return SuggestReplyIdeas(
      action: json['action'],
      email: json['email'],
      metadata: MetadataSuggest.fromJson(json['metadata']),
      // assistant: json['assistant'] != null
      //     ? AssistantDto.fromJson(json['assistant'])
      //     : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'email': email,
      'metadata': metadata.toJson(),
      // 'assistant': assistant?.toJson(),
    };
  }
}

class MetadataSuggest {
  final List<String> context;
  final String subject;
  final String sender;
  final String receiver;
  final String? language;

  MetadataSuggest({
    required this.context,
    required this.subject,
    required this.sender,
    required this.receiver,
     this.language,
  });

  factory MetadataSuggest.fromJson(Map<String, dynamic> json) {
    return MetadataSuggest(
      context: List<String>.from(json['context'] ?? []),
      subject: json['subject'],
      sender: json['sender'],
      receiver: json['receiver'],
      language: json['language'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'context': context,
      'subject': subject,
      'sender': sender,
      'receiver': receiver,
      'language': language,
    };
  }
}

class EmailResponse {
  final String email;
  final int remainingUsage;
  final List<String> improvedActions;

  EmailResponse({
    required this.email,
    required this.remainingUsage,
    required this.improvedActions,
  });

  factory EmailResponse.fromJson(Map<String, dynamic> json) {
    return EmailResponse(
      email: json['email'],
      remainingUsage: json['remainingUsage'],
      improvedActions: List<String>.from(json['improvedActions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'remainingUsage': remainingUsage,
      'improvedActions': improvedActions,
    };
  }
}

class IdeaResponse {
  final List<String> ideas;

  IdeaResponse({required this.ideas});

  factory IdeaResponse.fromJson(Map<String, dynamic> json) {
    return IdeaResponse(
      ideas: List<String>.from(json['ideas']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'ideas': ideas,
    };
  }
}
