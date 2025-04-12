class Items {
  final String? title;
  final String id;
  final int? createAt;

  Items({
    this.title,
    required this.id,
    this.createAt,
  });
}

class ConversationRequest {
  final String? cursor;
  final String? limit;
  final String? assistantId;
  final String assistantModel;

  ConversationRequest({
    this.cursor,
    this.limit,
    this.assistantId,
    required this.assistantModel,
  });

  Map<String, dynamic> toJson() {
    return {
      'cursor': cursor,
      'limit': limit,
      'assistant_id': assistantId,
      'assistant_model': assistantModel,
    };
  }
}

class ConversationResponse {
  final List<Items> items;
  final String cursor;
  final bool has_more;
  final int limit;

  ConversationResponse({
    required this.items,
    required this.cursor,
    required this.has_more,
    required this.limit,
  });

  factory ConversationResponse.fromJson(Map<String, dynamic> json) {
    final List<Items> items = [];
    final List<dynamic> data = json['data'];
    for (final item in data) {
      items.add(Items(
        title: item['title'],
        id: item['id'],
        createAt: item['create_at'],
      ));
    }

    return ConversationResponse(
      items: items,
      cursor: json['cursor'],
      has_more: json['has_more'],
      limit: json['limit'],
    );
  }
}

class ConversationHistoryResponse {
  final String cursor;
  final bool hasMore;
  final int limit;
  final List<ConversationHistoryItem> items;

  ConversationHistoryResponse({
    required this.cursor,
    required this.hasMore,
    required this.limit,
    required this.items,
  });

  factory ConversationHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ConversationHistoryResponse(
      cursor: json['cursor'],
      hasMore: json['has_more'],
      limit: json['limit'],
      items: (json['items'] as List)
          .map((item) => ConversationHistoryItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'cursor': cursor,
        'has_more': hasMore,
        'limit': limit,
        'items': items.map((e) => e.toJson()).toList(),
      };
}

class ConversationHistoryItem {
  final String? answer;
  final int? createdAt;
  final List<dynamic>? files;
  final String? query;

  ConversationHistoryItem({
    this.answer,
    this.createdAt,
    this.files,
    this.query,
  });

  factory ConversationHistoryItem.fromJson(Map<String, dynamic> json) {
    return ConversationHistoryItem(
      answer: json['answer'] ?? "",
      createdAt: json['createdAt'] ?? 0,
      files: json['files'] ?? [],
      query: json['query'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'answer': answer,
        'createdAt': createdAt,
        'files': files,
        'query': query,
      };
}
