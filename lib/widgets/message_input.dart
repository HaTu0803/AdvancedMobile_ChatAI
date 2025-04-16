import 'package:advancedmobile_chatai/data_app/repository/jarvis/ai_chat_repository.dart';
import 'package:flutter/material.dart';

import '../core/util/themes/colors.dart';
import '../data_app/model/jarvis/chat_model.dart';
import '../data_app/model/jarvis/prompt_model.dart';
import '../data_app/repository/jarvis/prompt_repository.dart';
import '../view_app/jarvis/screens/prompt_library/prompt_library.dart';

class MessageInputField extends StatefulWidget {
  final Function(String) onSend;

  const MessageInputField({Key? key, required this.onSend}) : super(key: key);

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final TextEditingController _controller = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  bool _isComposing = false;
  bool _showSuggestions = false;
  OverlayEntry? _overlayEntry;
  List<PromptItemV2> _suggestions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _hideOverlay();
    _controller.removeListener(_handleTextChange);
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    final text = _controller.text;
    setState(() {
      _isComposing = text.isNotEmpty;
    });

    if (text.endsWith('/')) {
      _showOverlay();
      _fetchPrompts();
    } else if (_showSuggestions && !text.contains('/')) {
      _hideOverlay();
    }
  }

  Future<void> _fetchPrompts() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch both public and private prompts
      final publicPrompts = await PromptRepository().getPrompt(
        GetPromptRequest(isPublic: true, limit: 50),
      );
      final privatePrompts = await PromptRepository().getPrompt(
        GetPromptRequest(isPublic: false, limit: 50),
      );

      setState(() {
        _suggestions = [...publicPrompts.items, ...privatePrompts.items];
        _updateOverlay();
      });
    } catch (e) {
      debugPrint('Error fetching prompts: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showOverlay() {
    _hideOverlay();

    _showSuggestions = true;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _showSuggestions = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _selectPrompt(PromptItemV2 prompt) {
    _controller.text = prompt.content;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
    _hideOverlay();
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy - 200, // Position above the input field
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, -200),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints:
                  const BoxConstraints(maxHeight: 200), // Show ~4 items
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final prompt = _suggestions[index];
                        return ListTile(
                          title: Text(
                            prompt.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            prompt.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => _selectPrompt(prompt),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
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
                child: CompositedTransformTarget(
                  link: _layerLink,
                  child: TextField(
                    controller: _controller,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Type a message... (Type / for prompts)',
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
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    onChanged: (text) {
                      setState(() {
                        _isComposing = text.isNotEmpty;
                      });
                    },
                    onSubmitted: _isComposing ? _handleSubmitted : null,
                  ),
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
                          builder: (context) => const PromptLibraryScreen(),
                        ),
                      );
                    }),
                    _buildActionButton(Icons.attach_file_outlined,
                        onPressed: () {}),
                    _buildActionButton(
                      Icons.arrow_upward,
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_controller.text)
                          : null,
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

  void _handleSubmitted(String text) async {
    widget.onSend(text);
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
    _hideOverlay();

    // Create the request body for the API
    final chatRequest = ChatRequest(
      content: text,
      files: [],
      metadata: ChatMetadata(
        conversation: Conversation(messages: []),
      ),
      assistant: AssistantInfo(
        model: "knowledge-base",
        name: "votutrinh2002's Default Team Assistant",
        id: "29178123-34d4-4e52-94fb-8e580face2d5",
      ),
    );

    try {
      // Send the message to the bot using the chat API
      final response = await AiChatRepository().chatWithBot(chatRequest);
      debugPrint("Bot response: ${response.message}");

      // Handle bot response (you can display it in your UI)
    } catch (e) {
      debugPrint("Error sending message to bot: $e");
    }
  }
}
