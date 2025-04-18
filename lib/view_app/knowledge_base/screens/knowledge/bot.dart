import 'package:advancedmobile_chatai/data_app/model/knowledge_base/assistant_model.dart';
import 'package:advancedmobile_chatai/data_app/repository/knowledge_base/assistant_repository.dart';
import 'package:flutter/material.dart';

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
                              icon: const Icon(Icons.star_border, size: 18),
                              tooltip: 'Favorite',
                              onPressed: () {},
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
                                    // TODO: handleEdit(assistant);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    // TODO: handleDelete(assistant);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward, size: 20, color: Colors.grey),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    // TODO: handleUse(assistant);
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

}

