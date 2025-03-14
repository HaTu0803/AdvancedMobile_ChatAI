import 'package:flutter/material.dart';
import '../../data/datasource/mock_data.dart';
import '../../util/themes/colors.dart';
import '../../widgets/action_button.dart';
import '../../widgets/chat_message.dart';
import '../../widgets/typewriter_animated_text.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/message_input.dart';
import '../create_bot/create_bot_screens.dart';
import '../chat_history/chat_history_screen.dart';
import '../prompt_library/create_prompt/create_prompt_screen.dart';
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

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      setState(() {
        messages.add({'text': message, 'isUser': true});
        _messageController.clear();
      });
      _scrollToBottom();
    }
  }

  // List of example prompts
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
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'JARVIS',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
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
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: messages.isEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.surface,
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
                              "Hi, I'm JARVIS, your personal assistant",
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
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
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
                              pauseDuration: const Duration(seconds: 2),
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              children: [
                                const TextSpan(text: "Don't know what to say? Let's use "),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: GestureDetector(
                                    onTap: () {
                                      _showFullPromptModal(context);
                                    },
                                    child: Text(
                                      "Prompts!",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
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
                    ActionButton(
                      icon: Icon(
                        Icons.smart_toy_outlined,
                      ),
                      label: "AI Agents",
                      onTap: () {
                        _showAIModelsBottomSheet(context);
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
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
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.add,
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
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
                      // iconConfigs: [
                      //   IconConfig(icon: Icons.history_toggle_off),
                      // ],
                      icon: const Icon(Icons.history_toggle_off),
                      label: "",
                      onTap: () {
                        _showFullHistoryModal(context);
                      },
                    ),
                    const SizedBox(width: 8),
                    ActionButton(
                      // iconConfigs: [
                      //   IconConfig(icon: Icons.add_circle_sharp, color: Theme.of(context).colorScheme.primary),
                      // ],
                      icon: Icon(Icons.add_circle_sharp,
                          color: Theme.of(context).colorScheme.primary),
                      label: "",
                      onTap: () {
                        // Clear current chat and start new
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

    );
  }

  void _showFullPromptModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 1, // Almost full screen
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const PromptLibraryScreen(),
        );
      },
    );
  }

  void _showFullHistoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Chat History",
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
              ),
              const Expanded(
                child: ChatHistoryScreen(),
              ),
            ],
          ),
        );
      },
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

  void _showAIModelsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height *
              0.8, // 80% of the screen height
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "AI Models",
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
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: aiModels.map((model) {
                    return _buildModelOption(
                      model["name"],
                      model["description"],
                      model["isSelected"],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModelOption(String name, String description, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.grey.shade100,
          child: Text(
            name[0],
            style: TextStyle(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade600,
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            description,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
