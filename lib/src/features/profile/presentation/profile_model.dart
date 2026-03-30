class ProfileModel {
  final String fullName;
  final String subtitle;
  final String initial;
  final bool isPro;
  final int itemCount;
  final int outfitCount;
  final double minSaved;
  final double sustainabilityScore;
  final int sustainabilityMonthlyGrowth;

  ProfileModel({
    required this.fullName,
    required this.subtitle,
    required this.initial,
    required this.isPro,
    required this.itemCount,
    required this.outfitCount,
    required this.minSaved,
    required this.sustainabilityScore,
    required this.sustainabilityMonthlyGrowth,
  });
}