import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../data_app/model/jarvis/prompt_model.dart';
import '../../../../../data_app/repository/jarvis/prompt_repository.dart';
import '../../../../../providers/prompt_provider.dart';
import '../../../widgets/using_public_prompt.dart';

class PublicPromptsScreen extends StatefulWidget {
  const PublicPromptsScreen({super.key});

  @override
  State<PublicPromptsScreen> createState() => _PublicPromptsScreenState();
}

class _PublicPromptsScreenState extends State<PublicPromptsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _selectedCategory = 'All';
  List<Prompt> _filteredPrompts = [];
  String _searchQuery = '';
  bool _isStarred = false;

  late List<PromptCategory> _categories = [];

  int _itemsPerPage = 10;
  int _offset = 0;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchPrompts(reset: true);

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _fetchPrompts();
    }
  }

  Future<void> _fetchCategories() async {
    final promptProvider = Provider.of<PromptProvider>(context, listen: false);
    await promptProvider.fetchCategories();
    setState(() {
      _categories = promptProvider.categories;
    });
  }

  Future<void> _fetchPrompts({bool reset = false}) async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);

    if (reset) {
      _offset = 0;
      _filteredPrompts.clear();
      _hasMore = true;
    }

    final params = GetPromptRequest(
      query: _searchQuery,
      offset: _offset,
      limit: _itemsPerPage,
      isPublic: true,
      category: _selectedCategory == 'All' ? null : _selectedCategory,
    );

    try {
      final response = await PromptRepository().getPrompt(params);
      var newItems = response.items.map((data) => Prompt(
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

      // Nếu API không hỗ trợ lọc favorite, lọc ở đây:
      if (_isStarred) {
        newItems = newItems.where((item) => item.isFavorite == true).toList();
      }

      setState(() {
        if (reset) {
          _filteredPrompts = newItems;
        } else {
          _filteredPrompts.addAll(newItems);
        }
        _offset += _itemsPerPage;
        _hasMore = response.hasNext;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching prompts: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      for (var cat in _categories) {
        cat.isSelected = cat.name == category;
      }
    });
    _fetchPrompts(reset: true);
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _fetchPrompts(reset: true);
  }

  void _toggleFavorite(int index) async {
    final prompt = _filteredPrompts[index];
    try {
      if (!prompt.isFavorite) {
        await PromptRepository().addPromptToFavorites(prompt.id);
      } else {
        await PromptRepository().removePromptFromFavorites(prompt.id);
      }
      setState(() {
        _filteredPrompts[index].isFavorite = !_filteredPrompts[index].isFavorite;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating favorite status: $e')),
        );
      }
    }
  }

  void _showPromptDetails(
      BuildContext context, Prompt prompt, Function onToggleFavorite) {
    final buttonColor = const Color(0xFF7B68EE);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Text(
                    prompt.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                          Clipboard.setData(
                              ClipboardData(text: prompt.content));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Content copied to clipboard')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
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
                    _showUsingMyPrompt(prompt);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
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

  void _showUsingMyPrompt(Prompt prompt) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        isScrollControlled: true,
        builder: (context) => UsingPublicPrompt(prompt: prompt),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon:
                          Icon(Icons.search, color: Colors.grey.shade500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
                        _fetchPrompts(reset: true);
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
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _filteredPrompts.length + (_hasMore ? 1 : 0),
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                if (index >= _filteredPrompts.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
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
              fontWeight:
                  category.isSelected ? FontWeight.w600 : FontWeight.w500,
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
