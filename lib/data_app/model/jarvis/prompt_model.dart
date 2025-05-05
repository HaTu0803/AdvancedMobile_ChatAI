import 'package:flutter/material.dart';

// Model cho PromptResponse
class PromptResponse {
  final bool hasNext;
  final int offset;
  final int limit;
  final int total;
  final List<PromptItem> items;

  PromptResponse({
    required this.hasNext,
    required this.offset,
    required this.limit,
    required this.total,
    required this.items,
  });

  factory PromptResponse.fromJson(Map<String, dynamic> json) {
    return PromptResponse(
      hasNext: json["hasNext"],
      offset: json["offset"],
      limit: json["limit"],
      total: json["total"],
      items: (json["items"] as List<dynamic>)
          .map((item) => PromptItem.fromJson(item))
          .toList(),
    );
  }
}

// Model cho PromptItem
class PromptItem extends StatelessWidget {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String category;
  final String content;
  final String description;
  final bool isPublic;
  final String language;
  final String title;
  final String userId;
  final String userName;
  bool isFavorite;
  final Function? onToggleFavorite;
  final Function(BuildContext, Prompt, Function)? showDetails;

  PromptItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.content,
    required this.description,
    required this.isPublic,
    required this.language,
    required this.title,
    required this.userId,
    required this.userName,
    this.isFavorite = false,
    this.onToggleFavorite,
    this.showDetails,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(description),
      trailing: onToggleFavorite != null && showDetails != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.star,
                    color: isFavorite ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () => onToggleFavorite!(),
                ),
                IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () => showDetails!(
                      context,
                      Prompt(
                        id: id,
                        createdAt: DateTime.parse(createdAt),
                        updatedAt: DateTime.parse(updatedAt),
                        category: category,
                        content: content,
                        description: description,
                        isPublic: isPublic,
                        language: language,
                        title: title,
                        userId: userId,
                        userName: userName,
                        isFavorite: isFavorite,
                      ),
                      onToggleFavorite!),
                ),
              ],
            )
          : null,
    );
  }

  factory PromptItem.fromJson(Map<String, dynamic> json) {
    return PromptItem(
      id: json["_id"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      category: json["category"] ?? "Unknown",
      content: json["content"] ?? "",
      description: json["description"] ?? "",
      isPublic: json["isPublic"] ?? false,
      language: json["language"] ?? "en",
      title: json["title"] ?? "",
      userId: json["userId"] ?? "Unknown",
      userName: json["userName"] ?? "Anonymous",
      isFavorite: json["isFavorite"] ?? false,
    );
  }
}

// Model cho Prompt
class Prompt {
  final String id;
  final String title;
  final String description;
  final String category;
  bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String content;
  final bool isPublic;
  final String language;
  final String userId;
  final String userName;

  Prompt({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
    required this.content,
    required this.isPublic,
    required this.language,
    required this.userId,
    required this.userName,
  });

  // Hàm khởi tạo từ PromptItem
  factory Prompt.fromPromptItem(PromptItem promptItem) {
    return Prompt(
      id: promptItem.id,
      title: promptItem.title,
      description: promptItem.description,
      category: promptItem.category,
      isFavorite: promptItem.isFavorite,
      createdAt: _parseCreatedAt(promptItem.createdAt),
      updatedAt: _parseCreatedAt(
          promptItem.updatedAt), // Assuming updatedAt is also a String
      content: promptItem.content,
      isPublic: promptItem.isPublic,
      language: promptItem.language,
      userId: promptItem.userId,
      userName: promptItem.userName,
    );
  }

  // Hàm hỗ trợ để phân tích thời gian
  static DateTime _parseCreatedAt(String createdAt) {
    try {
      return DateTime.parse(createdAt);
    } catch (e) {
      return DateTime.now(); // Nếu không thể parse, trả về thời gian hiện tại
    }
  }
}

class CreatePromptRequest {
  final String title;
  final String content;
  final String? description;
  final bool isPublic;

  CreatePromptRequest({
    required this.title,
    required this.content,
    this.description,
    required this.isPublic,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'description': description,
      'isPublic': isPublic,
    };
  }
}

