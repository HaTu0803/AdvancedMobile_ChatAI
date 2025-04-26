import 'package:advancedmobile_chatai/data_app/model/jarvis/conversations_model.dart';
import 'package:advancedmobile_chatai/data_app/repository/jarvis/ai_chat_repository.dart';
import 'package:flutter/material.dart';

class ChatHistoryScreen extends StatefulWidget {
  final String assistantModel;

  const ChatHistoryScreen({
    super.key,
    required this.assistantModel,
  });

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  late Future<ConversationResponse> _conversationFuture;

  @override
  void initState() {
    super.initState();
    _conversationFuture = _fetchConversations();
  }

  Future<ConversationResponse> _fetchConversations() async {
    final repository = AiChatRepository();
    final request = ConversationRequest(
      limit: 100,
      assistantModel: widget.assistantModel,
    );
    debugPrint("🔑 request: ${request.toJson()}");
    return await repository.getConversations(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat History')),
      body: FutureBuilder<ConversationResponse>(
        future: _conversationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return _buildEmptyState();
          }

          final chatHistory = snapshot.data!.items;

          return ListView.builder(
            itemCount: chatHistory.length,
            itemBuilder: (context, index) {
              final chat = chatHistory[index];
              return _buildChatItem(context, chat);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/no_found.png", // 🛠️ nhớ khai báo trong pubspec.yaml
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          const Text(
            "No history found",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, Items chat) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(context); // 👉 update logic tùy theo nhu cầu
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chat.title ?? "Untitled",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                "${formatTimeAgo(chat.createAt ?? '')}",
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatTimeAgo(String isoTimeString) {
    final dateTime = DateTime.parse(isoTimeString);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Just now';
    }
  }
}
