import 'package:advancedmobile_chatai/data_app/model/base/base_model.dart';
import 'package:advancedmobile_chatai/data_app/model/knowledge_base/knowledge_model.dart';
import 'package:advancedmobile_chatai/data_app/repository/knowledge_base/knowledge_repository.dart';
import 'package:advancedmobile_chatai/view_app/knowledge_base/screens/knowledge/knowledge_base/create_knowledge.dart';
import 'package:advancedmobile_chatai/view_app/knowledge_base/screens/knowledge/units.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/dialog.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Knowledge Base",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fixedSize: const Size(4, 4),
                padding: EdgeInsets.zero,
                elevation: 0,
              ),
              onPressed: () {
                _openCreateKnowledgeModal(context);
              },
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dòng search + nút tạo
                Row(
                  children: [
                    // Ô tìm kiếm
                    Expanded(
                      child: TextField(
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Search Knowledge Base',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : knowledges.isEmpty
                    ? _buildEmptyState() // Hiển thị empty state nếu không có knowledges
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 8.0),
                        itemCount: knowledges.length,
                        itemBuilder: (context, index) {
                          final knowledge = knowledges[index];

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
                                    const Icon(Icons.storage,
                                        size: 20, color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        knowledge.knowledgeName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        knowledge.description?.isNotEmpty ==
                                                true
                                            ? knowledge.description!
                                            : 'No description available',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        // IconButton(
                                        //   icon: const Icon(Icons.edit_outlined,
                                        //       size: 20, color: Colors.grey),
                                        //   padding: EdgeInsets.zero,
                                        //   constraints: const BoxConstraints(),
                                        //
                                        //   onPressed: () {
                                        //     // _openEditBotModal(
                                        //     //     context, assistant);
                                        //   },
                                        // ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline,
                                              size: 20, color: Colors.grey),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            _handleDeleteKnowledge(knowledge.id,
                                                knowledge.knowledgeName);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.arrow_forward,
                                              size: 20, color: Colors.grey),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            _showKnowledgeDetailBottomSheet(
                                                context,
                                                knowledge.id,
                                                knowledge.knowledgeName);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
      message:
          'Are you sure you want to delete the assistant titled "$knowledgeName"?',
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
      builder: (_, controller) => KnowledgeUnitScreen(id: id, knowledgeName: knowledgeName)
    ),

  );
}
