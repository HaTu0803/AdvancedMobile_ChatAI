import 'package:flutter/material.dart';

import '../../../data/datasource/mock_data.dart';

class MyPromptScreen extends StatefulWidget {
  const MyPromptScreen({super.key});

  @override
  State<MyPromptScreen> createState() => _MyPromptScreenState();
}

class _MyPromptScreenState extends State<MyPromptScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            child: Container(
              decoration: BoxDecoration(
                // color: const Color(0xFFF5F7FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ),
          ),

          // Prompt List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              itemCount: mockPrompts.length,
              itemBuilder: (context, index) {
                final prompt = mockPrompts[index];
                return _buildPromptItem(
                  prompt['name']!,
                  onEdit: () {},
                  onDelete: () {},
                  onUse: () {},
                );
              },
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                  children: [
                    const TextSpan(text: 'Find more prompts in '),
                    TextSpan(
                      text: 'Public Prompts',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    const TextSpan(text: '\nor '),
                    TextSpan(
                      text: 'Create your own prompt',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptItem(
      String title, {
        required VoidCallback onEdit,
        required VoidCallback onDelete,
        required VoidCallback onUse,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.grey),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onDelete,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward, size: 20, color: Colors.grey),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onUse,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
