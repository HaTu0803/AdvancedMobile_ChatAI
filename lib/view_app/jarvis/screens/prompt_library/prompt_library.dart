import 'package:advancedmobile_chatai/view_app/jarvis/screens/prompt_library/public_prompt/public_prompt.dart';
import 'package:flutter/material.dart';

import '../../../../core/util/themes/colors.dart';
import 'create_prompt/create_prompt_screen.dart';
import 'my_prompt/my_prompt.dart';

class PromptLibraryScreen extends StatefulWidget {
  final String? selectedTab; // Có thể nhận null

  const PromptLibraryScreen({super.key, this.selectedTab});

  @override
  State<PromptLibraryScreen> createState() => _PromptLibraryScreenState();
}

class _PromptLibraryScreenState extends State<PromptLibraryScreen> {
  late String _selectedTab;
  final List<String> _tabs = ['Public Prompts', 'My Prompts'];
  @override
  void initState() {
    super.initState();
    _selectedTab = widget.selectedTab ?? 'Public Prompts';
  }

  void _reloadCurrentTab() {
    setState(() {
    });
  }

  void _selectTab(String tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  void _openCreatePromptModal(BuildContext context) {
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
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Modal Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Create Prompt',
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
                    CreatePromptScreen(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SafeArea(
    child: Scaffold(
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

            // Tab Selector + Add Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  // Phần Tabs
                  Expanded(
                    child: Row(
                      children: _tabs.map((tab) {
                        final isSelected = tab == _selectedTab;
                        return Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: InkWell(
                            onTap: () => _selectTab(tab),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : AppColors.categoryGrey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tab,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: IconButton(
                      icon: Icon(
                        Icons.add_box,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        _openCreatePromptModal(context);
                      },
                    ),
                  ),
                ],
              ),
            ),


            // Tab Content
            Expanded(
              child: _selectedTab == 'Public Prompts'
                  ? const PublicPromptsScreen()
                  : const MyPromptScreen(),
            ),
          ],
        ),
      ),
    ),
      ),
    );
  }
}
