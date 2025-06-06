import 'package:advancedmobile_chatai/data_app/model/base/base_model.dart';
import 'package:advancedmobile_chatai/data_app/model/knowledge_base/knowledge_data_source_model_v2.dart';
import 'package:advancedmobile_chatai/data_app/repository/knowledge_base/knowledge_data_source_repository_v2.dart';
import 'package:advancedmobile_chatai/view_app/knowledge_base/screens/knowledge_data_source/upload_file.dart';
import 'package:advancedmobile_chatai/view_app/knowledge_base/screens/knowledge_data_source/upload_slack.dart';
import 'package:advancedmobile_chatai/view_app/knowledge_base/screens/knowledge_data_source/upload_website.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/dialog.dart';
import '../knowledge_data_source/upload_confluence.dart';

class KnowledgeUnitScreen extends StatefulWidget {
  final String id;
  final String knowledgeName;
  final VoidCallback? onSuccess;
  const KnowledgeUnitScreen({
    super.key,
    required this.id,
    required this.knowledgeName,
    this.onSuccess,
  });

  @override
  State<KnowledgeUnitScreen> createState() => _KnowledgeUnitScreenState();
}

class _KnowledgeUnitScreenState extends State<KnowledgeUnitScreen> {
  String searchQuery = '';
  List<KnowledgeDataSource> units = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _offset = 0;
  final int _limit = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchKnowledgeUnits();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _fetchKnowledgeUnits();
    }
  }

  Future<void> _fetchKnowledgeUnits() async {
    setState(() => _isLoading = true);

    final params = BaseQueryParams(
      q: searchQuery,
      limit: _limit,
      offset: _offset,
    );

    try {
      final response =
          await KnowledgeDataRepository().getDataSources(widget.id, params);
      setState(() {
        units.addAll(response.data);
        _hasMore = response.meta.hasNext;
        if (_hasMore) {
          _offset += _limit;
        }
          });
    } catch (e) {
      debugPrint('Error loading units: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }


  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
      units.clear();
      _offset = 0;
      _hasMore = true;
    });
    if (value.length >= 2 || value.isEmpty) {
      _fetchKnowledgeUnits();
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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
              child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
                    child: Text(
                      widget.knowledgeName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow:
                          TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 22,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onSuccess?.call();
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 42,
                      child: TextField(
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Search Knowledge Base',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.search,
                              color: Theme.of(context).colorScheme.primary),
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
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      fixedSize: const Size(30, 30),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                    ),
                    onPressed: () {
                      _openCreateKnowledgeModal(context);
                    },
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : units.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemCount: units.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == units.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final unit = units[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
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
                                  // Ảnh bên trái
                                  Image.asset(
                                    unit.type == 'local_file'
                                        ? 'images/file.png'
                                        : unit.type == 'confluence'
                                        ? 'images/confluence.png'
                                        : unit.type == 'slack'
                                        ? 'images/slack.png'
                                        : unit.type == 'website'
                                        ? 'images/web.png'
                                        : 'images/file.png',
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          unit.name ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: unit.status ? Colors.green : Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              '${(unit.size / 1024).toStringAsFixed(1)} KB',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),

                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                  // Icon chuyển active
                                  IconButton(
                                    icon: Icon(
                                      unit.status
                                          ? Icons.toggle_on
                                          : Icons.toggle_off,
                                      color: unit.status
                                          ? Colors.blue
                                          : Colors.grey,
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      _handleToggleActive(unit);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 24,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      _handleDeleteUnit(unit);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            )
          ],
        ),
      ),
    );
  }

  void _handleDeleteUnit(KnowledgeDataSource unit) {
    showCustomDialog(
      context: context,
      title: 'Delete Knowledge Unit',
      message: Text.rich(
        TextSpan(
          children: [
            const TextSpan(
                text: 'Are you sure you want to delete '),
            TextSpan(
              text: unit.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: '? This action cannot be undone'),
          ],
        ),
      ),

      isConfirmation: true,
      confirmText: 'Yes, Delete',
      cancelText: 'Cancel',
      onConfirm: () async {
        try {
          await KnowledgeDataRepository().deleteDataSource(unit.knowledgeId,unit.id);


          setState(() {
            units.removeWhere((u) => u.id == unit.id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Delete Knowledge Unit successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete Delete Knowledge Unit: $e')),
          );
        } finally {}
      },
    );
  }
  Future<void> _handleToggleActive(KnowledgeDataSource unit) async {

    try {
      final newStatus = !unit.status;

      final response = await KnowledgeDataRepository()
          .updateDataSource(unit.knowledgeId,unit.id, newStatus);

      setState(() {
        final index = units.indexWhere((u) => u.id == unit.id);
        if (index != -1) {
          units[index] = KnowledgeDataSource(
            name: unit.name,
            type: unit.type,
            size: unit.size,
            status: newStatus,
            userId: unit.userId,
            metadata: unit.metadata,
            knowledgeId: unit.knowledgeId,
            createdAt: unit.createdAt,
            updatedAt: unit.updatedAt,
            createdBy: unit.createdBy,
            updatedBy: unit.updatedBy,
            deletedAt: unit.deletedAt,
            id: unit.id,
          );
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status updated successfully')),
      );
    } catch (e) {
     print('Error updating status: $e');

    }
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
              width: MediaQuery.of(context).size.width * 0.95,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Knowledge Source',
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
                    _buildSourceItem(
                      context,
                      title: 'Local files',
                      subtitle: 'Upload pdf, docx, ...',
                      imagePath: 'images/file.png',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              ImportLocalFilesDialog(id: widget.id,
                                  onSuccess: () {
                                    Navigator.pop(context);
                                    _fetchKnowledgeUnits();
                                  }),


                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildSourceItem(
                      context,
                      title: 'Website',
                      subtitle: 'Connect Website to get data',
                      imagePath: 'images/web.png',
                      onTap: () {
                        // TODO: Open website connect screen
                        _openUploadWebsite(context);
                      },
                    ),
                    const SizedBox(height: 8),

                    _buildSourceItem(
                      context,
                      title: 'Slack',
                      subtitle: 'Connect to Slack Workspace',
                      imagePath: 'images/slack.png',
                      onTap: () {
                        _openUploadSlack(context);
                      },
                    ),
                    const SizedBox(height: 8),

                    _buildSourceItem(
                      context,
                      title: 'Confluence',
                      subtitle: 'Connect to Confluence',
                      imagePath: 'images/confluence.png',
                      onTap: () {
                        _openUploadConfluence(context);
                      },
                    ),
                    const Divider(height: 32),
                    _buildComingSoonItem(context,
                        title: 'Google Drive',
                        imagePath: 'images/google_drive.png'),
                    _buildComingSoonItem(context,
                        title: 'Github Repository',
                        imagePath: 'images/github.png'),
                    _buildComingSoonItem(context,
                        title: 'Gitlab Repository',
                        imagePath: 'images/gitlab.png'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSourceItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 240, 248, 255),
                borderRadius: BorderRadius.circular(
                    999),
              ),
              child: Image.asset(
                imagePath,
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildComingSoonItem(BuildContext context,
      {required String title, required String imagePath}) {
    return Opacity(
      opacity: 0.5,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 240, 248, 255),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Image.asset(
                imagePath,
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child:
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Coming soon',
                style: TextStyle(fontSize: 10),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  void _openUploadWebsite(BuildContext context) {
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
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Import Web Source',
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
                    const SizedBox(height: 8),
                    AddWebSiteScreen(
                      onSuccess: () {
                        Navigator.pop(context);
                        _fetchKnowledgeUnits();
                      },
                      id: widget.id,
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

  void _openUploadSlack(BuildContext context) {
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
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Import Slack Source',
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
                    UploadSlackScreen(
                      onSuccess: () {
                        _fetchKnowledgeUnits();
                      },
                      id: widget.id,
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
  void _openUploadConfluence(BuildContext context) {
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
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Import Confluence Source',
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
                    UploadConfluenceScreen(
                      onSuccess: () {
                        Navigator.pop(context);
                        _fetchKnowledgeUnits();
                      },
                      id: widget.id,
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
  //                       _fetchKnowledgeUnits();
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

  // void _handleDeleteKnowledge(String id, String name) {
  //   showCustomDialog(
  //     context: context,
  //     title: 'Delete Knowledge Unit',
  //     message:
  //         'Are you sure you want to delete  "$name"?',
  //     isConfirmation: true,
  //     confirmText: 'Yes, Delete',
  //     cancelText: 'Cancel',
  //     onConfirm: () async {
  //       try {
  //         await KnowledgeDataApiClient().deleteKnowledge(id);
  //
  //         setState(() {
  //           units.removeWhere((a) => a.id == id);
  //         });
  //
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Assistant deleted successfully')),
  //         );
  //       } catch (e) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Failed to delete assistant: $e')),
  //         );
  //       }
  //     },
  //   );
  // }

// void _handleFavoriteBot(String assistantId) async {
//   try {
//     await AssistantRepository().favoriteAssistant(assistantId);
//     setState(() {
//       final index = units.indexWhere((a) => a.id == assistantId);
//       if (index != -1) {
//         // Toggle isFavorite state
//         units[index] = units[index].copyWith(
//           isFavorite: !(units[index].isFavorite ?? false),
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