class CreatePromptResponse {
  final String category;
  final String content;
  final String description;
  final bool isPublic;
  final String language;
  final String title;
  final String userId;
  final String userName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String id;
  final String? createdBy;
  final String? updatedBy;

  CreatePromptResponse({
    required this.category,
    required this.content,
    required this.description,
    required this.isPublic,
    required this.language,
    required this.title,
    required this.userId,
    required this.userName,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    this.createdBy,
    this.updatedBy,
  });

  factory CreatePromptResponse.fromJson(Map<String, dynamic> json) {
    return CreatePromptResponse(
      category: json['category'] ?? '',
      content: json['content'] ?? '',
      description: json['description'] ?? '',
      isPublic: json['isPublic'] ?? false,
      language: json['language'] ?? '',
      title: json['title'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      id: json['_id'] ?? '',
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'content': content,
      'description': description,
      'isPublic': isPublic,
      'language': language,
      'title': title,
      'userId': userId,
      'userName': userName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '_id': id,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }
}

class GetPromptRequest {
  final String? query;
  final int? offset;
  final int? limit;
  final String? category;
  final bool? isFavorite;
  final bool? isPublic;

  GetPromptRequest({
    this.query,
    this.offset,
    this.limit,
    this.category,
    this.isFavorite,
    this.isPublic,
  });

  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};

    if (query != null && query!.isNotEmpty) {
      params['query'] = query!;
    }

    if (offset != null) {
      params['offset'] = offset.toString();
    }

    if (limit != null) {
      params['limit'] = limit.toString();
    }

    if (category != null && category!.isNotEmpty) {
      params['category'] = category!;
    }

    if (isFavorite != null) {
      params['isFavorite'] = isFavorite.toString();
    }

    if (isPublic != null) {
      params['isPublic'] = isPublic.toString();
    }

    return params;
  }
}

class GetPromptResponse {
  final bool hasNext;
  final int offset;
  final int limit;
  final int total;
  final List<PromptItemV2> items;

  GetPromptResponse({
    required this.hasNext,
    required this.offset,
    required this.limit,
    required this.total,
    required this.items,
  });

  factory GetPromptResponse.fromJson(Map<String, dynamic> json) {
    return GetPromptResponse(
      hasNext: json["hasNext"],
      offset: json["offset"],
      limit: json["limit"],
      total: json["total"],
      items: (json["items"] as List<dynamic>)
          .map((item) => PromptItemV2.fromJson(item))
          .toList(),
    );
  }
}

class PromptItemV2 {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String category;
  final String content;
  final String description;
  final bool isPublic;
  final String language;
  final String title;
  final String userId;
  final String userName;
  bool isFavorite;

  PromptItemV2({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.content,
    required this.description,
    required this.isPublic,
    required this.language,
    required this.title,
    required this.userId,
    required this.userName,
    this.isFavorite = false,
  });

  factory PromptItemV2.fromJson(Map<String, dynamic> json) {
    return PromptItemV2(
      id: json["_id"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      category: json["category"] ?? "Unknown",
      content: json["content"] ?? "",
      description: json["description"] ?? "No description",
      isPublic: json["isPublic"] ?? false,
      language: json["language"] ?? "Auto",
      title: json["title"] ?? "Untitled",
      userId: json["userId"] ?? "Unknown",
      userName: json["userName"] ?? "Anonymous",
      isFavorite: json["isFavorite"] ?? false,
    );
  }
}

class DeletePromptResponse {
  final bool acknowledged;
  final int deletedCount;
  final int affected;

  DeletePromptResponse({
    required this.acknowledged,
    required this.deletedCount,
    required this.affected,
  });

  factory DeletePromptResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['raw'] ?? {};
    return DeletePromptResponse(
      acknowledged: raw['acknowledged'] ?? false,
      deletedCount: raw['deletedCount'] ?? 0,
      affected: json['affected'] ?? 0,
    );
  }
}

// Model cho Category
class PromptCategory {
  final String name;
  bool isSelected;
  final String id;

  PromptCategory({
    required this.name,
    required this.isSelected,
    required this.id,
  });
}
