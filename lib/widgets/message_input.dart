import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/prompt_library/prompt_library.dart';
import '../util/themes/colors.dart';

class MessageInputField extends StatefulWidget {
  final Function(String) onSend;

  const MessageInputField({super.key, required this.onSend});

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _isComposing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      margin: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _isComposing = text.isNotEmpty;
                    });
                  },
                  onSubmitted: _isComposing ? _handleSubmitted : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionButton(Icons.terminal_outlined, onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PromptLibraryScreen(),
                        ),
                      );
                    }),
                    _buildActionButton(Icons.attach_file_outlined, onPressed: () {}),
                    _buildActionButton(
                      Icons.arrow_upward,
                      onPressed: _isComposing ? () => _handleSubmitted(_controller.text) : null,
                      isActive: _isComposing,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, {
        required VoidCallback? onPressed,
        bool isActive = false,
      }) {
    return IconButton(
      icon: Icon(
        icon,
        size: 20,
        color: isActive ? Theme.of(context).primaryColor : AppColors.textGray,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 32,
        minHeight: 32,
      ),
      splashRadius: 16,
      onPressed: onPressed,
    );
  }

  void _handleSubmitted(String text) {
    widget.onSend(text);
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }
}
