import 'package:flutter/material.dart';

class EmailComposeScreen extends StatefulWidget {
  const EmailComposeScreen({super.key});

  @override
  State<EmailComposeScreen> createState() => _EmailComposeScreenState();
}

class _EmailComposeScreenState extends State<EmailComposeScreen> {
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void dispose() {
    _toController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compose Email'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              // TODO: Implement send email functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _toController,
              decoration: const InputDecoration(
                labelText: 'To',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _bodyController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  labelText: 'Body',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 