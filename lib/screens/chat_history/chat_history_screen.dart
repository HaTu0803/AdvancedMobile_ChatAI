import 'package:flutter/material.dart';

import '../../model/history.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample chat history data
    final List<ChatItem> chatHistory = [
      ChatItem(
        title: "How to improve productivity",
        lastMessage: "Here are 5 tips to improve your daily productivity...",
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        model: "GPT-4",
      ),
      ChatItem(
        title: "Recipe for chocolate cake",
        lastMessage: "To make a delicious chocolate cake, you'll need the following ingredients...",
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        model: "Claude",
      ),
      ChatItem(
        title: "Writing a cover letter",
        lastMessage: "Here's a template for your job application cover letter...",
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        model: "GPT-4",
      ),
      ChatItem(
        title: "Learning Flutter development",
        lastMessage: "Flutter is a UI toolkit for building natively compiled applications...",
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        model: "Gemini",
      ),
      ChatItem(
        title: "Planning a trip to Japan",
        lastMessage: "For your 10-day trip to Japan, I recommend the following itinerary...",
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        model: "JARVIS",
      ),
    ];

    return Scaffold(
      body: ListView.builder(
        itemCount: chatHistory.length,
        itemBuilder: (context, index) {
          final chat = chatHistory[index];
          return _buildChatItem(context, chat);
        },
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, ChatItem chat) {
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
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      chat.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      chat.model,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                chat.lastMessage,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                _formatTimestamp(chat.timestamp),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}

