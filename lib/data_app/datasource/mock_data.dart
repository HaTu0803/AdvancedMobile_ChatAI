import 'package:advancedmobile_chatai/data_app/model/jarvis/prompt_model.dart';
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

  static final List<PromptCategory> categories = [
    PromptCategory(id : '1', name: 'All', isSelected: true),
    PromptCategory(id : '1', name: 'Marketing', isSelected: false),
    PromptCategory(id : '1', name: 'Business', isSelected: false),
    PromptCategory(id : '1', name: 'SEO', isSelected: false),
    PromptCategory(id : '1', name: 'Writing', isSelected: false),
    PromptCategory(id : '1', name: 'Coding', isSelected: false),
    PromptCategory(id : '1', name: 'Career', isSelected: false),
    PromptCategory(id : '1', name: 'Chatbot', isSelected: false),
    PromptCategory(id : '1', name: 'Education', isSelected: false),
    PromptCategory(id : '1', name: 'Fun', isSelected: false),
    PromptCategory(id : '1', name: 'Productivity', isSelected: false),
    PromptCategory(id : '1', name: 'Other', isSelected: false),
  ];

  static final List<Prompt> prompts = [
    Prompt(id : '1', 
      title: 'Grammar corrector',
      description:
          'Improve your spelling and grammar by correcting errors in your writing.',
      category: 'Writing',
      isFavorite: false,
      updatedAt: DateTime.now(), // Thêm trường updatedAt
      content: 'Improve your writing with the help of grammar correction.',
      isPublic: true, // Thêm trường isPublic
      language: 'English', // Thêm trường language
      userId: 'user_001', // Thêm trường userId
      userName: 'John Doe', // Thêm trường userName
      createdAt: DateTime.parse('2023-01-01T12:00:00Z'),
    ),
    Prompt(id : '1', 
      title: 'Learn Code FAST!',
      description: 'Teach you the code with the most understandable knowledge.',
      category: 'Coding',
      isFavorite: false,
      updatedAt: DateTime.now(), // Thêm trường updatedAt
      content: 'Learn coding quickly with expert guidance.',
      isPublic: true, // Thêm trường isPublic
      language: 'English', // Thêm trường language
      userId: 'user_002', // Thêm trường userId
      userName: 'Jane Smith', // Thêm trường userName
      createdAt: DateTime.parse('2023-02-01T12:00:00Z'),
    ),
    Prompt(id : '1', 
      title: 'Story generator',
      description: 'Write your own beautiful story.',
      category: 'Writing',
      isFavorite: false,
      updatedAt: DateTime.now(), // Thêm trường updatedAt
      content: 'Generate creative stories with unique plots.',
      isPublic: true, // Thêm trường isPublic
      language: 'English', // Thêm trường language
      userId: 'user_003', // Thêm trường userId
      userName: 'Alice Brown', // Thêm trường userName
      createdAt: DateTime.parse('2023-03-01T12:00:00Z'),
    ),
    Prompt(id : '1', 
      title: 'Essay improver',
      description: 'Improve your content\'s effectiveness with ease.',
      category: 'Writing',
      isFavorite: false,
      updatedAt: DateTime.now(), // Thêm trường updatedAt
      content: 'Enhance your essays with better structure and clarity.',
      isPublic: true, // Thêm trường isPublic
      language: 'English', // Thêm trường language
      userId: 'user_004', // Thêm trường userId
      userName: 'Bob Johnson', // Thêm trường userName
      createdAt: DateTime.parse('2023-04-01T12:00:00Z'),
    ),
    Prompt(id : '1', 
      title: 'Pro tips generator',
      description:
          'Get perfect tips and advice tailored to your field with this prompt!',
      category: 'Career',
      isFavorite: false,
      updatedAt: DateTime.now(), // Thêm trường updatedAt
      content: 'Receive expert career tips that match your profession.',
      isPublic: true, // Thêm trường isPublic
      language: 'English', // Thêm trường language
      userId: 'user_005', // Thêm trường userId
      userName: 'Emma Wilson', // Thêm trường userName
      createdAt: DateTime.parse('2023-05-01T12:00:00Z'),
    ),
    Prompt(id : '1', 
      title: 'Resume Editing',
      description:
          'Provide suggestions on how to improve your resume to make it stand out.',
      category: 'Career',
      isFavorite: false,
      updatedAt: DateTime.now(), // Thêm trường updatedAt
      content: 'Get feedback and improve your resume to land the job.',
      isPublic: true, // Thêm trường isPublic
      language: 'English', // Thêm trường language
      userId: 'user_006', // Thêm trường userId
      userName: 'Chris Lee', // Thêm trường userName
      createdAt: DateTime.parse('2023-06-01T12:00:00Z'),
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
  {
    "text":
        "Why don't skeletons fight each other? Because they don't have the guts! 😆",
    "isUser": false
  },
  {"text": "Hello, JARVIS!", "isUser": true},
  {"text": "Hi! How can I help you?", "isUser": false},
  {"text": "What's the weather today?", "isUser": true},
  {"text": "The weather is sunny with a high of 30°C.", "isUser": false},
  {"text": "Tell me a joke!", "isUser": true},
  {
    "text":
        "Why don't skeletons fight each other? Because they don't have the guts! 😆",
    "isUser": false
  },
  {"text": "Hello, JARVIS!", "isUser": true},
  {"text": "Hi! How can I help you?", "isUser": false},
  {"text": "What's the weather today?", "isUser": true},
  {"text": "The weather is sunny with a high of 30°C.", "isUser": false},
  {"text": "Tell me a joke!", "isUser": true},
  {
    "text":
        "Why don't skeletons fight each other? Because they don't have the guts! 😆",
    "isUser": false
  },
  {"text": "Hello, JARVIS!", "isUser": true},
  {"text": "Hi! How can I help you?", "isUser": false},
  {"text": "What's the weather today?", "isUser": true},
  {"text": "The weather is sunny with a high of 30°C.", "isUser": false},
  {"text": "Tell me a joke!", "isUser": true},
  {
    "text":
        "Why don't skeletons fight each other? Because they don't have the guts! 😆",
    "isUser": false
  },
  {"text": "Hello, JARVIS!", "isUser": true},
  {"text": "Hi! How can I help you?", "isUser": false},
  {"text": "What's the weather today?", "isUser": true},
  {"text": "The weather is sunny with a high of 30°C.", "isUser": false},
  {"text": "Tell me a joke!", "isUser": true},
  {
    "text":
        "Why don't skeletons fight each other? Because they don't have the guts! 😆",
    "isUser": false
  },
];
