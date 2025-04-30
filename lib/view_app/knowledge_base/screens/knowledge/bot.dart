import 'package:advancedmobile_chatai/data_app/model/knowledge_base/assistant_model.dart';
import 'package:advancedmobile_chatai/data_app/repository/knowledge_base/assistant_repository.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/dialog.dart';
import '../../../jarvis/screens/create_bot/create_bot_screens.dart';
import "edit_bot_screen.dart";

class BotsScreen extends StatefulWidget {
  const BotsScreen({super.key});

  @override
  State<BotsScreen> createState() => _BotsScreenState();
}

class _BotsScreenState extends State<BotsScreen> {
  String searchQuery = '';
  String _currentFilterKey = 'all';
  bool? _isFavorite;
  String? _order;
  String? _orderField;
  List<AssistantResponse> assistants = [];
  bool isLoading = false;

  Future<void> _fetchAssistants() async {
    setState(() => isLoading = true);

    final params = GetAssistants(
      q: searchQuery,
      order_field: _currentFilterKey == 'name'
          ? 'assistantName'
          : _currentFilterKey == 'date'
              ? 'createdAt'
              : null,
      order: _order,
      is_favorite: _isFavorite,
    );

    try {
      final response = await AssistantRepository().getAssistants(params);
      setState(() => assistants = response.data);
    } catch (e) {
      debugPrint('Error loading assistants: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _onSearchChanged(String value) {
    setState(() => searchQuery = value);
    _fetchAssistants();
  }

  void _onFilterChanged(String value) {
    setState(() {
      _currentFilterKey = value;
      switch (value) {
        case 'all':
          _isFavorite = null;
          _order = null;
          _orderField = null;
          break;
        case 'favorites':
          _isFavorite = true;
          _order = null;
          _orderField = null;
          break;
        case 'name':
          _isFavorite = null;
          _order = 'ASC';
          _orderField = 'assistantName';
          break;
        case 'date':
          _isFavorite = null;
          _order = 'DESC';
          _orderField = 'createdAt';
          break;
      }
    });

    _fetchAssistants(); // gọi lại API với filter mới
  }

  @override
  void initState() {
    super.initState();
    _fetchAssistants();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/no_found.png",
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          const Text(
            "No bots found",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Try adjusting your search or create a new bot",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Bots',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search bots...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.primary),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _currentFilterKey,
                            isExpanded: true,
                            icon: Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.primary),
                            items: const [
                              DropdownMenuItem(value: 'all', child: Text('All Bots')),
                              DropdownMenuItem(value: 'favorites', child: Text('Favorites')),
                              DropdownMenuItem(value: 'name', child: Text('Sort by Name')),
                              DropdownMenuItem(value: 'date', child: Text('Sort by Date')),
                            ],
                            onChanged: (value) {
                              if (value != null) _onFilterChanged(value);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
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
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  )
                : assistants.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: assistants.length,
                        itemBuilder: (context, index) {
                          final assistant = assistants[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => Navigator.pop(context, assistant.assistantName),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.primary.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.smart_toy,
                                              size: 24,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              assistant.assistantName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              assistant.isFavorite == true
                                                  ? Icons.star_rounded
                                                  : Icons.star_outline_rounded,
                                              color: assistant.isFavorite == true
                                                  ? Colors.amber
                                                  : Colors.grey,
                                              size: 24,
                                            ),
                                            onPressed: () => _handleFavoriteBot(assistant.id),
                                          ),
                                        ],
                                      ),
                                      if (assistant.description?.isNotEmpty == true) ...[
                                        const SizedBox(height: 8),
                                        Text(
                                          assistant.description!,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          _buildActionButton(
                                            icon: Icons.edit_outlined,
                                            onPressed: () => _openEditBotModal(context, assistant),
                                            theme: theme,
                                          ),
                                          const SizedBox(width: 8),
                                          _buildActionButton(
                                            icon: Icons.delete_outline,
                                            onPressed: () => _handleDeleteBot(
                                                assistant.id, assistant.assistantName),
                                            theme: theme,
                                          ),
                                          const SizedBox(width: 8),
                                          _buildActionButton(
                                            icon: Icons.chat_bubble_outline,
                                            onPressed: () {},
                                            theme: theme,
                                            isPrimary: true,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required ThemeData theme,
    bool isPrimary = false,
  }) {
    return Material(
      color: isPrimary ? theme.colorScheme.primary : Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 20,
            color: isPrimary ? Colors.white : Colors.grey[700],
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
                    CreateYourOwnBotScreen(
                      onSuccess: () {
                        _fetchAssistants();
                      },
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

  void _openEditBotModal(BuildContext context, AssistantResponse assistant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBotScreen(assistant: assistant),
      ),
    );
  }

  void _handleDeleteBot(String assistantId, String assistantName) {
    showCustomDialog(
      context: context,
      title: 'Delete Assistant',
      message:
          'Are you sure you want to delete the assistant titled "$assistantName"?',
      isConfirmation: true,
      confirmText: 'Yes, Delete',
      cancelText: 'Cancel',
      onConfirm: () async {
        try {
          await AssistantRepository().deleteAssistant(assistantId);

          setState(() {
            assistants.removeWhere((a) => a.id == assistantId);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Assistant deleted successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete assistant: $e')),
          );
        }
      },
    );
  }

  void _handleFavoriteBot(String assistantId) async {
    try {
      await AssistantRepository().favoriteAssistant(assistantId);
      setState(() {
        final index = assistants.indexWhere((a) => a.id == assistantId);
        if (index != -1) {
          // Toggle isFavorite state
          assistants[index] = assistants[index].copyWith(
            isFavorite: !(assistants[index].isFavorite ?? false),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to favorite assistant: $e')),
      );
    }
  }
}
