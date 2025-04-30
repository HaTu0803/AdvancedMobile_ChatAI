import 'package:flutter/material.dart';
import '../../../../data_app/model/knowledge_base/assistant_model.dart';
import '../../../../data_app/repository/knowledge_base/assistant_repository.dart';
import '../../../../data_app/model/jarvis/prompt_model.dart';
import '../../../../data_app/repository/jarvis/prompt_repository.dart';
import '../../../../data_app/model/base/base_model.dart';
import "knowledge_base_list_screen.dart";

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
  bool _isLoadingKnowledges = false;

  @override
  void initState() {
    super.initState();
    _currentAssistant = widget.assistant;
    _nameController.text = _currentAssistant.assistantName;
    _instructionsController.text = _currentAssistant.instructions ?? '';
    _descriptionController.text = _currentAssistant.description ?? '';
    _messageController.addListener(_handleTextChange);
    _fetchImportedKnowledges();
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
      // Fetch both public and private prompts
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

  Future<void> _removeKnowledge(String knowledgeId) async {
    try {
      setState(() => _isLoading = true);
      
      final params = KnowledgeToAssistant(
        knowledgeId: knowledgeId,
        assistantId: _currentAssistant.id,
      );
      
      await AssistantRepository().removeKnowledge(params);
      await _fetchImportedKnowledges(); // Refresh the list
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Knowledge base removed successfully')),
      );
    } catch (e) {
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
        top: offset.dy - 200, // Position above the input field
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
        
        Navigator.pop(context); // Close dialog
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

  Future<void> _createNewThread() async {
    setState(() => _isSending = true);
    try {
      final request = ThreadAssistant(assistantId: _currentAssistant.id);
      final response = await AssistantRepository().createThread(request);
      setState(() {
        _currentThreadId = response.openAiThreadId;
        _messages = [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create thread: $e')),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    if (_currentThreadId == null) {
      await _createNewThread();
      if (_currentThreadId == null) return;
    }

    final message = _messageController.text;
    _messageController.clear();

    setState(() {
      _messages.add(RetrieveMessageOfThreadResponse(
        role: 'user',
        createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        content: [
          MessageContent(
            type: 'text',
            text: MessageText(
              value: message,
              annotations: [],
            ),
          ),
        ],
      ));
      _isSending = true;
    });

    try {
      final request = AskAssistant(
        message: message,
        openAiThreadId: _currentThreadId!,
        additionalInstruction: _currentAssistant.instructions ?? '',
      );

      await AssistantRepository().askAssistant(_currentAssistant.id, request);
      
      // Fetch the updated messages
      final updatedMessages = await AssistantRepository()
          .retrieveMessageOfThread(_currentThreadId!);
      
      setState(() {
        _messages = updatedMessages;
        _isSending = false;
      });
    } catch (e) {
      setState(() => _isSending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
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
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildKnowledgeTab(),
                _buildPreviewTab(),
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
        onTap: () => setState(() => _selectedIndex = index),
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
    
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Preview the assistant\'s responses in a chat interface.',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
              if (_messages.isNotEmpty)
                Container(
                  height: 36,
                  margin: const EdgeInsets.only(left: 8),
                  child: OutlinedButton.icon(
                    onPressed: _isSending ? null : _createNewThread,
                    icon: _isSending
                        ? SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.add,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                    label: Text(
                      'New Thread',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      side: BorderSide(color: theme.colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: _messages.isEmpty
              ? Container(
                  color: Colors.grey[50],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No messages yet',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start a conversation to test your bot!',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  color: Colors.grey[50],
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(_messages[index]);
                    },
                    reverse: true, // This will make newest messages appear at the bottom
                  ),
                ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, -4),
                blurRadius: 16,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: CompositedTransformTarget(
                    link: _layerLink,
                    child: TextField(
                      controller: _messageController,
                      maxLines: 5,
                      minLines: 1,
                      enabled: !_isSending,
                      decoration: InputDecoration(
                        hintText: 'Ask me anything, press \'/\' for prompts...',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _isSending ? null : _sendMessage,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _isSending
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.colorScheme.primary,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.send_rounded,
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}