class ProfileModel {
  final String fullName;
  final String subtitle;
  final String initial;
  final String location;
  final bool isPro;
  final int itemCount;
  final int outfitCount;
  final double minSaved;

  ProfileModel({
    required this.fullName,
    required this.subtitle,
    required this.initial,
    required this.location,
    required this.isPro,
    required this.itemCount,
    required this.outfitCount,
    required this.minSaved,
  });
}
