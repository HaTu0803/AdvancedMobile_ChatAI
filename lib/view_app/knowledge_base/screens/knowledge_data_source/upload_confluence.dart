import 'package:advancedmobile_chatai/data_app/model/knowledge_base/knowledge_data_source_model_v2.dart';
import 'package:advancedmobile_chatai/data_app/repository/knowledge_base/knowledge_data_source_repository_v2.dart';
import 'package:advancedmobile_chatai/view_app/knowledge_base/widgets/notice.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_text_form.dart';

class UploadConfluenceScreen extends StatefulWidget {
  final VoidCallback? onSuccess;
  final String id;

  const UploadConfluenceScreen({
    super.key,
    this.onSuccess,
    required this.id,
  });

  @override
  State<UploadConfluenceScreen> createState() => _UploadConfluenceScreenState();
}

class _UploadConfluenceScreenState extends State<UploadConfluenceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _wikiPageUrl = TextEditingController();
  final _confluenceUsername = TextEditingController();
  final _confluenceAccessToken = TextEditingController();
  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _wikiPageUrl.addListener(_validateForm);
    _confluenceUsername.addListener(_validateForm);
    _confluenceAccessToken.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.removeListener(_validateForm);
    _wikiPageUrl.removeListener(_validateForm);
    _nameController.dispose();
    _wikiPageUrl.dispose();
    _confluenceUsername.removeListener(_validateForm);
    _confluenceUsername.dispose();
    _confluenceAccessToken.removeListener(_validateForm);
    _confluenceAccessToken.dispose();
    super.dispose();
  }

  void _validateForm() {
    final name = _nameController.text.trim();
    final wikiPageUrl = _wikiPageUrl.text.trim();
    final confluenceUsername = _confluenceUsername.text.trim();
    final confluenceAccessToken = _confluenceAccessToken.text.trim();

    final uri = Uri.tryParse(wikiPageUrl);
    final isValidUrl = uri != null && uri.hasScheme && uri.hasAuthority;

    final isUsernameValid = confluenceUsername.isNotEmpty;
    final isAccessTokenValid = confluenceAccessToken.isNotEmpty;

    final isValid =
        name.isNotEmpty && isValidUrl && isUsernameValid && isAccessTokenValid;

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
                  label: 'Wiki Page URL',
                  controller: _wikiPageUrl,
                  hintText: 'https:/your-domain.atlassian.net',
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a URL';
                    }

                    final uri = Uri.tryParse(value);
                    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
                      return 'Please enter a valid URL';
                    }

                    return null;
                  },
                  maxLines: 1,
                ),
                const SizedBox(height: 8),

                CustomTextFormField(
                  label: 'Username',
                  controller: _confluenceUsername,
                  hintText: 'Enter your Confluence username...',
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Confluence username';
                    }
                    return null;
                  },
                  maxLines: 1,
                ),
                const SizedBox(height: 8),

                CustomTextFormField(
                  label: 'API Token',
                  controller: _confluenceAccessToken,
                  hintText: 'Enter your Confluence API token...',
                  isRequired: true,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Confluence API token';
                    }
                    return null;
                  },
                  maxLines: 1,
                ),
                const SizedBox(height: 16),
                const PageLimitNotice(
                    helpUrl: 'https://jarvis.cx/help/knowledge-base/connectors/confluence/'),
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
final credentials = ConfluenceCredentials(
        username: _confluenceUsername.text.trim(),
         url: _wikiPageUrl.text.trim(),
        token: _confluenceAccessToken.text.trim(),
      );
      final request = DataSourceConfluence(
        type: 'confluence',
        name: _nameController.text.trim(),
        credentials: credentials,
      );
      final dataSourceRequest = DataSourcesModel(datasources: [request]);

      try {
        await KnowledgeDataRepository().uploadConfluence(widget.id, dataSourceRequest);
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
