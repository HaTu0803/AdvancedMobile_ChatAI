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
                  onPressed: () => showDetails!(context, Prompt(
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
                  ), onToggleFavorite!),
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
      description: json["description"] ?? "No description",
      isPublic: json["isPublic"] ?? false,
      language: json["language"] ?? "en",
      title: json["title"] ?? "Untitled",
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
      updatedAt: _parseCreatedAt(promptItem.updatedAt), // Assuming updatedAt is also a String
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

// Hàm để xây dựng các PromptItem vào một Widget
Widget? buildPromptItem(PromptItem? promptItem) {
  if (promptItem == null) {
    return null;
  }

  return promptItem;
}

// Widget để hiển thị danh sách PromptItem
class PromptList extends StatelessWidget {
  final List<PromptItem> promptItems;

  PromptList({required this.promptItems});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: promptItems.length,
      itemBuilder: (context, index) {
        return buildPromptItem(promptItems[index]) ?? Container();
      },
    );
  }
}
