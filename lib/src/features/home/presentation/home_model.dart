class CategoryModel {
  final String id;
  final String title;

  CategoryModel({required this.id, required this.title});
}

class OutfitModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String categoryId;
  final String reason;

  OutfitModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.categoryId,
    required this.reason,
  });
}

class HomeModel {
  final String userName;
  final int temperature;
  final String weatherStatus;
  final String city;
  final DateTime date;
  final List<CategoryModel> categories;
  final List<OutfitModel> outfits;

  HomeModel({
    required this.userName,
    required this.temperature,
    required this.weatherStatus,
    required this.city,
    required this.date,
    required this.categories,
    required this.outfits,
  });
}
