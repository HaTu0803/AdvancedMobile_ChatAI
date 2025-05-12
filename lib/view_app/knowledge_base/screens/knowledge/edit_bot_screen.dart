import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../../../data_app/model/knowledge_base/assistant_model.dart';
import '../../../../data_app/repository/knowledge_base/assistant_repository.dart';
import '../../../../data_app/model/jarvis/prompt_model.dart';
import '../../../../data_app/repository/jarvis/prompt_repository.dart';
import '../../../../data_app/repository/knowledge_base/knowledge_repository.dart';
import '../../../../data_app/model/base/base_model.dart';
import "knowledge_base_list_screen.dart";
import '../../../../data_app/repository/knowledge_base/bot_integration_repository.dart';
import 'package:advancedmobile_chatai/data_app/model/knowledge_base/bot_integrations_model.dart';

class EditBotScreen extends StatefulWidget {
  final AssistantResponse assistant;

  const EditBotScreen({
    super.key,
    required this.assistant,
  });

  @override
  State<EditBotScreen> createState() => _EditBotScreenState();
}

class _EditBotScreenState extends State<EditBotScreen> {
  int _selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _messageController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  bool _isLoading = false;
  bool _isSending = false;
  bool _showSuggestions = false;
  OverlayEntry? _overlayEntry;
  List<PromptItemV2> _suggestions = [];
  bool _isLoadingPrompts = false;
  late AssistantResponse _currentAssistant;
  String? _currentThreadId;
  List<RetrieveMessageOfThreadResponse> _messages = [];
  List<KnowledgeAssistantResponse> _importedKnowledges = [];
  Map<String, String> _knowledgeIdMap = {};
  bool _isLoadingKnowledges = false;
  final Map<String, bool> _platformChecked = {
    'Slack': false,
    'Telegram': false,
    'Messenger': false,
  };
  Map<String, dynamic> _platformStatus = {};
  bool _isLoadingConfig = false;
  String? _telegramBotToken;
  String? _slackBotToken;
  String? _slackClientId;
  String? _slackClientSecret;
  String? _slackSigningSecret;
  String? _messengerBotToken;
  String? _messengerPageId;
  String? _messengerAppSecret;
  bool _isBotThinking = false;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentAssistant = widget.assistant;
    _nameController.text = _currentAssistant.assistantName;
    _instructionsController.text = _currentAssistant.instructions ?? '';
    _descriptionController.text = _currentAssistant.description ?? '';
    _messageController.addListener(_handleTextChange);
    _fetchKnowledges();
    _fetchImportedKnowledges();
    _fetchPlatformConfigurations();
  }

  @override
  void dispose() {
    _hideOverlay();
    _messageController.removeListener(_handleTextChange);
    _messageController.dispose();
    _nameController.dispose();
    _instructionsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    final text = _messageController.text;
    if (text.endsWith('/')) {
      _showOverlay();
      _fetchPrompts();
    } else if (_showSuggestions && !text.contains('/')) {
      _hideOverlay();
    }
  }

  Future<void> _fetchPrompts() async {
    if (_isLoadingPrompts) return;

    setState(() {
      _isLoadingPrompts = true;
    });

    try {
      final publicPrompts = await PromptRepository().getPrompt(
        GetPromptRequest(isPublic: true, limit: 50),
      );
      final privatePrompts = await PromptRepository().getPrompt(
        GetPromptRequest(isPublic: false, limit: 50),
      );

      setState(() {
        _suggestions = [...publicPrompts.items, ...privatePrompts.items];
        _updateOverlay();
      });
    } catch (e) {
      debugPrint('Error fetching prompts: $e');
    } finally {
      setState(() {
        _isLoadingPrompts = false;
      });
    }
  }

  Future<void> _fetchKnowledges() async {
    try {
      final params = BaseQueryParams(limit: 50);
      final response = await KnowledgeRepository().getKnowledges(params);
      setState(() {
        _knowledgeIdMap = {
          for (var k in response.data) k.knowledgeName: k.id
        };
      });
    } catch (e) {
      debugPrint('Error loading knowledges: $e');
    }
  }

  Future<void> _fetchImportedKnowledges() async {
    setState(() => _isLoadingKnowledges = true);
    try {
      final params = BaseQueryParams(limit: 50);
      final response = await AssistantRepository()
          .getImportKnowledgeList(_currentAssistant.id, params);
      setState(() => _importedKnowledges = response.data);
    } catch (e) {
      debugPrint('Error loading imported knowledges: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load knowledge bases: $e')),
      );
    } finally {
      setState(() => _isLoadingKnowledges = false);
    }
  }

  Future<void> _removeKnowledge(String knowledgeName) async {
    final knowledgeId = _knowledgeIdMap[knowledgeName];
    if (knowledgeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not find knowledge ID')),
      );
      return;
    }

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remove Knowledge Base'),
        content: const Text('Are you sure you want to remove this knowledge base from the assistant?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      setState(() => _isLoading = true);
      
      final params = KnowledgeToAssistant(
        knowledgeId: knowledgeId,
        assistantId: _currentAssistant.id,
      );
      
      await AssistantRepository().removeKnowledge(params);
      await _fetchImportedKnowledges();
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Knowledge base removed successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove knowledge base: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showOverlay() {
    _hideOverlay();

    _showSuggestions = true;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _showSuggestions = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _selectPrompt(PromptItemV2 prompt) {
    _messageController.text = prompt.content;
    _messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: _messageController.text.length),
    );
    _hideOverlay();
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy - 200,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, -200),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: _isLoadingPrompts
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final prompt = _suggestions[index];
                        return ListTile(
                          title: Text(
                            prompt.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            prompt.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => _selectPrompt(prompt),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Bot',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Name',
                      maxLines: 1,
                      controller: _nameController,
                      hintText: 'Enter a name for your bot...',
                      isRequired: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name for your bot';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildFormField(
                      label: 'Instructions (Optional)',
                      controller: _instructionsController,
                      hintText: 'Enter instructions for the bot...',
                      isRequired: false,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 8),
                    _buildFormField(
                      label: 'Description (Optional)',
                      controller: _descriptionController,
                      hintText: 'Enter a short description...',
                      isRequired: false,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: _isLoading ? null : () => _submitForm(context),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Update Bot'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required bool isRequired,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final request = Assistant(
          assistantName: _nameController.text,
          instructions: _instructionsController.text,
          description: _descriptionController.text,
        );
        
        final updatedAssistant = await AssistantRepository().updateAssistant(_currentAssistant.id, request);
        
        Navigator.pop(context); 
        setState(() {
          _currentAssistant = updatedAssistant;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bot updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update bot: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildMessageBubble(RetrieveMessageOfThreadResponse message) {
    final theme = Theme.of(context);
    final isUser = message.role == 'user';
    final messageText = message.content.isNotEmpty 
        ? message.content.first.text.value 
        : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.smart_toy,
                size: 18,
                color: theme.colorScheme.primary,
              ),
            ),
          if (isUser)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'N',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isUser ? 'You' : _currentAssistant.assistantName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  messageText,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 14,
                  ),
                ),
              ],
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
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
                _currentAssistant.assistantName,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black87),
            onPressed: _showEditDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                _buildTab(
                  index: 0,
                  icon: Icons.library_books_outlined,
                  label: 'Knowledge',
                  theme: theme,
                ),
                _buildTab(
                  index: 1,
                  icon: Icons.remove_red_eye_outlined,
                  label: 'Preview',
                  theme: theme,
                ),
                _buildTab(
                  index: 2,
                  icon: Icons.cloud_upload_outlined,
                  label: 'Publish',
                  theme: theme,
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildKnowledgeTab(),
                _buildPreviewTab(),
                _buildPublishTab(context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _selectedIndex == 0 ? SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KnowledgeBaseListScreen(
                    assistantId: _currentAssistant.id,
                  ),
                ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 20),
                SizedBox(width: 8),
                Text(
                  'Add knowledge source',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ) : null,
    );
  }

  Widget _buildTab({
    required int index,
    required IconData icon,
    required String label,
    required ThemeData theme,
  }) {
    final isSelected = _selectedIndex == index;
    
    return Expanded(
      child: InkWell(
        onTap: () => _onTabChanged(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? theme.colorScheme.primary : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? theme.colorScheme.primary : Colors.grey,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTabChanged(int index) {
    setState(() => _selectedIndex = index);
    if (index == 2) {
      _fetchPlatformConfigurations();
    }
  }

  Future<void> _fetchPlatformConfigurations() async {
    setState(() => _isLoadingConfig = true);
    try {
      final config = await BotIntegrationRepository().getConfigurations(_currentAssistant.id);
      setState(() {
        _platformStatus = config ?? {};
      });
    } catch (e) {
      // handle error, có thể show snackbar
    } finally {
      setState(() => _isLoadingConfig = false);
    }
  }

  Widget _buildKnowledgeTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Choose a knowledge base below to add knowledge units.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: _isLoadingKnowledges
              ? const Center(child: CircularProgressIndicator())
              : _importedKnowledges.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.storage_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No knowledge bases yet',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add a knowledge base to get started',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _importedKnowledges.length,
                      itemBuilder: (context, index) {
                        final knowledge = _importedKnowledges[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.storage_outlined,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              knowledge.knowledgeName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                                  onPressed: () => _removeKnowledge(knowledge.knowledgeName),
                                ),
                                const Icon(Icons.chevron_right, color: Colors.grey),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildPreviewTab() {
    final theme = Theme.of(context);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.07),
              border: Border(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.13)),
              ),
            ),
            child: Text(
              "Preview the assistant's responses in a chat interface.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.deepPurple[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Chat area
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(0.10),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.smart_toy,
                                color: theme.colorScheme.primary,
                                size: 44,
                              ),
                            ),
                            const SizedBox(height: 22),
                            Text(
                              "No messages yet",
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.deepPurple[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Start a conversation to test your bot!",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.deepPurple[300],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                        itemCount: _messages.length,
                        itemBuilder: (context, idx) {
                          final msg = _messages[idx];
                          if (msg.role == 'assistant' && msg.content.first.text.value == '' && _isBotThinking) {
                            return _buildBotThinkingBubble();
                          }
                          return _buildMessageBubble(msg);
                        },
                      ),
              ),
            ),
          ),
          // New Thread button 
          if (_messages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 18, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: _createNewThread,
                    icon: Icon(Icons.refresh, color: theme.colorScheme.primary),
                    label: Text(
                      "New Thread",
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Bottom input area
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.withOpacity(0.13)),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CompositedTransformTarget(
                        link: _layerLink,
                        child: TextField(
                          controller: _messageController,
                          enabled: !_isSending,
                          decoration: InputDecoration(
                            hintText: "Ask me anything, press '/' for prompts...",
                            filled: true,
                            fillColor: Colors.deepPurple[50],
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: theme.colorScheme.primary, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.deepPurple.withOpacity(0.18)),
                            ),
                          ),
                          onSubmitted: (val) {
                            _sendMessage();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.send_rounded,
                          color: theme.colorScheme.primary, size: 28),
                      onPressed: _isSending ? null : _sendMessage,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublishTab(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Changelog',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 12),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Enter this bot version's changelog",
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Publish to *',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'By publishing your bot on the following platforms, you fully understand and agree to abide by Terms of service for each publishing channel (including, but not limited to, any privacy policy, community guidelines, data processing agreement, etc.).',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            _isLoadingConfig
                ? const Center(child: CircularProgressIndicator())
                : _buildPlatformList(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _platformChecked.values.any((v) => v)
                    ? () async {
                        if (_platformChecked['Telegram'] == true) {
                          try {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(child: CircularProgressIndicator()),
                            );
                            await BotIntegrationRepository().publishTelegramBot(_currentAssistant.id, _telegramBotToken ?? '');
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Publish Telegram bot thành công!')),
                            );
                          } catch (e) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Publish Telegram bot thất bại: $e')),
                            );
                          }
                        }
                        if (_platformChecked['Slack'] == true) {
                          try {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(child: CircularProgressIndicator()),
                            );
                            await BotIntegrationRepository().publishSlackBot(
                              _currentAssistant.id,
                              _slackBotToken ?? '',
                              _slackClientId ?? '',
                              _slackClientSecret ?? '',
                              _slackSigningSecret ?? '',
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Publish Slack bot thành công!')),
                            );
                          } catch (e) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Publish Slack bot thất bại: $e')),
                            );
                          }
                        }
                        if (_platformChecked['Messenger'] == true) {
                          try {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(child: CircularProgressIndicator()),
                            );
                            await BotIntegrationRepository().publishMessengerBot(
                              _currentAssistant.id,
                              _messengerBotToken ?? '',
                              _messengerPageId ?? '',
                              _messengerAppSecret ?? '',
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Publish Messenger bot thành công!')),
                            );
                          } catch (e) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Publish Messenger bot thất bại: $e')),
                            );
                          }
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Publish',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformList() {
    final List<_PlatformItem> platforms = [
      _PlatformItem(
        name: 'Slack',
        logoPath: 'images/slack.png',
        status: _platformStatus['Slack']?['status'] ?? 'Not Configured',
        statusColor: _getStatusColor(_platformStatus['Slack']?['status']),
      ),
      _PlatformItem(
        name: 'Telegram',
        logoPath: 'images/telegram.png',
        status: _platformStatus['Telegram']?['status'] ?? 'Not Configured',
        statusColor: _getStatusColor(_platformStatus['Telegram']?['status']),
      ),
      _PlatformItem(
        name: 'Messenger',
        logoPath: 'images/messenger.png',
        status: _platformStatus['Messenger']?['status'] ?? 'Not Configured',
        statusColor: _getStatusColor(_platformStatus['Messenger']?['status']),
      ),
    ];
    return Column(
      children: platforms.map((platform) {
        final isVerified = platform.status == 'Verified';
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Checkbox(
                  value: _platformChecked[platform.name]!,
                  onChanged: isVerified
                      ? (val) {
                          setState(() {
                            _platformChecked[platform.name] = val!;
                          });
                        }
                      : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    platform.logoPath,
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        platform.name,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: platform.statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          platform.status,
                          style: TextStyle(
                            color: platform.statusColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: platform.name == 'Slack'
                      ? _showConfigureSlackDialog
                      : platform.name == 'Messenger'
                          ? _showConfigureMessengerDialog
                          : platform.name == 'Telegram'
                              ? _showConfigureTelegramDialog
                              : () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                  child: const Text('Configure'),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    switch (status) {
      case 'Verified':
        return Colors.green;
      case 'Not Configured':
      default:
        return Colors.grey;
    }
  }

  void _showConfigureSlackDialog() {
    final _formKey = GlobalKey<FormState>();
    final _tokenController = TextEditingController();
    final _clientIdController = TextEditingController();
    final _clientSecretController = TextEditingController();
    final _signingSecretController = TextEditingController();
    bool isVerified = _platformStatus['Slack']?['status'] == 'Verified';
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> verifyAndSetStatus() async {
              if (!_formKey.currentState!.validate()) return;
              setState(() => isLoading = true);
              try {
                final request = SlackBot(
                  botToken: _tokenController.text,
                  clientId: _clientIdController.text,
                  clientSecret: _clientSecretController.text,
                  signingSecret: _signingSecretController.text,
                );
                final result = await BotIntegrationRepository().verifySlackBotConfigure(request);
                if (result) {
                  setState(() {
                    isVerified = true;
                  });
                  this.setState(() {
                    _platformStatus['Slack'] = {'status': 'Verified'};
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Slack bot verified successfully')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to verify Slack bot: $e')),
                );
              } finally {
                setState(() => isLoading = false);
              }
            }

            Future<void> disconnectSlack() async {
              setState(() => isLoading = true);
              try {
                final request = DisconnectBotIntegration(
                  assistantId: _currentAssistant.id,
                  type: 'slack',
                );
                final result = await BotIntegrationRepository().disconnectBotIntegration(request);
                if (result) {
                  setState(() {
                    isVerified = false;
                  });
                  this.setState(() {
                    _platformStatus['Slack'] = {'status': 'Not Configured'};
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Slack bot disconnected')),
                  );
                  Navigator.pop(context);
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to disconnect Slack bot: $e')),
                );
              } finally {
                setState(() => isLoading = false);
              }
            }

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 16,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Configure Slack Bot',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[900],
                                  ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Card(
                        color: Colors.blue[50],
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Slack copylink',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue[800],
                                      )),
                              const SizedBox(height: 6),
                              Text(
                                'Copy the following content to your Slack app configuration page.',
                                style: TextStyle(color: Colors.blueGrey[700], fontSize: 14),
                              ),
                              _buildCopyRow('OAuth2 Redirect URLs', 'https://knowledge-api.jarvis.cx/kb-core/v1/bot-integration/slack/auth/${_currentAssistant.id}'),
                              const SizedBox(height: 10),
                              _buildCopyRow('Event Request URL', 'https://knowledge-api.jarvis.cx/kb-core/v1/hook/slack/${_currentAssistant.id}'),
                              const SizedBox(height: 10),
                              _buildCopyRow('Slash Request URL', 'https://knowledge-api.jarvis.cx/kb-core/v1/hook/slack/slash/${_currentAssistant.id}'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Card(
                        color: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Slack information',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue[800],
                                      )),
                              const SizedBox(height: 10),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    _buildSlackTextField(
                                      'Token',
                                      _tokenController,
                                      'Please enter bot token',
                                      icon: Icons.vpn_key,
                                      onChanged: (val) {
                                        setState(() {
                                          _slackBotToken = val;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    _buildSlackTextField(
                                      'Client ID',
                                      _clientIdController,
                                      'Please enter client ID',
                                      icon: Icons.perm_identity,
                                      onChanged: (val) {
                                        setState(() {
                                          _slackClientId = val;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    _buildSlackTextField(
                                      'Client Secret',
                                      _clientSecretController,
                                      'Please enter client secret',
                                      icon: Icons.lock_outline,
                                      onChanged: (val) {
                                        setState(() {
                                          _slackClientSecret = val;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    _buildSlackTextField(
                                      'Signing Secret',
                                      _signingSecretController,
                                      'Please enter signing secret',
                                      icon: Icons.security,
                                      onChanged: (val) {
                                        setState(() {
                                          _slackSigningSecret = val;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              side: BorderSide(color: Colors.blue.shade700),
                            ),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 14),
                          isVerified
                              ? ElevatedButton(
                                  onPressed: isLoading ? null : disconnectSlack,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[700],
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text('Disconnect', style: TextStyle(fontWeight: FontWeight.bold)),
                                )
                              : ElevatedButton(
                                  onPressed: isLoading ? null : verifyAndSetStatus,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[700],
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCopyRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              SelectableText(value, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Copy',
          icon: const Icon(Icons.copy, size: 18),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 18),
                    SizedBox(width: 8),
                    Text('Copied!'),
                  ],
                ),
                duration: Duration(milliseconds: 900),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSlackTextField(
    String label,
    TextEditingController controller,
    String errorText, {
    IconData? icon,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, size: 20) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      ),
      validator: (value) => (value == null || value.isEmpty) ? errorText : null,
    );
  }

  void _showConfigureMessengerDialog() {
    final _formKey = GlobalKey<FormState>();
    final _pageIdController = TextEditingController();
    final _appIdController = TextEditingController();
    final _appSecretController = TextEditingController();
    final _pageAccessTokenController = TextEditingController();
    bool isVerified = _platformStatus['Messenger']?['status'] == 'Verified';
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> verifyAndSetStatus() async {
              if (!_formKey.currentState!.validate()) return;
              setState(() => isLoading = true);
              try {
                final request = MessengerSlackBot(
                  botToken: _pageAccessTokenController.text,
                  pageId: _pageIdController.text,
                  appSecret: _appSecretController.text,
                );
                final result = await BotIntegrationRepository().verifyMessengerBotConfigure(request);
                if (result) {
                  setState(() {
                    isVerified = true;
                  });
                  this.setState(() {
                    _platformStatus['Messenger'] = {'status': 'Verified'};
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Messenger bot verified successfully')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to verify Messenger bot: $e')),
                );
              } finally {
                setState(() => isLoading = false);
              }
            }

            Future<void> disconnectMessenger() async {
              setState(() => isLoading = true);
              try {
                final request = DisconnectBotIntegration(
                  assistantId: _currentAssistant.id,
                  type: 'messenger',
                );
                final result = await BotIntegrationRepository().disconnectBotIntegration(request);
                if (result) {
                  setState(() {
                    isVerified = false;
                  });
                  this.setState(() {
                    _platformStatus['Messenger'] = {'status': 'Not Configured'};
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Messenger bot disconnected')),
                  );
                  Navigator.pop(context);
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to disconnect Messenger bot: $e')),
                );
              } finally {
                setState(() => isLoading = false);
              }
            }

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 16,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Configure Messenger Bot',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[900],
                                  ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Card(
                        color: Colors.blue[50],
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Messenger Webhook URL',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue[800],
                                      )),
                              const SizedBox(height: 6),
                              Text(
                                'Copy the following webhook URL to your Facebook App configuration page.',
                                style: TextStyle(color: Colors.blueGrey[700], fontSize: 14),
                              ),
                              _buildCopyRow('Callback URL', 'https://knowledge-api.jarvis.cx/kb-core/v1/hook/messenger/${_currentAssistant.id}'),
                              _buildCopyRow('Verify Token', 'knowledge'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Card(
                        color: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Messenger information',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue[800],
                                      )),
                              const SizedBox(height: 10),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    _buildMessengerTextField(
                                      'Bot Token',
                                      _pageAccessTokenController,
                                      'Please enter Bot Token',
                                      icon: Icons.vpn_key,
                                      onChanged: (val) {
                                        setState(() {
                                          _messengerBotToken = val;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    _buildMessengerTextField(
                                      'Page ID',
                                      _pageIdController,
                                      'Please enter Facebook Page ID',
                                      icon: Icons.pages,
                                      onChanged: (val) {
                                        setState(() {
                                          _messengerPageId = val;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    _buildMessengerTextField(
                                      'App Secret',
                                      _appSecretController,
                                      'Please enter Facebook App Secret',
                                      icon: Icons.lock_outline,
                                      onChanged: (val) {
                                        setState(() {
                                          _messengerAppSecret = val;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              side: BorderSide(color: Colors.blue.shade700),
                            ),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 14),
                          isVerified
                              ? ElevatedButton(
                                  onPressed: isLoading ? null : disconnectMessenger,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[700],
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text('Disconnect', style: TextStyle(fontWeight: FontWeight.bold)),
                                )
                              : ElevatedButton(
                                  onPressed: isLoading ? null : verifyAndSetStatus,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[700],
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMessengerTextField(
    String label,
    TextEditingController controller,
    String errorText, {
    IconData? icon,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, size: 20) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      ),
      validator: (value) => (value == null || value.isEmpty) ? errorText : null,
    );
  }

  void _showConfigureTelegramDialog() {
    final _formKey = GlobalKey<FormState>();
    final _tokenController = TextEditingController();
    bool isVerified = _platformStatus['Telegram']?['status'] == 'Verified';
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> verifyAndSetStatus() async {
              if (!_formKey.currentState!.validate()) return;
              setState(() => isLoading = true);
              try {
                final request = TelegramBot(
                  botToken: _tokenController.text,
                );
                final result = await BotIntegrationRepository().verifyTelegramBotConfigure(request);
                if (result) {
                  setState(() {
                    isVerified = true;
                  });
                  this.setState(() {
                    _platformStatus['Telegram'] = {'status': 'Verified'};
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Telegram bot verified successfully')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to verify Telegram bot: $e')),
                );
              } finally {
                setState(() => isLoading = false);
              }
            }

            Future<void> disconnectTelegram() async {
              setState(() => isLoading = true);
              try {
                final request = DisconnectBotIntegration(
                  assistantId: _currentAssistant.id,
                  type: 'telegram',
                );
                final result = await BotIntegrationRepository().disconnectBotIntegration(request);
                if (result) {
                  setState(() {
                    isVerified = false;
                  });
                  this.setState(() {
                    _platformStatus['Telegram'] = {'status': 'Not Configured'};
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Telegram bot disconnected')),
                  );
                  Navigator.pop(context);
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to disconnect Telegram bot: $e')),
                );
              } finally {
                setState(() => isLoading = false);
              }
            }

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 16,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Configure Telegram Bot',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Connect to Telegram Bots and chat with this bot in Telegram App',
                        style: TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                        },
                        child: Text(
                          'How to obtain Telegram configurations?',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue[700]),
                          const SizedBox(width: 8),
                          Text(
                            'Telegram information',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '*',
                                  style: TextStyle(color: Colors.red, fontSize: 18),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Token',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _tokenController,
                              onChanged: (val) {
                                setState(() {
                                  _telegramBotToken = val;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              ),
                              validator: (value) => (value == null || value.isEmpty) ? 'Please enter bot token' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 14),
                          isVerified
                              ? ElevatedButton(
                                  onPressed: isLoading ? null : disconnectTelegram,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[700],
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text('Disconnect', style: TextStyle(fontWeight: FontWeight.bold)),
                                )
                              : ElevatedButton(
                                  onPressed: isLoading ? null : verifyAndSetStatus,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[700],
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _createNewThread() async {
    setState(() {
      _messages = [];
      _currentThreadId = null;
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
      _isBotThinking = true;
      _messages.add(
        RetrieveMessageOfThreadResponse(
          role: 'user',
          createdAt: DateTime.now().millisecondsSinceEpoch,
          content: [
            MessageContent(
              type: 'text',
              text: MessageText(value: text, annotations: []),
            ),
          ],
        ),
      );
      _messages.add(
        RetrieveMessageOfThreadResponse(
          role: 'assistant',
          createdAt: DateTime.now().millisecondsSinceEpoch,
          content: [
            MessageContent(
              type: 'text',
              text: MessageText(value: '', annotations: []),
            ),
          ],
        ),
      );
    });

    _messageController.clear();
    await Future.delayed(const Duration(milliseconds: 100));
    _scrollToBottom();

    try {
      if (_currentThreadId == null) {
        _currentThreadId = DateTime.now().millisecondsSinceEpoch.toString();
      }

      final askRequest = AskAssistant(
        message: text,
        openAiThreadId: _currentThreadId!,
        additionalInstruction: '',
      );

      final botResponse = await AssistantRepository().askAssistant(_currentAssistant.id, askRequest);

      setState(() {
        _isBotThinking = false;
        if (_messages.isNotEmpty && _messages.last.role == 'assistant' && _messages.last.content.first.text.value == '') {
          _messages.removeLast();
        }
        if (botResponse != null) {
          if (botResponse is Map<String, dynamic>) {
            _messages.add(RetrieveMessageOfThreadResponse.fromJson(botResponse));
          } else if (botResponse is String) {
            final lines = botResponse.split('\n');
            final buffer = StringBuffer();
            for (final line in lines) {
              if (line.startsWith('data:')) {
                final jsonStr = line.substring(5).trim();
                try {
                  final data = jsonStr.isNotEmpty ? jsonDecode(jsonStr) : null;
                  final content = data != null && data['content'] != null ? data['content'].toString() : '';
                  if (content.trim().isNotEmpty) {
                    buffer.write(content);
                  }
                } catch (e) {}
              }
            }
            final fullContent = buffer.toString().trim();
            if (fullContent.isNotEmpty) {
              _messages.add(
                RetrieveMessageOfThreadResponse(
                  role: 'assistant',
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                  content: [
                    MessageContent(
                      type: 'text',
                      text: MessageText(value: fullContent, annotations: []),
                    ),
                  ],
                ),
              );
            }
          }
        }
      });

      await Future.delayed(const Duration(milliseconds: 100));
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isBotThinking = false;
        if (_messages.isNotEmpty && _messages.last.role == 'assistant' && _messages.last.content.first.text.value == '') {
          _messages.removeLast();
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildBotThinkingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.smart_toy,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentAssistant.assistantName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDots(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlatformItem {
  final String name;
  final String logoPath;
  final String status;
  final Color statusColor;
  _PlatformItem({
    required this.name,
    required this.logoPath,
    required this.status,
    required this.statusColor,
  });
}

class AnimatedDots extends StatefulWidget {
  @override
  State<AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<AnimatedDots> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int dotCount = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(() {
        if (_controller.status == AnimationStatus.completed) {
          setState(() {
            dotCount = dotCount % 3 + 1;
          });
          _controller.forward(from: 0);
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Bot is thinking${'.' * dotCount}',
      style: TextStyle(
        color: Colors.grey[600],
        fontStyle: FontStyle.italic,
        fontSize: 14,
      ),
    );
  }
}