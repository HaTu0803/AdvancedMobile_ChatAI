import 'package:advancedmobile_chatai/data_app/model/base/base_model.dart';
import 'package:advancedmobile_chatai/data_app/model/knowledge_base/knowledge_model.dart';
import 'package:advancedmobile_chatai/data_app/repository/knowledge_base/knowledge_repository.dart';
import 'package:advancedmobile_chatai/view_app/knowledge_base/screens/knowledge/knowledge_base/create_knowledge.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/dialog.dart';
import '../../widgets/get_knowledge.dart';
import 'units.dart';

class KnowledgeBaseScreen extends StatefulWidget {
  const KnowledgeBaseScreen({super.key});

  @override
  State<KnowledgeBaseScreen> createState() => _KnowledgeBaseScreenState();
}

class _KnowledgeBaseScreenState extends State<KnowledgeBaseScreen> {
  String searchQuery = '';
  String _currentFilterKey = 'all';
  String? _order;
  String? _orderField;
  List<KnowledgeResponse> knowledges = [];
  bool isLoading = false;

  Future<void> _fetchKnowledge() async {
    setState(() => isLoading = true);

    final params = BaseQueryParams(
      q: searchQuery,
      limit: 50,
    );

    try {
      final response = await KnowledgeRepository().getKnowledges(params);
      setState(() => knowledges = response.data);
    } catch (e) {
      debugPrint('Error loading knowledges: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _onSearchChanged(String value) {
    setState(() => searchQuery = value);
    _fetchKnowledge();
  }

  @override
  void initState() {
    super.initState();
    _fetchKnowledge();
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
    // final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Knowledge Base",
          style:  Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: IconButton(
              icon: Icon(
                Icons.add_box,
                size: 30,
                color:  Theme.of(context).primaryColor,
              ),
              onPressed: () {
                _openCreateKnowledgeModal(context);
              },
            ),
          ),
        ],
      ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: Container(
                height: 42,
                child: TextField(
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search Knowledge Base',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color:  Theme.of(context).colorScheme.primary),
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
                      borderSide: BorderSide(color:  Theme.of(context).colorScheme.primary),
                    ),
                    filled: true,
                    fillColor:  Theme.of(context).colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),


          Expanded(
            child: knowledges.isEmpty && isLoading
                ? const Center(child: CircularProgressIndicator())
                : knowledges.isEmpty
                    ? _buildEmptyState() // Hiển thị empty state nếu không có knowledges
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 8.0),
                        itemCount: knowledges.length,
                        itemBuilder: (context, index) {
                          final knowledge = knowledges[index];

                          return
                            ListWidget(
                              model: knowledge,
                              showContent: true,
                              showIconActions: true,
                              onPressed: () {
                                _showKnowledgeDetailBottomSheet(
                                    context,
                                    knowledge.id,
                                    knowledge.knowledgeName);
                              },
                              iconActions: [
                                // IconAction(
                                //   icon: Icons.edit_outlined,
                                //   onPressed: () {
                                //     // _openEditBotModal(context, knowledge);
                                //   },
                                // ),
                                IconAction(
                                  icon: Icons.delete_outline,
                                  onPressed: () {
                                    _handleDeleteKnowledge(
                                        knowledge.id, knowledge.knowledgeName);
                                  },
                                ),
                                IconAction(
                                  icon: Icons.arrow_forward,
                                  onPressed: () {
                                    _showKnowledgeDetailBottomSheet(
                                        context,
                                        knowledge.id,
                                        knowledge.knowledgeName);
                                  },
                                ),
                              ],
                            );

                        }),
          ),
        ],
      ),
    );
  }

  void _openCreateKnowledgeModal(BuildContext context) {
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
                          'Create a Knowledge Base',
                          style: Theme.of(context).textTheme.headlineSmall,
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
                    CreateAKnowledgeBaseScreen(
                      onSuccess: () {
                        _fetchKnowledge();
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

  // void _openEditBotModal(BuildContext context, AssistantResponse assistant) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Center(
  //         child: Dialog(
  //           insetPadding: EdgeInsets.zero,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           child: Container(
  //             width: MediaQuery.of(context).size.width,
  //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(
  //                         'Edit Your Bot',
  //                         style: Theme.of(context).textTheme.headlineMedium,
  //                       ),
  //                       IconButton(
  //                         icon: const Icon(Icons.close),
  //                         onPressed: () {
  //                           Navigator.pop(context);
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 16),
  //                   CreateYourOwnBotScreen(
  //                     isUpdate: true,
  //                     assistantId: assistant.id,
  //                     onSuccess: () {
  //                       _fetchKnowledge();
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void _handleDeleteKnowledge(String id, String knowledgeName) {
    showCustomDialog(
      context: context,
      title: 'Delete Knowledge Base',
      message: Text.rich(
        TextSpan(
          children: [
            const TextSpan(
              text: 'Are you sure you want to delete the assistant Name ',
            ),
            TextSpan(
              text: '$knowledgeName',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red, 
              ),
            ),
            const TextSpan(text: '?'),
          ],
        ),
        textAlign: TextAlign.left,
      ),
      isConfirmation: true,
      confirmText: 'Yes, Delete',
      cancelText: 'Cancel',
      onConfirm: () async {
        try {
          await KnowledgeRepository().deleteKnowledge(id);

          setState(() {
            knowledges.removeWhere((a) => a.id == id);
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

  // void _handleFavoriteBot(String assistantId) async {
  //   try {
  //     await AssistantRepository().favoriteAssistant(assistantId);
  //     setState(() {
  //       final index = knowledges.indexWhere((a) => a.id == assistantId);
  //       if (index != -1) {
  //         // Toggle isFavorite state
  //         knowledges[index] = knowledges[index].copyWith(
  //           isFavorite: !(knowledges[index].isFavorite ?? false),
  //         );
  //       }
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to favorite assistant: $e')),
  //     );
  //   }
  // }
}

void _showKnowledgeDetailBottomSheet(
    BuildContext context, String id, String knowledgeName) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9, // Chiếm 90% màn hình
        minChildSize: 0.5,
        maxChildSize: 1.0,
        builder: (_, controller) =>
            KnowledgeUnitScreen(id: id, knowledgeName: knowledgeName)),
  );
}
