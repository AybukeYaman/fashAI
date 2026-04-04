import 'package:fashai/src/features/home/data/home_data.dart';
import 'package:fashai/src/features/profile/presentation/profile_model.dart';
import 'package:fashai/src/features/wardrobe/data/wardrobe_data.dart';

class ProfileData {
  static ProfileModel get myProfile => ProfileModel(
    fullName: "Ayşe Yılmaz",
    subtitle: "Style Enthusiast",
    location: "Istanbul",
    initial: "A",
    isPro: true,
    itemCount: WardrobeData.items.length,
    outfitCount: HomeData.myHomeData.outfits.length,
    minSaved: 8.2,
  );
}
