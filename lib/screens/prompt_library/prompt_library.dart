import 'package:advancedmobile_chatai/screens/prompt_library/public_prompt/public_prompt.dart';
import 'package:flutter/material.dart';
import 'create_prompt/create_prompt_screen.dart';
import 'my_prompt/my_prompt.dart';

class PromptLibraryScreen extends StatefulWidget {
  const PromptLibraryScreen({super.key});

  @override
  State<PromptLibraryScreen> createState() => _PromptLibraryScreenState();
}

class _PromptLibraryScreenState extends State<PromptLibraryScreen> {
  final List<String> _tabs = ['Public Prompts', 'My Prompts'];
  String _selectedTab = 'Public Prompts';

  void _selectTab(String tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  void _showAddPromptModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 1,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const CreatePromptScreen(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Prompt Library',
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  ..._tabs.map((tab) {
                    final isSelected = tab == _selectedTab;
                    return Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: InkWell(
                        onTap: () => _selectTab(tab),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Theme.of(context).primaryColor : const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tab,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.add_box, size: 30, color: Theme.of(context).primaryColor),
                    onPressed: () {
                      _showAddPromptModal(context);
                    },
                  ),
                ],
              ),
            ),

            // Tab View
            Expanded(
              child: _selectedTab == 'Public Prompts'
                  ? const PublicPromptsScreen()
                  : const MyPromptScreen(),
            ),
          ],
        ),
      ),
    );
  }
}