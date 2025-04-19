import 'package:advancedmobile_chatai/data_app/model/knowledge_base/assistant_model.dart';
import 'package:advancedmobile_chatai/data_app/repository/knowledge_base/assistant_repository.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/dialog.dart';
import '../../../jarvis/screens/create_bot/create_bot_screens.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bots',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dòng search
                TextField(
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search bots...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 12),
                // Dòng dropdown chiếm 1/3
                Row(
                  children: [
                    // Dropdown with width wrapping longest text
                    IntrinsicWidth(
                      child: DropdownButtonFormField<String>(
                        value: _currentFilterKey,
                        isExpanded: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          isDense: true,
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onChanged: (value) {
                          if (value != null) _onFilterChanged(value);
                        },
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All Bots')),
                          DropdownMenuItem(value: 'favorites', child: Text('Favorites')),
                          DropdownMenuItem(value: 'name', child: Text('Sort by Name')),
                          DropdownMenuItem(value: 'date', child: Text('Sort by Date')),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Icon-only button
                    const Spacer(),
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
                )

              ],
            ),
          ),
          Expanded(

            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : assistants.isEmpty
                    ? _buildEmptyState() // Hiển thị empty state nếu không có assistants
                    : ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 4.0, vertical: 8.0),


              itemCount: assistants.length,
                itemBuilder: (context, index) {
                  final assistant = assistants[index];

                  return Container(
                    margin: const EdgeInsets.all(8),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.smart_toy, size: 20, color: Colors.blue),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                assistant.assistantName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                assistant.isFavorite == true ? Icons.star : Icons.star_border,
                                color: assistant.isFavorite == true ? Colors.amber : Colors.grey,
                                size: 20,
                              ),
                              tooltip: 'Favorite',
                              onPressed: () {
                                _handleFavoriteBot(assistant.id);
                              },
                            ),

                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                assistant.description?.isNotEmpty == true
                                    ? assistant.description!
                                    : 'No description available',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.grey),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    _openEditBotModal(context, assistant);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    _handleDeleteBot(assistant.id, assistant.assistantName);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward, size: 20, color: Colors.grey),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {

                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );


                }


            )
            ,
          ),
        ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Your Bot',
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
                      isUpdate: true,
                      assistantId: assistant.id,
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
  void _handleDeleteBot(String assistantId, String assistantName) {
    showCustomDialog(
      context: context,
      title: 'Delete Assistant',
      message: 'Are you sure you want to delete the assistant titled "$assistantName"?',
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

