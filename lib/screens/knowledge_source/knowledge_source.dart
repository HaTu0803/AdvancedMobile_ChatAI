import 'package:flutter/material.dart';
import 'knowledge_source_detail.dart';  // Import the KnowledgeDetailScreen

class KnowledgeSource extends StatelessWidget {
  final List<Map<String, dynamic>> knowledgeSources;

  const KnowledgeSource({super.key, required this.knowledgeSources});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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

            // Knowledge Sources List
            Expanded(
              child: ListView.builder(
                itemCount: knowledgeSources.length,
                itemBuilder: (context, index) {
                  final source = knowledgeSources[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(source['icon'] ?? Icons.book, color: Colors.blue),
                      ),
                      title: Text(
                        source['title'] ?? 'No Title',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(source['description'] ?? 'No Description'),
                      trailing: const Icon(Icons.arrow_right_alt),
                      onTap: () {
                        // Open KnowledgeDetailScreen as a dialog
                        showDialog(
                          context: context,
                          builder: (context) => KnowledgeDetailScreen(source: source),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
