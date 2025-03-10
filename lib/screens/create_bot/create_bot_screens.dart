import 'package:flutter/material.dart';
import '../../data/datasource/mock_data.dart';
import '../knowledge_source/knowledge_source.dart';

class CreateYourOwnBotScreen extends StatefulWidget {
  const CreateYourOwnBotScreen({super.key});

  @override
  State<CreateYourOwnBotScreen> createState() => _CreateYourOwnBotScreenState();
}

class _CreateYourOwnBotScreenState extends State<CreateYourOwnBotScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _knowledgebaseController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    _knowledgebaseController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormField(
                label: 'Name',
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
              const SizedBox(height: 16),

              // Knowledge Base Section
              const Text(
                'Knowledge Base (Optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                'Enhance your bot\'s responses by adding custom knowledge.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),

              // Add Knowledge Source Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _showKnowledgeSourceModal(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add),
                      const SizedBox(width: 8),
                      Text(
                        'Add Knowledge Source',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    // Create Button
                    FilledButton(
                      onPressed: _submitForm,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Create Bot'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // Form field widget
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
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          maxLines: maxLines,
          validator: validator,
        ),
      ],
    );
  }

  // Handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bot created successfully')),
      );
      Navigator.pop(context);
    }
  }

  // Show knowledge source modal
  void _showKnowledgeSourceModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return KnowledgeSource(
          knowledgeSources: knowledgeSources,
        );
      },
    );
  }
}
