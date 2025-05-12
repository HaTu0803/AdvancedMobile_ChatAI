import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../widgets/button_action.dart';
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
  List<Prompt> _allPrompts = []; 
  List<Prompt> _filteredPrompts = []; 
  String _searchQuery = '';
  bool _isStarred = false;
  bool _isLoading = false;

  late List<PromptCategory> _categories = [];
  int _itemsPerPage = 10;
  int _currentMax = 10;

  @override
  void initState() {
    super.initState();
    _fetchPromptsFromApi();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchPromptsFromApi() async {
    setState(() => _isLoading = true);

    try {
      final promptProvider =
          Provider.of<PromptProvider>(context, listen: false);
      await Future.wait([
        promptProvider.fetchPrompts(),
        promptProvider.fetchCategories(),
      ]);

      final prompts = promptProvider.prompts?.items ?? [];

      setState(() {
        _allPrompts = prompts
            .map((data) => Prompt(
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
                ))
            .toList();

        _categories = promptProvider.categories;
        _filterPrompts(reset: true);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching prompts: $e')),
        );
      }
    }
    setState(() => _isLoading = false);

  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 10) {
      if (_currentMax < _filteredPrompts.length) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _currentMax = (_currentMax + _itemsPerPage).clamp(0, _filteredPrompts.length);
            });
          }
        });
      }
    }
  }

  void _filterPrompts({bool reset = false}) {
    List<Prompt> filtered = _allPrompts.where((prompt) {
      final matchesCategory = _selectedCategory == 'All' ||
          prompt.category == _selectedCategory;
      final matchesSearch =
          prompt.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          prompt.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFavorite = !_isStarred || prompt.isFavorite;
      return matchesCategory && matchesSearch && matchesFavorite;
    }).toList();

    setState(() {
      _filteredPrompts = filtered;
      if (reset) {
        _currentMax = _itemsPerPage.clamp(0, _filteredPrompts.length);
      } else {
        _currentMax = _currentMax.clamp(0, _filteredPrompts.length);
      }
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      for (var cat in _categories) {
        cat.isSelected = cat.name == category;
      }
    });
    _filterPrompts(reset: true);
  }

  void _toggleFavorite(int index) async {
    final promptIndex = _allPrompts.indexOf(_filteredPrompts[index]);
    if (promptIndex != -1) {
      final prompt = _allPrompts[promptIndex];
      try {
        if (!prompt.isFavorite) {
          await PromptRepository().addPromptToFavorites(prompt.id);
        } else {
          await PromptRepository().removePromptFromFavorites(prompt.id);
        }
        setState(() {
          _allPrompts[promptIndex].isFavorite = !_allPrompts[promptIndex].isFavorite;
        });
        _filterPrompts();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating favorite status: $e')),
          );
        }
      }
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterPrompts(reset: true);
  }

  void _showPromptDetails(
      BuildContext context, Prompt prompt, Function onToggleFavorite, int index) {
    final buttonColor =
        const Color(0xFF7B68EE);

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
                      prompt.isFavorite ? Icons.star : Icons.star_border,
                      color: prompt.isFavorite ? Colors.grey : Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Đóng dialog để cập nhật lại UI
                      _toggleFavorite(index); // Cập nhật trạng thái toàn cục
                      // Có thể mở lại dialog nếu muốn, hoặc để user tự mở lại
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
                    _showUsingMyPrompt(
                      prompt);
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
                      hintText: 'Search prompts...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4
                      ),
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
                      _isStarred ? Icons.star : Icons.star_border,
                      color: _isStarred ? Colors.grey : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isStarred = !_isStarred;
                      });
                      _filterPrompts(reset: true);
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
            child: _allPrompts.isEmpty && _isLoading
                ? const Center(child: CircularProgressIndicator())
                :ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: (_currentMax < _filteredPrompts.length)
                  ? _currentMax + 1
                  : _filteredPrompts.length,
              itemBuilder: (context, index) {
                if (index == _currentMax && _currentMax < _filteredPrompts.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final prompt = _filteredPrompts[index];
                return ButtonAction(
                  model: prompt,
                  iconActions: [
                    IconAction(
                      icon: prompt.isFavorite ? Icons.star : Icons.star_border,
                      onPressed: () => _toggleFavorite(index),
                      style: IconButtonStyle(
                        iconColor: Colors.grey,
                      ),
                    ),
                    IconAction(
                      icon: Icons.info_outline,
                      onPressed: () => _showPromptDetails(context, prompt, () => _toggleFavorite(index), index),
                    ),
                    IconAction(
                      icon: Icons.arrow_forward,
                      onPressed: () => _showUsingMyPrompt(prompt),
                      style: IconButtonStyle(
                        iconColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
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
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          return ChoiceChip(
            label: Text(
              category.name,
              style: TextStyle(
                color: category.isSelected ? Colors.white : Colors.black87,
                fontWeight: category.isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 15,
              ),
            ),
            selected: category.isSelected,
            selectedColor: const Color(0xFF7B68EE),
            backgroundColor: const Color(0xFFF5F5F5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(
                color: category.isSelected ? const Color(0xFF7B68EE) : Colors.grey.shade300,
                width: 1.2,
              ),
            ),
            elevation: category.isSelected ? 4 : 0,
            shadowColor: const Color(0xFF7B68EE).withOpacity(0.2),
            onSelected: (_) => _selectCategory(category.name),
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          );
        },
      ),
    );
  }
}

Widget? buildPromptItem(PromptItem? promptItem) {
  if (promptItem == null) {
    return null;
  }
  return promptItem;
}

class PromptList extends StatelessWidget {
  final List<PromptItem> promptItems;
  PromptList({required this.promptItems});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: promptItems.length,
      itemBuilder: (context, index) {
        return buildPromptItem(promptItems[index]) ?? Container();
      },
    );
  }
}