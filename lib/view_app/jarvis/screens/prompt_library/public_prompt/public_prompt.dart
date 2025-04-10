import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; // Import for Clipboard

import '../../../../../data_app/model/jarvis/prompt_model.dart';
import '../../../../../providers/prompt_provider.dart';

class PublicPromptsScreen extends StatefulWidget {
  const PublicPromptsScreen({super.key});

  @override
  State<PublicPromptsScreen> createState() => _PublicPromptsScreenState();
}

class _PublicPromptsScreenState extends State<PublicPromptsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<Prompt> _filteredPrompts = [];
  String _searchQuery = '';
  bool _isStarred = false;

  late List<PromptCategory> _categories = [];
  late List<Prompt> _prompts = [];

  @override
  void initState() {
    super.initState();
    _fetchPromptsFromApi();
    print("Categories from API:");
    _categories.forEach((category) {
      print("Category: ${category.name}, ID: ${category.id}");
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPromptsFromApi() async {
    try {
      final promptProvider = Provider.of<PromptProvider>(context, listen: false);
      await Future.wait([
        promptProvider.fetchPrompts(),
        promptProvider.fetchCategories(),
      ]);

      // Lấy danh sách prompts và categories từ provider
      final prompts = promptProvider.prompts?.items ?? [];
      print(promptProvider.prompts);
      
      setState(() {
        _prompts = prompts.map((data) => Prompt(
            id: data.id,
            title: data.title ?? '',
            description: data.description ?? '',
            category: data.category ?? '', 
            isFavorite: data.isFavorite ?? false,
            createdAt: DateTime.parse(data.createdAt),
            updatedAt: DateTime.parse(data.updatedAt),
            content: data.content ?? '', 
            isPublic: data.isPublic ?? false, 
            language: data.language ?? '',
            userId: data.userId ?? '', 
            userName: data.userName ?? '', 
          )).toList();

        _categories = promptProvider.categories;
        _filterPrompts();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching prompts: $e')),
        );
      }
    }
  }

  void _filterPrompts() {
    setState(() {
      _filteredPrompts = _prompts.where((prompt) {
        final matchesCategory =
            _selectedCategory == 'All' || prompt.category.contains(_selectedCategory);
        final matchesSearch =
            prompt.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                prompt.description
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
        final matchesFavorite = !_isStarred || prompt.isFavorite;
        return matchesCategory && matchesSearch && matchesFavorite;
      }).toList();
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      for (var cat in _categories) {
        cat.isSelected = cat.name == category;
      }
      _filterPrompts();
    });
  }

  void _toggleFavorite(int index) {
    final promptIndex = _prompts.indexOf(_filteredPrompts[index]);
    if (promptIndex != -1) {
      setState(() {
        _prompts[promptIndex].isFavorite = !_prompts[promptIndex].isFavorite;
        _filterPrompts();
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterPrompts();
    });
  }

  void _showPromptDetails(BuildContext context, Prompt prompt, Function onToggleFavorite) {
    final buttonColor = const Color(0xFF7B68EE); // Use the same color as Public Prompts

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Text(prompt.title),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.star,
                      color: prompt.isFavorite ? Colors.yellow : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        prompt.isFavorite = !prompt.isFavorite;
                      });
                      onToggleFavorite();
                    },
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${prompt.category} · ${prompt.userName}',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    prompt.description,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Prompt',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: prompt.content));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Content copied to clipboard')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity, // Ensures consistent width
                    child: Container(
                      height: 120,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        child: Text(prompt.content),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    side: BorderSide(color: buttonColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: buttonColor),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle "Use this prompt" action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text('Use this prompt'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.star,
                      color: _isStarred ? Colors.yellow : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isStarred = !_isStarred;
                        _filterPrompts();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildCategoriesList(),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _filteredPrompts.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final prompt = _filteredPrompts[index];
                return PromptItem(
                  id: prompt.id,
                  createdAt: prompt.createdAt.toString(),
                  updatedAt: prompt.updatedAt.toString(),
                  category: prompt.category,
                  content: prompt.content,
                  description: prompt.description,
                  isPublic: prompt.isPublic,
                  language: prompt.language,
                  title: prompt.title,
                  userId: prompt.userId,
                  userName: prompt.userName,
                  isFavorite: prompt.isFavorite,
                  onToggleFavorite: () => _toggleFavorite(index),
                  showDetails: _showPromptDetails,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(PromptCategory category) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () => _selectCategory(category.name),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: category.isSelected
                ? const Color(0xFF7B68EE)
                : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(25),
            boxShadow: category.isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF7B68EE).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Text(
            category.name,
            style: TextStyle(
              color: category.isSelected ? Colors.white : Colors.black87,
              fontWeight: category.isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesList() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: _categories
            .map((category) => _buildCategoryItem(category))
            .toList(),
      ),
    );
  }
}