import 'dart:async';

import 'package:advancedmobile_chatai/data_app/repository/prompt_repository.dart';
import 'package:advancedmobile_chatai/view_app/jarvis/screens/prompt_library/create_prompt/create_prompt_screen.dart';
import 'package:flutter/material.dart';

import '../../../../../data_app/model/jarvis/prompt_model.dart';
import '../../../../../widgets/dialog.dart';

class MyPromptScreen extends StatefulWidget {
  const MyPromptScreen({super.key});

  @override
  State<MyPromptScreen> createState() => _MyPromptScreenState();
}

class _MyPromptScreenState extends State<MyPromptScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<PromptItemV2> _prompts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPrompts();

    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        final query = _searchController.text.trim();
        if (query.isEmpty || query.length >= 2) {
          _fetchPrompts(query: query);
        }
      });
    });
  }

  Future<void> _fetchPrompts({String query = ""}) async {
    setState(() => _isLoading = true);

    final params = GetPromptRequest(
      query: query,
      limit: 100,
      isPublic: false,
    );

    try {
      final response = await PromptRepository().getPrompt(params);
      setState(() => _prompts = response.items);
      debugPrint("Fetched prompts: ${_prompts}");
    } catch (e) {
      debugPrint('Failed to fetch prompts: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _openPromptDialog({PromptItemV2? promptToEdit}) {
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
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
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
                          'Edit Prompt',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineMedium,
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
                    CreatePromptScreen(
                        promptToEdit: promptToEdit,
                        onSubmitSuccess: _fetchPrompts,
                      // Pass the prompt to edit here
                      // promptToEdit: promptToEdit,
                    ),
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
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ),
          ),

          // Prompt List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _prompts.isEmpty
                    ? const Center(child: Text("No prompts found"))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 8.0),
                        itemCount: _prompts.length,
                        itemBuilder: (context, index) {
                          // Cast the prompt to PromptItemV2
                          final prompt = _prompts[index] as PromptItemV2;

                          return _buildPromptItem(
                            prompt, // Pass the whole PromptItemV2 object
                            onEdit:   () => _openPromptDialog(
                              promptToEdit: prompt,
                            ),
                            onDelete: () => _handleDeletePrompt(
                                prompt), // Pass the whole PromptItemV2 object
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

  Future<void> _handleDeletePrompt(PromptItemV2 prompt) async {
    showCustomDialog(
      context: context,
      title: 'Delete Prompt',
      message:
          'Are you sure you want to delete the prompt titled "${prompt.title}"?',
      isConfirmation: true,
      confirmText: 'Yes, Delete',
      cancelText: 'Cancel',
      onConfirm: () async {
        await _deletePrompt(prompt.id);
      },
    );
  }

  Future<void> _deletePrompt(String promptId) async {
    setState(() => _isLoading = true);

    try {
      final response = await PromptRepository().deletePrompt(promptId);

      if (response.acknowledged && response.deletedCount > 0) {
        setState(() {
          _prompts.removeWhere((prompt) => prompt.id == promptId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prompt deleted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete the prompt.')),
        );
      }
    } catch (e) {
      debugPrint('Error deleting prompt: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Failed to delete the prompt.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildPromptItem(
    PromptItemV2 prompt, {
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
              prompt.title, // Access the title from PromptItemV2
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined,
                    size: 20, color: Colors.grey),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    size: 20, color: Colors.grey),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onDelete,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward,
                    size: 20, color: Colors.grey),
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
