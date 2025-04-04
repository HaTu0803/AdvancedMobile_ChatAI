import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  late List<Category> _categories = [];
  late List<Prompt> _prompts = [];

  @override
  void initState() {
    super.initState();
    _fetchPromptsFromApi();  // Gọi API ngay khi màn hình được hiển thị
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPromptsFromApi() async {
    try {
      final promptProvider = Provider.of<PromptProvider>(context, listen: false);
      await promptProvider.fetchPrompts();

      // Lấy danh sách prompts và categories từ provider
      final prompts = promptProvider.prompts?.items ?? [];
      print(promptProvider.prompts);
      // Dữ liệu categories giả định, bạn có thể lấy từ API
      final List<Category> categories = [
        Category(name: 'All', isSelected: true, id: 'all'),
        Category(name: 'Science', isSelected: false, id: 'science'),
        Category(name: 'Technology', isSelected: false, id: 'technology'),
        Category(name: 'Art', isSelected: false, id: 'art'),
      ];

      setState(() {
         _prompts = prompts.map((data) => Prompt(
            id: data.id,
            title: data.title ?? '',
            description: data.description ?? '',
            category: data.category ?? '', 
            isFavorite: data.isFavorite ?? false,
            createdAt: DateTime.parse(data.createdAt), // Chuyển đổi createdAt từ String sang DateTime
            updatedAt: DateTime.parse(data.updatedAt), // Cũng chuyển updatedAt từ String sang DateTime
            content: data.content ?? '', 
            isPublic: data.isPublic ?? false, 
            language: data.language ?? '',
            userId: data.userId ?? '', 
            userName: data.userName ?? '', 
          )).toList();

        _categories = categories;
        _filterPrompts();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prompts fetched successfully')),
        );
      }
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
      appBar: AppBar(title: const Text('Public Prompts')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                ElevatedButton.icon(
                  onPressed: _fetchPromptsFromApi,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Call API'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              children: _categories
                  .map((category) => _buildCategoryItem(category))
                  .toList(),
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
            color: category.isSelected
                ? Theme.of(context).primaryColor
                : const Color(0xFFF5F5F5),
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
