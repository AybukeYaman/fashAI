import 'package:fashai/src/features/home/presentation/home_model.dart';

// 'home_model.dart';

class HomeData {
  static final HomeModel myHomeData = HomeModel(
    userName: "Zeynep",
    temperature: 18,
    weatherStatus: "Partly Cloudy",
    city: "Istanbul",
    date: DateTime.now(),
    categories: [
      CategoryModel(id: "1", title: "Professional"),
      CategoryModel(id: "2", title: "Casual"),
      CategoryModel(id: "3", title: "Date Night"),
      CategoryModel(id: "4", title: "Comfy"),
      CategoryModel(id: "5", title: "Sporty"),
    ],
    outfits: [
      OutfitModel(
        id: "a",
        title: "Elegant Office Look",
        description: "Perfect for your 7PM meeting.",
        imageUrl: "https://picsum.photos/id/1/400/300",
        categoryId: "1",
        reason:
            "The blazer adds professionalism while keeping you comfortable.",
      ),
      OutfitModel(
        id: "b",
        title: "Weekend Relax",
        description: "Stay comfortable all day.",
        imageUrl: "https://picsum.photos/id/10/400/301",
        categoryId: "2",
        reason: "Great for a casual Friday. Comfortable yet put-together.",
      ),
      OutfitModel(
        id: "c",
        title: "Romantic Dinner",
        description: "A special outfit for a special night.",
        imageUrl: "https://picsum.photos/id/20/400/302",
        categoryId: "3",
        reason: "Timeless and versatile. Works for a special evening out.",
      ),
      OutfitModel(
        id: "d",
        title: "Home Office Focus",
        description: "Soft and breathable fabrics.",
        imageUrl: "https://picsum.photos/id/30/400/303",
        categoryId: "4",
        reason: "Soft fabrics keep you focused and comfortable all day.",
      ),
    ],
  );
}
