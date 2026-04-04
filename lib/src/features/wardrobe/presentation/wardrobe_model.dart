class WardrobeItemModel {
  final String id;
  final String name;
  final String category;
  final String color;
  final String brand;
  final String imageUrl;
  final bool isFavorite;

  WardrobeItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.color,
    required this.brand,
    required this.imageUrl,
    this.isFavorite = false,
  });
}
