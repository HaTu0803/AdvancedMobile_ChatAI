import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample chat history data
    final List<Map<String, dynamic>> chatHistory = [
      {
        'title': 'How to make a chocolate cake',
        'snippet': 'I need a recipe for a chocolate cake...',
        'date': DateTime.now().subtract(const Duration(hours: 2)),
        'messages': 12,
      },
      {
        'title': 'Writing a cover letter',
        'snippet': 'Can you help me write a cover letter for...',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'messages': 8,
      },
      {
        'title': 'Planning a trip to Japan',
        'snippet': 'I want to plan a 10-day trip to Japan...',
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'messages': 24,
      },
      {
        'title': 'Learning Flutter development',
        'snippet': 'What are the best resources to learn Flutter...',
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'messages': 15,
      },
      {
        'title': 'Book recommendations',
        'snippet': 'Can you recommend some science fiction books...',
        'date': DateTime.now().subtract(const Duration(days: 7)),
        'messages': 6,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
        ],
      ),
      body: chatHistory.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No chat history yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: chatHistory.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final chat = chatHistory[index];
                return ListTile(
                  title: Text(
                    chat['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        chat['snippet'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.message,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${chat['messages']} messages',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(chat['date']),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'rename',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Rename'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      // Handle menu item selection
                    },
                  ),
                  onTap: () {
                    // Navigate to the chat
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Start new chat
          Navigator.pop(context); // Go back to home screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day && date.month == now.month && date.year == now.year) {
      return 'Today, ${DateFormat.jm().format(date)}';
    } else if (date.day == now.day - 1 && date.month == now.month && date.year == now.year) {
      return 'Yesterday, ${DateFormat.jm().format(date)}';
    } else {
      return DateFormat.MMMd().format(date);
    }
  }
}

