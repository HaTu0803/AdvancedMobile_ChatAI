import 'package:flutter/material.dart';

class MessageInputField extends StatefulWidget {
  const MessageInputField({super.key});

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
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIconButton(
            Icons.attach_file_rounded,
            onPressed: () {
              // Implement file attachment
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Message JARVIS...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 15,
                  height: 1.4,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                isDense: true,
              ),
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
              textAlignVertical: TextAlignVertical.center,
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: _isComposing ? _handleSubmitted : null,
            ),
          ),
          const SizedBox(width: 8),
          _buildIconButton(
            Icons.send_rounded,
            onPressed: _isComposing ? () => _handleSubmitted(_controller.text) : null,
            isActive: _isComposing,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {
    required VoidCallback? onPressed,
    bool isActive = false,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 20,
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade600,
        ),
        padding: EdgeInsets.zero,
        splashRadius: 18,
        onPressed: onPressed,
      ),
    );
  }

  void _handleSubmitted(String text) {
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }
}

