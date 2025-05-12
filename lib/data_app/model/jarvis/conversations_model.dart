import 'package:flutter/material.dart';

class Items {
  final String? title;
  final String id;
  final String? createAt;

  Items({
    this.title,
    required this.id,
    this.createAt,
  });
}

class ConversationRequest {
  final String? cursor;
  final int? limit;
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
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': limit,
      if (assistantId != null) 'assistantId': assistantId,
      'assistantModel': assistantModel,
    };
  }

  String toQueryString() {
    final query = toJson().entries
        .where((e) => e.value != null)
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
    return query;
  }
}


class ConversationResponse {
  final List<Items> items;
  final String? cursor;
  final bool has_more;
  final int limit;

  ConversationResponse({
    required this.items,
     this.cursor,
    required this.has_more,
    required this.limit,
  });

  factory ConversationResponse.fromJson(Map<String, dynamic> json) {
    final List<Items> items = [];
    final List<dynamic> data = json['items'];

    for (final item in data) {
      items.add(Items(
        title: item['title'],
        id: item['id'],
        createAt: item['createdAt'],
      ));
    }

    return ConversationResponse(
      items: items,
      cursor: json['cursor']  ?? "",
      has_more: json['has_more'],
      limit: json['limit'] is int
          ? json['limit']
          : int.tryParse(json['limit'].toString()) ?? 0,
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
    List<ConversationHistoryItem> itemsList = [];
    if (json['items'] != null) {
      if (json['items'] is List) {
        itemsList = (json['items'] as List)
            .map((item) => ConversationHistoryItem.fromJson(item))
            .toList();
      }
    }

    return ConversationHistoryResponse(
      cursor: json['cursor']?.toString() ?? '',
      hasMore: json['has_more'] ?? false,
      limit: json['limit'] is int ? json['limit'] : int.tryParse(json['limit'].toString()) ?? 0,
      items: itemsList,
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
      answer: json['answer']?.toString(),
      createdAt: json['createdAt'] is int ? json['createdAt'] : int.tryParse(json['createdAt'].toString()),
      files: json['files'] is List ? json['files'] : [],
      query: json['query']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'answer': answer,
        'createdAt': createdAt,
        'files': files,
        'query': query,
      };
}
