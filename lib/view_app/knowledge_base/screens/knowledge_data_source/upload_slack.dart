import 'package:advancedmobile_chatai/data_app/model/knowledge_base/knowledge_data_source_model_v2.dart';
import 'package:advancedmobile_chatai/data_app/repository/knowledge_base/knowledge_data_source_repository_v2.dart';
import 'package:advancedmobile_chatai/view_app/knowledge_base/widgets/custom_text_form.dart';
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
  // final _slackWorkspace = TextEditingController();
  final _slackBotToken = TextEditingController();
  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    // _slackWorkspace.addListener(_validateForm);
    _slackBotToken.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.removeListener(_validateForm);
    // _slackWorkspace.removeListener(_validateForm);
    _nameController.dispose();
    // _slackWorkspace.dispose();
    _slackBotToken.removeListener(_validateForm);
    _slackBotToken.dispose();
    super.dispose();
  }

  void _validateForm() {
    final name = _nameController.text.trim();
    // final slackWorkspace = _slackWorkspace.text.trim();
    final slackBotToken = _slackBotToken.text.trim();

    // final uri = Uri.tryParse(slackWorkspace);
    // final isValidUrl = uri != null && uri.hasScheme && uri.hasAuthority;

    final isSlackBotTokenValid = slackBotToken.isNotEmpty;

    final isValid = name.isNotEmpty && isSlackBotTokenValid;

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
                CustomTextFormField(
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
                CustomTextFormField(
                  label: 'Slack Bot Token',
                  controller: _slackBotToken,
                  obscureText: true,
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
                    helpUrl:
                        'https://jarvis.cx/help/knowledge-base/connectors/slack'),
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



  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final credentials = SlackCredentials(
        token: _slackBotToken.text.trim(),
      );
      final request = SlackDatasource(
        type: 'slack',
        name: _nameController.text.trim(),
        credentials: credentials,
      );
      final dataSourceRequest = SlackDatasourceWrapper(datasources: [request]);

      try {
        await KnowledgeDataRepository()
            .uploadSlack(widget.id, dataSourceRequest);
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
