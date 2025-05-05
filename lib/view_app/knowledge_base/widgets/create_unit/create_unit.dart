// lib/widgets/create_knowledge_modal.dart
import 'package:advancedmobile_chatai/view_app/knowledge_base/screens/knowledge_data_source/upload_file.dart';
import 'package:flutter/material.dart';

class CreateKnowledgeModal extends StatelessWidget {
  final String knowledgeId;

  const CreateKnowledgeModal({super.key, required this.knowledgeId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
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
                      onPressed: () => Navigator.pop(context),
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
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) =>
                          ImportLocalFilesDialog(id: knowledgeId),
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
                    Navigator.pop(context);
                    // TODO: Open website upload screen
                  },
                ),
                _buildSourceItem(
                  context,
                  title: 'Slack',
                  subtitle: 'Connect to Slack Workspace',
                  imagePath: 'images/slack.png',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Open Slack connect screen
                  },
                ),
                _buildSourceItem(
                  context,
                  title: 'Confluence',
                  subtitle: 'Connect to Confluence',
                  imagePath: 'images/confluence.png',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Open Confluence connect screen
                  },
                ),
                const Divider(height: 32),
                _buildComingSoonItem(context,
                    title: 'Google Drive',
                    imagePath: 'images/google_drive.png'),
                _buildComingSoonItem(context,
                    title: 'Github Repository', imagePath: 'images/github.png'),
                _buildComingSoonItem(context,
                    title: 'Gitlab Repository', imagePath: 'images/gitlab.png'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSourceItem(BuildContext context,
      {required String title,
      required String subtitle,
      required String imagePath,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 240, 248, 255),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Image.asset(imagePath, width: 20, height: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          )),
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 240, 248, 255),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Image.asset(imagePath, width: 20, height: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child:
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
            ),
            const Icon(Icons.lock, size: 16),
          ],
        ),
      ),
    );
  }
}
