import 'package:flutter/material.dart';

import '../../../model/prompt.dart';

class PromptItem extends StatelessWidget {
  final Prompt prompt;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onInfoTap;
  final VoidCallback onUse;

  const PromptItem({
    super.key,
    required this.prompt,
    required this.onFavoriteToggle,
    required this.onInfoTap,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prompt.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  prompt.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  prompt.isFavorite ? Icons.star : Icons.star_border,
                  color: prompt.isFavorite ? Colors.amber : Colors.grey.shade400,
                ),
                onPressed: onFavoriteToggle,
              ),
              IconButton(
                icon: Icon(Icons.info_outline, color: Colors.grey.shade400),
                onPressed: onInfoTap,
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
                onPressed: onUse,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

