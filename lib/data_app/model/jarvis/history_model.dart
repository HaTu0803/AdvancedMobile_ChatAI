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
  ConversationRequest({
    this.cursor,
    this.limit,
    this.assistantId,
  });

  Map<String, dynamic> toJson() {
    return {
      'cursor': cursor,
      'limit': limit,
      'assistant_id': assistantId,
      'assistant_model': 'dify',
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
