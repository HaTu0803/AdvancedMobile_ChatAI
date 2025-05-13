import 'package:advancedmobile_chatai/data_app/model/knowledge_base/assistant_model.dart';
import 'package:advancedmobile_chatai/providers/assistant_provider.dart';
import 'package:advancedmobile_chatai/providers/prompt_input.dart';
import 'package:advancedmobile_chatai/view_app/jarvis/screens/home/ai_agent.dart';
import 'package:advancedmobile_chatai/view_app/knowledge_base/screens/knowledge/bot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../widgets/action_button.dart';
import '../../../../../widgets/chat_message.dart';
import '../../../../../widgets/message_input.dart';
import '../../../../../widgets/sidebar.dart';
import '../../../../../widgets/typewriter_animated_text.dart';
import '../../../../data_app/model/jarvis/chat_model.dart';
import '../../../../data_app/repository/jarvis/ai_chat_repository.dart';
import '../chat_history/chat_history_screen.dart';
import '../create_bot/create_bot_screens.dart';
import '../prompt_library/prompt_library.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Map<String, dynamic>> messages = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  AiModel? selectedAiModel;
  AssistantResponse? _selectedAssistant;
  String? _conversationId;
  List<Map<String, dynamic>> _conversationMessages = [];

  @override
  void initState() {
    super.initState();
    selectedAiModel = AiModel(
      id: 'gpt-4o',
      name: 'GPT-4o',
      model: 'dify',
      isDefault: true,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Register send prompt after the first frame is drawn
      Provider.of<PromptInputProvider>(context, listen: false)
          .registerSendPrompt(_sendMessage);
    });
  }

  void _sendMessage(String message) async {
    if (message.isNotEmpty) {
      setState(() {
        messages.add({'text': message, 'isUser': true});
        _conversationMessages.add({'role': 'user', 'content': message});
        _messageController.clear();
      });
      _scrollToBottom();

      setState(() {
        messages.add({'text': '...', 'isUser': false, 'isLoading': true});
      });
      _scrollToBottom();

      List<ChatMessage> chatMessages = _conversationMessages.map((msg) {
        return ChatMessage(
          role: msg['role'],
          content: msg['content'],
          assistant: AssistantInfo(
            model: selectedAiModel?.model ?? 'dify',
            name: selectedAiModel?.name ?? 'GPT-4o',
            id: selectedAiModel?.id ?? 'gpt-4od',
          ),
        );
      }).toList();

      final chatRequest = ChatRequest(
        content: message,
        files: [],
        metadata: ChatMetadata(
          conversation: Conversation(
            id: _conversationId,
            messages: chatMessages,
          ),
        ),
        assistant: AssistantInfo(
          model: selectedAiModel?.model ?? 'dify',
          name: selectedAiModel?.name ?? 'GPT-4o',
          id: selectedAiModel?.id ?? 'gpt-4od',
        ),
      );

      try {
        final response = await AiChatRepository().chatWithBot(chatRequest);
        debugPrint("Bot response: [32m");

        if (_conversationId == null && response.conversationId != null) {
          setState(() {
            _conversationId = response.conversationId;
          });
        }

        setState(() {
          messages.removeLast();
          messages.add({'text': response.message, 'isUser': false});
          _conversationMessages
              .add({'role': 'bot', 'content': response.message});
        });
        _scrollToBottom();
      } catch (e) {
        debugPrint("Error sending message to bot: $e");
        setState(() {
          messages.removeLast();
          messages.add({
            'text': 'Sorry, I encountered an error. Please try again.',
            'isUser': false,
            'isError': true
          });
        });
        _scrollToBottom();
      }
    }
  }

  final List<String> prompts = [
    "Write a blog post about artificial intelligence",
    "Explain quantum computing to a 10-year-old",
    "Create a meal plan for the week",
    "Suggest 5 books on personal development",
    "Help me draft an email to my boss requesting time off"
  ];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _navigateToBotsScreen() async {
    final assistant = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BotsScreen(),
      ),
    );

    if (assistant != null) {
      setState(() {
        _selectedAssistant = assistant; // Cập nhật assistant đã chọn
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const AppSidebar(),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'JARVORA',
                        style:
                            Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          _scaffoldKey.currentState!.openEndDrawer();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    child: messages.isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Greeting
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.surface,
                                      radius: 20,
                                      child: const Icon(
                                        Icons.smart_toy_rounded,
                                        size: 24,
                                        color: Color(0xFF6C63FF),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Text(
                                        "Hi, I'm JARVORA, your personal assistant",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Prompts Section
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outline
                                        .withOpacity(0.3),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Prompts",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      height: 50,
                                      child: TypewriterAnimatedText(
                                        texts: prompts,
                                        typingSpeed: 150,
                                        pauseDuration:
                                            const Duration(seconds: 2),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                        children: [
                                          const TextSpan(
                                              text:
                                                  "Don't know what to say? Let's use "),
                                          WidgetSpan(
                                            alignment:
                                                PlaceholderAlignment.baseline,
                                            baseline: TextBaseline.alphabetic,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => const PromptLibraryScreen(),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                "Prompts!",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(8),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              return ChatBubble(
                                text: messages[index]["text"],
                                isUser: messages[index]["isUser"],
                              );
                            },
                          ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // ActionButton(
                        //   icon: const Icon(
                        //     Icons.smart_toy_outlined,
                        //   ),
                        //   // label: "AI Agents",
                        //   onTap: () {
                        //     AiModelDropdown();
                        //   },
                        // ),
                        AiModelDropdown(
                          onModelSelected: (selectedModel) {
                            setState(() {
                              selectedAiModel = selectedModel;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            _openCreateBotModal(context);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.smart_toy_outlined,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.add,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                size: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        ActionButton(
                          icon: const Icon(Icons.history_toggle_off),
                          label: "",
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatHistoryScreen(
                                  assistantModel:
                                      selectedAiModel?.model ?? 'dify',
                                ),
                              ),
                            );

                            if (result != null) {
                              setState(() {
                                // Clear existing messages
                                messages.clear();
                                _conversationMessages.clear();

                                // Set conversation ID
                                _conversationId = result['conversationId'];

                                // Add history messages
                                messages.addAll(result['messages']);

                                // Convert messages to conversation format
                                for (var msg in result['messages']) {
                                  _conversationMessages.add({
                                    'role': msg['isUser'] ? 'user' : 'bot',
                                    'content': msg['text'],
                                  });
                                }
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        ActionButton(
                          icon: Icon(Icons.add_circle_sharp,
                              color: Theme.of(context).colorScheme.primary),
                          label: "",
                          onTap: () {
                            // Clear messages and return to the initial state
                            setState(() {
                              messages.clear();
                              _conversationMessages.clear();
                              _conversationId = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Message Input
                MessageInputField(onSend: _sendMessage),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _openCreateBotModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width:
                  MediaQuery.of(context).size.width, // Full width of the screen
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Create Your Own Bot',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const CreateYourOwnBotScreen(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


}
