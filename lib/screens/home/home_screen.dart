import 'package:flutter/material.dart';
import '../../widgets/typewriter_animated_text.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/message_input.dart';
import '../create_prompts/create_prompt_screen.dart';
import '../chat_history/chat_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // List of example prompts
  final List<String> prompts = [
    "Write a blog post about artificial intelligence",
    "Explain quantum computing to a 10-year-old",
    "Create a meal plan for the week",
    "Suggest 5 books on personal development",
    "Help me draft an email to my boss requesting time off"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.background,
      endDrawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'JARVIS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
            
            // Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            child: Icon(
                              Icons.smart_toy_rounded,
                              size: 24,
                              color: Color(0xFF6C63FF),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
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
                        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
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
                                const TextSpan(
                                  text: "Don't know what to say? Let's use ",
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const CreatePromptScreen(),
                                        ),
                                      );
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
                    
                    const Spacer(),
                    
                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ActionButton(
                              icon: Icons.smart_toy_outlined,
                              label: "AI Agents",
                              onTap: () {
                                _showAIModelsBottomSheet(context);
                              },
                            ),
                            const SizedBox(width: 8),
                            ActionButton(
                              icon: Icons.add_circle_outline,
                              label: "Create Bots",
                              onTap: () {
                                // Navigate to create bots screen
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            ActionButton(
                              icon: Icons.history,
                              label: "",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ChatHistoryScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            ActionButton(
                              icon: Icons.add,
                              label: "",
                              onTap: () {
                                // Clear current chat and start new
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Message Input
                    const MessageInputField(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showAIModelsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Fixed Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Text(
                      "Select AI Model",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Scrollable Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    children: [
                      _buildModelOption("GPT-4", "Most capable model for complex tasks", true),
                      _buildModelOption("Claude", "Balanced between performance and speed", false),
                      _buildModelOption("Gemini", "Google's multimodal AI model", false),
                      _buildModelOption("JARVIS", "Custom-trained assistant", false),
                      _buildModelOption("GPT-3.5", "Fast and efficient for most tasks", false),
                      _buildModelOption("Llama", "Open source AI model", false),
                      _buildModelOption("Anthropic Claude 2", "Advanced reasoning capabilities", false),
                      _buildModelOption("PaLM", "Google's language model", false),
                    ],
                  ),
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
        color: isSelected ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
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
        trailing: isSelected ? Icon(
          Icons.check_circle,
          color: Theme.of(context).colorScheme.primary,
        ) : null,
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

