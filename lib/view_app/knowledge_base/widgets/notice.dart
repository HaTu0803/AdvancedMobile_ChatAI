import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PageLimitNotice extends StatelessWidget {
  final String? helpUrl;

  const PageLimitNotice({super.key, this.helpUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Current Limitation:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              InkWell(
                onTap: () async {
                  final Uri url = Uri.parse(helpUrl ?? '');
                  if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
                    debugPrint("Navigated successfully");
                  } else {
                    debugPrint("Could not launch $url");
                  }
                },
                child: Icon(
                  Icons.help_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
              ),
            ],
          ),
          const BulletPoint(text: 'You can load up to 64 pages at a time'),
          const BulletPoint(text: 'Need more? Contact us at hello@jarvis.cx'),
        ],
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14, color: Colors.black)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
