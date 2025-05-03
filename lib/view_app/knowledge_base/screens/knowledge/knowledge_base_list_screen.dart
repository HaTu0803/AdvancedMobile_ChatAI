import 'package:flutter/material.dart';
import 'package:advancedmobile_chatai/data_app/model/base/base_model.dart';
import 'package:advancedmobile_chatai/data_app/model/knowledge_base/knowledge_model.dart';
import 'package:advancedmobile_chatai/data_app/repository/knowledge_base/knowledge_repository.dart';
import 'package:advancedmobile_chatai/data_app/model/knowledge_base/assistant_model.dart';
import 'package:advancedmobile_chatai/data_app/repository/knowledge_base/assistant_repository.dart';

class KnowledgeBaseListScreen extends StatefulWidget {
  final String assistantId;
  
  const KnowledgeBaseListScreen({
    super.key,
    required this.assistantId,
  });

  @override
  State<KnowledgeBaseListScreen> createState() => _KnowledgeBaseListScreenState();
}

class _KnowledgeBaseListScreenState extends State<KnowledgeBaseListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<KnowledgeResponse> knowledges = [];
  List<KnowledgeAssistantResponse> importedKnowledges = [];

  @override
  void initState() {
    super.initState();
    _fetchKnowledges();
    _fetchImportedKnowledges();
  }

  Future<void> _fetchImportedKnowledges() async {
    try {
      final params = BaseQueryParams(limit: 50);
      final response = await AssistantRepository()
          .getImportKnowledgeList(widget.assistantId, params);
      setState(() => importedKnowledges = response.data);
    } catch (e) {
      debugPrint('Error loading imported knowledges: $e');
    }
  }

  bool _isKnowledgeImported(String knowledgeName) {
    return importedKnowledges.any((k) => k.knowledgeName == knowledgeName);
  }

  Future<void> _handleImportKnowledge(String knowledgeId) async {
    try {
      setState(() => _isLoading = true);
      
      final params = KnowledgeToAssistant(
        knowledgeId: knowledgeId,
        assistantId: widget.assistantId,
      );
      
      await AssistantRepository().importKnowledge(params);
      
      // Refresh the imported knowledges list
      await _fetchImportedKnowledges();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Knowledge base imported successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to import knowledge base: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchKnowledges() async {
    setState(() => _isLoading = true);
    try {
      final params = BaseQueryParams(
        q: _searchController.text,
        limit: 50,
      );
      final response = await KnowledgeRepository().getKnowledges(params);
      setState(() => knowledges = response.data);
    } catch (e) {
      debugPrint('Error loading knowledges: $e');
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load knowledge bases: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          const SizedBox(height: 16),
          const Text(
            "No knowledge bases found",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Knowledge Base List',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 4),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  _fetchKnowledges();
                },
                decoration: InputDecoration(
                  hintText: 'Search knowledge bases...',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : knowledges.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: knowledges.length,
                        itemBuilder: (context, index) {
                          final knowledge = knowledges[index];
                          final isImported = _isKnowledgeImported(knowledge.knowledgeName);
                          
                          return _buildKnowledgeBaseItem(
                            title: knowledge.knowledgeName,
                            description: knowledge.description,
                            icon: Icons.storage_outlined,
                            iconColor: Colors.blue,
                            isImported: isImported,
                            onTap: () {
                              if (!isImported) {
                                _handleImportKnowledge(knowledge.id);
                              }
                            },
                          );
                        },
                      ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FilledButton.icon(
                onPressed: () {
                  // Handle create new knowledge base
                },
                icon: const Icon(Icons.add, size: 20),
                label: const Text(
                  'Create new knowledge base',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKnowledgeBaseItem({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required bool isImported,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.storage_outlined,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description.isNotEmpty ? description : 'No description available',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (isImported)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Imported',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 