import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/themes/colors.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final String? avatarUrl;

  const ChatBubble({
    required this.text,
    required this.isUser,
    this.avatarUrl,
    super.key,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đã sao chép tin nhắn!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isUser)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  radius: 20,
                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                  child: avatarUrl == null
                      ? const Icon(Icons.smart_toy_rounded, size: 24, color: Colors.white)
                      : null,
                ),
              ),

            Flexible(
              child: Column(
                crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(top: 4, bottom: 4),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * (6 / 7),
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppColors.primaryLightActive
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      text,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: isUser ? Colors.black87 : Colors.black87,
                      ),
                    ),
                  ),

                  if (!isUser)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20),
                          onPressed: () => _copyToClipboard(context),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, size: 20),
                          onPressed: () {
                            print("Reload message");
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
