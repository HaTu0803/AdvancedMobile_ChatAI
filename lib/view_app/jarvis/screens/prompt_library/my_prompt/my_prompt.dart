import 'dart:async';

import 'package:advancedmobile_chatai/core/util/themes/colors.dart';
import 'package:advancedmobile_chatai/data_app/repository/jarvis/prompt_repository.dart';
import 'package:advancedmobile_chatai/view_app/jarvis/screens/prompt_library/create_prompt/create_prompt_screen.dart';
import 'package:advancedmobile_chatai/view_app/jarvis/widgets/using_my_prompt.dart';
import 'package:flutter/material.dart';

import '../../../../../data_app/model/jarvis/prompt_model.dart';
import '../../../../../widgets/dialog.dart';
import '../../../widgets/button_action.dart';

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
  bool _hasMore = true;
  int _offset = 0;
  final int _limit = 10;
  String _currentQuery = "";
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _fetchPrompts();

    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        final query = _searchController.text.trim();
        if (query.isEmpty || query.length >= 2) {
          _resetAndFetch(query);
        }
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _fetchPrompts(query: _currentQuery);
      }
    });
  }

  void _resetAndFetch(String query) {
    setState(() {
      _offset = 0;
      _prompts.clear();
      _hasMore = true;
      _currentQuery = query;
    });
    _fetchPrompts(query: query);
  }

  Future<void> _fetchPrompts({String query = ""}) async {
    if (!_hasMore || _isLoading) return;

    setState(() => _isLoading = true);

    final params = GetPromptRequest(
      query: query,
      offset: _offset,
      limit: _limit,
      isPublic: false,
    );

    try {
      final response = await PromptRepository().getPrompt(params);
      final newItems = response.items;

      setState(() {
        _prompts.addAll(newItems);
        _offset += _limit;
        _hasMore = response.hasNext;
      });
    } catch (e) {
      debugPrint('Failed to fetch prompts: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/no_found.png",
            width: 300,
            height: 300,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          const Text(
            "No found",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 8),
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
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    CreatePromptScreen(
                      promptToEdit: promptToEdit,
                      onSubmitSuccess: () => _resetAndFetch(_currentQuery),
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
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 42,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search prompts...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon:
                        Icon(Icons.search, color: theme.colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.colorScheme.primary),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          // Prompt List
          Expanded(
            child: _prompts.isEmpty && _isLoading
                ? const Center(child: CircularProgressIndicator())
                  : _prompts.isEmpty
                    ? _buildEmptyState() 
                : ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 4.0),
                    itemCount: _prompts.length + (_hasMore ? 1 : 0),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      if (index >= _prompts.length) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final prompt = _prompts[index];
                      return ButtonAction(
                        onPressed: () => _showUsingMyPrompt(prompt),
                        model: prompt,
                        iconActions: [
                          IconAction(
                            icon: Icons.edit_outlined,
                            onPressed: () =>
                                _openPromptDialog(promptToEdit: prompt),
                          ),
                          IconAction(
                            icon: Icons.delete_outlined,
                            onPressed: () => _handleDeletePrompt(prompt),
                          ),
                          IconAction(
                            icon: Icons.arrow_forward,
                            onPressed: () => _showUsingMyPrompt(prompt),
                          ),
                        ],
                        showIconActions: true,
                        showContent: false,
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textGray,
                      ),
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

  void _showUsingMyPrompt(PromptItemV2 prompt) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        isScrollControlled: true,
        builder: (context) => UsingMyPrompt(prompt: prompt),
      );
    });
  }

  Future<void> _handleDeletePrompt(PromptItemV2 prompt) async {
    showCustomDialog(
      context: context,
      title: 'Delete Prompt',
      message: Text.rich(
        TextSpan(
          children: [
            const TextSpan(
                text: 'Are you sure you want to delete the prompt titled '),
            TextSpan(
              text: '"${prompt.title}"',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: '?'),
          ],
        ),
      ),
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
}
