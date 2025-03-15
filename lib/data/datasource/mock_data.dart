import 'package:advancedmobile_chatai/model/prompt.dart';
import 'package:flutter/material.dart';

final List<Map<String, dynamic>> knowledgeSources = [
  {
    'title': 'AI Research',
    'description': 'Papers and articles about AI',
    'icon': Icons.science,
  },
  {
    'title': 'Programming Tutorials',
    'description': 'Guides on Flutter and Dart',
    'icon': Icons.code,
  },
  {
    'title': 'General Knowledge',
    'description': 'Wikipedia-style information',
  },
];

class MockData {
  static final List<String> tabs = ['Public Prompts', 'My Prompts'];

  static final List<Category> categories = [
    Category(name: 'All', isSelected: true),
    Category(name: 'Marketing', isSelected: false),
    Category(name: 'Business', isSelected: false),
    Category(name: 'SEO', isSelected: false),
    Category(name: 'Writing', isSelected: false),
    Category(name: 'Coding', isSelected: false),
    Category(name: 'Career', isSelected: false),
    Category(name: 'Chatbot', isSelected: false),
    Category(name: 'Education', isSelected: false),
  ];

  static final List<Prompt> prompts = [
    Prompt(
      title: 'Grammar corrector',
      description: 'Improve your spelling and grammar by correcting errors in your writing.',
      category: 'Writing',
      isFavorite: false,
    ),
    Prompt(
      title: 'Learn Code FAST!',
      description: 'Teach you the code with the most understandable knowledge.',
      category: 'Coding',
      isFavorite: false,
    ),
    Prompt(
      title: 'Story generator',
      description: 'Write your own beautiful story.',
      category: 'Writing',
      isFavorite: false,
    ),
    Prompt(
      title: 'Essay improver',
      description: 'Improve your content\'s effectiveness with ease.',
      category: 'Writing',
      isFavorite: false,
    ),
    Prompt(
      title: 'Pro tips generator',
      description: 'Get perfect tips and advice tailored to your field with this prompt!',
      category: 'Career',
      isFavorite: false,
    ),
    Prompt(
      title: 'Resume Editing',
      description: 'Provide suggestions on how to improve your resume to make it stand out.',
      category: 'Career',
      isFavorite: false,
    ),
  ];
}

final List<Map<String, String>> mockPrompts = [
  {
    'name': 'Ho Chi Minh\'s ideology',
    'prompt': 'Explain Ho Chi Minh\'s ideology and its impact on Vietnam.'
  },
  {
    'name': 'Artificial Intelligence',
    'prompt': 'Describe the impact of AI on modern technology and daily life.'
  },
  {
    'name': 'Climate Change',
    'prompt': 'Discuss the causes and effects of climate change globally.'
  },
  {
    'name': 'Space Exploration',
    'prompt': 'What are the latest advancements in space exploration?'
  },
];

final List<Map<String, dynamic>> aiModels = [
  {
    "name": "GPT-3",
    "description": "OpenAI's powerful language model",
    "isSelected": true,
  },
  {
    "name": "BERT",
    "description": "Bidirectional Encoder Representations from Transformers",
    "isSelected": false,
  },
  {
    "name": "T5",
    "description": "Text-to-Text Transfer Transformer",
    "isSelected": false,
  },
  {
    "name": "DALL-E",
    "description": "Text-to-Image Transformer",
    "isSelected": false,
  },
  {
    "name": "CLIP",
    "description": "Contrastive Language-Image Pre-training",
    "isSelected": false,
  },
];

List<Map<String, dynamic>> messages = [
  {"text": "Hello, JARVIS!", "isUser": true},
  {"text": "Hi! How can I help you?", "isUser": false},
  {"text": "What's the weather today?", "isUser": true},
  {"text": "The weather is sunny with a high of 30°C.", "isUser": false},
  {"text": "Tell me a joke!", "isUser": true},
  {"text": "Why don't skeletons fight each other? Because they don't have the guts! 😆", "isUser": false},
  {"text": "Hello, JARVIS!", "isUser": true},
  {"text": "Hi! How can I help you?", "isUser": false},
  {"text": "What's the weather today?", "isUser": true},
  {"text": "The weather is sunny with a high of 30°C.", "isUser": false},
  {"text": "Tell me a joke!", "isUser": true},
  {"text": "Why don't skeletons fight each other? Because they don't have the guts! 😆", "isUser": false},
  {"text": "Hello, JARVIS!", "isUser": true},
  {"text": "Hi! How can I help you?", "isUser": false},
  {"text": "What's the weather today?", "isUser": true},
  {"text": "The weather is sunny with a high of 30°C.", "isUser": false},
  {"text": "Tell me a joke!", "isUser": true},
  {"text": "Why don't skeletons fight each other? Because they don't have the guts! 😆", "isUser": false},
  {"text": "Hello, JARVIS!", "isUser": true},
  {"text": "Hi! How can I help you?", "isUser": false},
  {"text": "What's the weather today?", "isUser": true},
  {"text": "The weather is sunny with a high of 30°C.", "isUser": false},
  {"text": "Tell me a joke!", "isUser": true},
  {"text": "Why don't skeletons fight each other? Because they don't have the guts! 😆", "isUser": false},
  {"text": "Hello, JARVIS!", "isUser": true},
  {"text": "Hi! How can I help you?", "isUser": false},
  {"text": "What's the weather today?", "isUser": true},
  {"text": "The weather is sunny with a high of 30°C.", "isUser": false},
  {"text": "Tell me a joke!", "isUser": true},
  {"text": "Why don't skeletons fight each other? Because they don't have the guts! 😆", "isUser": false},
];
