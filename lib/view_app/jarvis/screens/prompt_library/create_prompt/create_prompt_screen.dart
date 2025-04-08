import 'package:flutter/material.dart';
import '../../../../../data_app/model/jarvis/prompt_model.dart';
import '../../../../../data_app/repository/prompt_repository.dart';

class CreatePromptScreen extends StatefulWidget {
  const CreatePromptScreen({super.key});

  @override
  State<CreatePromptScreen> createState() => _CreatePromptScreenState();
}

class _CreatePromptScreenState extends State<CreatePromptScreen> {
  final _formKey = GlobalKey<FormState>();
  final _categoryController = TextEditingController();
  final _contentController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _languageController = TextEditingController();
  final _titleController = TextEditingController();
  bool _isPublic = false;

  @override
  void dispose() {
    _categoryController.dispose();
    _contentController.dispose();
    _descriptionController.dispose();
    _languageController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Prompt'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWarningBanner(),

              const SizedBox(height: 24),

              _buildFormField(
                label: 'Title',
                controller: _titleController,
                hintText: 'Title of the prompt',
                isRequired: true,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Please enter a title'
                    : null,
              ),

              const SizedBox(height: 24),

              _buildFormField(
                label: 'Category',
                controller: _categoryController,
                hintText: 'Category of the prompt',
                isRequired: true,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Please enter a category'
                    : null,
              ),

              const SizedBox(height: 24),

              _buildFormField(
                label: 'Content',
                controller: _contentController,
                hintText: 'Content of the prompt',
                isRequired: true,
                maxLines: 5,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Please enter content'
                    : null,
              ),

              const SizedBox(height: 24),

              _buildFormField(
                label: 'Description',
                controller: _descriptionController,
                hintText: 'Description of the prompt',
                isRequired: true,
                maxLines: 3,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Please enter description'
                    : null,
              ),

              const SizedBox(height: 24),

              _buildFormField(
                label: 'Language',
                controller: _languageController,
                hintText: 'Language of the prompt',
                isRequired: true,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Please enter language'
                    : null,
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  const Text('Is Public'),
                  Switch(
                    value: _isPublic,
                    onChanged: (value) {
                      setState(() {
                        _isPublic = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 40),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: _submitForm,
                      child: const Text('Create'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.amber),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.amber.shade900,
                  fontSize: 14,
                ),
                children: [
                  const TextSpan(text: 'You should '),
                  TextSpan(
                    text: 'login to Jarvis',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: ' to save your prompt. Otherwise, it will be lost.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    bool isRequired = false,
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
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 16,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor:
            Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          maxLines: maxLines,
          validator: validator,
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      debugPrint('Title Test: "${_titleController.text}"');
      debugPrint('Content: "${_contentController.text}"');
      debugPrint('Description: "${_descriptionController.text}"');
      debugPrint('Category: "${_categoryController.text}"');
      debugPrint('Language: "${_languageController.text.trim()}"');
      debugPrint('Is Public: $_isPublic');
      debugPrint('Form submitted successfully');
      final request = CreatePromptRequest(
        category: _categoryController.text.trim(),
        content: _contentController.text.trim(),
        description: _descriptionController.text.trim(),
        isPublic: _isPublic,
        language: _languageController.text.trim(),
        title: _titleController.text.trim(),
      );

      try {
        await PromptRepository().createPrompt(request);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prompt created successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
}
