import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/datasource/mock_data.dart';

class AIModelSelection extends StatefulWidget {
  @override
  _AIModelSelectionState createState() => _AIModelSelectionState();
}

class _AIModelSelectionState extends State<AIModelSelection> {
  String? selectedModel = "GPT-3";

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        selectedModel ?? "Select AI Model",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: aiModels.map((model) {
        bool isSelected = model["name"] == selectedModel;
        return ListTile(
          title: Text(model["name"]!),
          subtitle: Text(model["description"]!),
          trailing: isSelected ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary) : null,
          onTap: () {
            setState(() {
              selectedModel = model["name"];
            });
          },
        );
      }).toList(),
    );
  }
}
