class CycleModel {
  final int currentDay;
  final String currentPhase;
  final int totalDays;
  final List<ComfortPickModel> comfortPicks;

  CycleModel({
    required this.currentDay,
    required this.currentPhase,
    required this.totalDays,
    required this.comfortPicks,
  });
}

class ComfortPickModel {
  final String title;
  final String subtitle;
  final String icon;

  ComfortPickModel({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
