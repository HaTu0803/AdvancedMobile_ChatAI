import 'package:advancedmobile_chatai/screens/prompt_library/prompt_item/prompt_item.dart';
import 'package:flutter/material.dart';
import '../../../data/datasource/mock_data.dart';
import '../../../model/prompt.dart';

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

  late List<Category> _categories;
  late List<Prompt> _prompts;

  @override
  void initState() {
    super.initState();
    _categories = List.from(MockData.categories);
    _prompts = List.from(MockData.prompts);
    _filterPrompts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPrompts() {
    setState(() {
      _filteredPrompts = _prompts.where((prompt) {
        final matchesCategory = _selectedCategory == 'All' || prompt.category == _selectedCategory;
        final matchesSearch = prompt.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            prompt.description.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),

              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              children: _categories.map((category) => _buildCategoryItem(category)).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemCount: _filteredPrompts.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final prompt = _filteredPrompts[index];
                return PromptItem(
                  prompt: prompt,
                  onFavoriteToggle: () => _toggleFavorite(index),
                  onInfoTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Info for ${prompt.title}')),
                    );
                  },
                  onUse: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Using ${prompt.title}')),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(Category category) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () => _selectCategory(category.name),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: category.isSelected ? Theme.of(context).primaryColor : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            category.name,
            style: TextStyle(
              color: category.isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
