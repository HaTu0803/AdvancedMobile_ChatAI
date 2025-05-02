import 'package:advancedmobile_chatai/data_app/repository/jarvis/ai_chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:advancedmobile_chatai/data_app/repository/jarvis/token_repository.dart';
import 'package:advancedmobile_chatai/data_app/model/jarvis/token_model.dart';

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
  
  // Add token related variables
  final TokenRepository _tokenRepository = TokenRepository();
  UsageTokenResponse? _tokenData;
  bool _isLoadingToken = false;
  String _tokenError = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChange);
    _fetchTokenData();
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

  Future<void> _fetchTokenData() async {
    setState(() {
      _isLoadingToken = true;
      _tokenError = '';
    });

    try {
      final response = await _tokenRepository.getUsage();
      setState(() {
        _tokenData = response;
        _isLoadingToken = false;
      });
      print('Token data fetched successfully: ${response.availableTokens}');
    } catch (e) {
      setState(() {
        _tokenError = e.toString();
        _isLoadingToken = false;
      });
      print('Error fetching token data: $e');
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
    final bool isOutOfTokens = _tokenData != null && _tokenData!.availableTokens <= 0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          margin: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isOutOfTokens 
                ? Theme.of(context).colorScheme.error.withOpacity(0.5)
                : Theme.of(context).primaryColor,
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
                          hintText: isOutOfTokens 
                            ? 'You have run out of tokens, please wait until tomorrow or upgrade your account to get more tokens.'
                            : 'Type a message... (Type / for prompts)',
                          hintStyle: TextStyle(
                            color: isOutOfTokens 
                              ? Theme.of(context).colorScheme.error
                              : Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                        ),
                        enabled: !isOutOfTokens,
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
                          onPressed: (_isComposing && !isOutOfTokens)
                              ? () => _handleSubmitted(_controller.text)
                              : null,
                          isActive: _isComposing && !isOutOfTokens,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Token display with real data
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_fire_department,
                size: 16,
                color: isOutOfTokens 
                  ? Theme.of(context).colorScheme.error
                  : (_tokenError.isNotEmpty ? Colors.red : Colors.grey.shade600),
              ),
              const SizedBox(width: 4),
              if (_isLoadingToken)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              else if (_tokenError.isNotEmpty)
                Text(
                  'Error loading tokens',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                )
              else
                Text(
                  '${_tokenData?.availableTokens ?? 0}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isOutOfTokens 
                      ? Theme.of(context).colorScheme.error
                      : Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ],
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
    if (_tokenData == null || _tokenData!.availableTokens <= 0) {
      // Show an elegant bottom sheet when out of tokens
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.token_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Out of tokens!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You have used all your tokens. Please wait until tomorrow or upgrade your account to get more tokens.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Got it'),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      );
      return;
    }

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

      // Update token count after successful response
      _fetchTokenData();
    } catch (e) {
      debugPrint("Error sending message to bot: $e");
    }
  }
}
