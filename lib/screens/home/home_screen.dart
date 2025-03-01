import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/create_prompt_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Sample prompts that will be displayed in the typewriter animation
  final List<String> _prompts = [
    "writing an email",
    "creating a story",
    "answering questions",
    "summarizing text",
    "generating ideas",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // New chat button functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Starting new chat')),
              );
            },
          ),
        ],
      ),
      drawer: const SidebarDrawer(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greetings section
                  Text(
                    "Hello, I'm JARVIS, your personal assistant",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  
                  // Prompts with TypewriterAnimatedText
                  Row(
                    children: [
                      Text(
                        "I can help you with ",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      Expanded(
                        child: AnimatedTextKit(
                          animatedTexts: _prompts.map((prompt) => TypewriterAnimatedText(
                            prompt,
                            speed: const Duration(milliseconds: 150),
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [
                                    Color(0xFF52A8F2), // Light Blue
                                    Color(0xFF6C5CE7), // Blue-Violet
                                    Color(0xFF9B26B6), // Purple
                                  ],
                                ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                            ),
                          )).toList(),
                          totalRepeatCount: 1000,
                          pause: const Duration(seconds: 2),
                          displayFullTextOnTap: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  
                  // Prompt suggestion text
                  Wrap(
                    children: [
                      Text(
                        "Don't know what to say? Let's use ",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (context) => const CreatePromptDialog(),
                          );
                          if (result != null) {
                            // Handle the created prompt
                            print('Created prompt: ${result['name']} - ${result['prompt']}');
                            // You can add more logic here to use the created prompt
                          }
                        },
                        child: Text(
                          "Prompts!",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Chat messages would go here
                  SizedBox(height: 40.h),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 80.w,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "Your conversation with JARVIS will appear here",
                          style: TextStyle(
                            color: Colors.grey.withOpacity(0.8),
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Message input field and send button
          Container(
  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 5,
        offset: const Offset(0, -1),
      ),
    ],
  ),
  child: Row(
    children: [
      // Attachment button
      IconButton(
        icon: const Icon(Icons.attach_file),
        onPressed: () {
          // Show attachment options
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text('Image'),
                    onTap: () {
                      // Handle image attachment
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.file_present),
                    title: const Text('Document'),
                    onTap: () {
                      // Handle document attachment
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      SizedBox(width: 8.w),
      Expanded(
        child: TextField(
          controller: _messageController,
          decoration: InputDecoration(
            hintText: 'Type a message...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.r)),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
          maxLines: null,
        ),
      ),
      SizedBox(width: 8.w),
      IconButton(
        icon: const Icon(Icons.send),
        onPressed: () {
          if (_messageController.text.isNotEmpty) {
            // Send message functionality
            _messageController.clear();
          }
        },
      ),
    ],
  ),
),
          
          // Tokens left indicator
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.token, size: 16.w),
                SizedBox(width: 4.w),
                Text(
                  "Tokens left: 1000",
                  style: TextStyle(fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}