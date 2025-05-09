import 'package:advancedmobile_chatai/data_app/model/knowledge_base/knowledge_data_source_model.dart';
import 'package:advancedmobile_chatai/data_app/repository/knowledge_base/knowledge_data_source_repository.dart';
import 'package:advancedmobile_chatai/view_app/knowledge_base/widgets/notice.dart';
import 'package:flutter/material.dart';

class UploadSlackScreen extends StatefulWidget {
  final VoidCallback? onSuccess;
  final String id;

  const UploadSlackScreen({
    super.key,
    this.onSuccess,
    required this.id,
  });

  @override
  State<UploadSlackScreen> createState() => _UploadSlackScreenState();
}

class _UploadSlackScreenState extends State<UploadSlackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _slackWorkspace = TextEditingController();
  final _slackBotToken = TextEditingController();
  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _slackWorkspace.addListener(_validateForm);
    _slackBotToken.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.removeListener(_validateForm);
    _slackWorkspace.removeListener(_validateForm);
    _nameController.dispose();
    _slackWorkspace.dispose();
    _slackBotToken.removeListener(_validateForm);
    _slackBotToken.dispose();
    super.dispose();
  }

  void _validateForm() {
    final name = _nameController.text.trim();
    final slackWorkspace = _slackWorkspace.text.trim();
    final slackBotToken = _slackBotToken.text.trim();

    final uri = Uri.tryParse(slackWorkspace);
    final isValidUrl = uri != null && uri.hasScheme && uri.hasAuthority;

    final isSlackBotTokenValid = slackBotToken.isNotEmpty;

    final isValid = name.isNotEmpty && isValidUrl && isSlackBotTokenValid;

    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormField(
                  label: 'Name',
                  controller: _nameController,
                  hintText: 'Enter knowledge unit name...',
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter knowledge unit name';
                    }
                    return null;
                  },
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                _buildFormField(
                  label: 'Slack Workspace',
                  controller: _slackWorkspace,
                  hintText: 'Enter Slack Workspace',
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Slack Workspace URL';
                    }

                    return null;
                  },
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                _buildFormField(
                  label: 'Slack Bot Token',
                  controller: _slackBotToken,
                  hintText: 'Enter Slack Bot Token',
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Slack Bot Token';
                    }

                    return null;
                  },
                  maxLines: 1,
                ),
                const SizedBox(height: 16),
                const PageLimitNotice(
                  helpUrl: 'https://jarvis.cx/help/knowledge-base/connectors/slack'),
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
                        onPressed:
                            (_isLoading || !_isFormValid) ? null : _submitForm,
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
                            : const Text('Import'),
                      ),
                    ],
                  ),
                ),
              ],
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
    bool isRequired = false,
    int? maxLines,
    String? Function(String?)? validator,
    int? maxLength,
    int? currentLength,
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
        Container(
          constraints: (maxLines ?? 1) == 1
              ? const BoxConstraints(maxHeight: 40)
              : null,

          child:    Stack(
            children: [
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 0,
                  ),
                ),
                maxLines: maxLines,
                maxLength: maxLength,

                buildCounter: (_,
                    {required currentLength,
                      required isFocused,
                      maxLength}) =>
                null,
                validator: validator,
              ),
              if (maxLength != null && currentLength != null)
                Positioned(
                  right: 8,
                  bottom: 4,
                  child: Text(
                    '$currentLength/$maxLength',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.grey),
                  ),
                ),
            ],

          ),
        ),
      ],
    );
  }


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final request = UpLoadFileSlack(
        unitName: _nameController.text.trim(),
        slackWorkspace: _slackWorkspace.text.trim(),
        slackBotToken: _slackBotToken.text.trim(),
      );

      try {
        await KnowledgeDataRepository().uploadSlack(widget.id, request);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Knowledge source added successfully')),
        );
        widget.onSuccess?.call();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add knowledge source')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}
