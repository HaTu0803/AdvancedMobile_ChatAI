class Prompt {
  final String title;
  final String description;
  final String category;
  bool isFavorite;

  Prompt({
    required this.title,
    required this.description,
    required this.category,
    required this.isFavorite,
  });
}

class Category {
  final String name;
  bool isSelected;

  Category({
    required this.name,
    required this.isSelected,
  });
}

