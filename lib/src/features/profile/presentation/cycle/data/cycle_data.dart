import 'package:fashai/src/features/profile/presentation/cycle/presentation/cycle_model.dart';

class CycleData {
  static final CycleModel myCycleData = CycleModel(
    currentDay: 3,
    currentPhase: "Menstrual",
    totalDays: 28,
    comfortPicks: [
      ComfortPickModel(
        title: "Loose-Fit Jeans",
        subtitle: "High-waist for extra comfort",
        icon: "👖",
      ),
      ComfortPickModel(
        title: "Soft Knit Sweater",
        subtitle: "Warm and cozy for low energy days",
        icon: "🧶",
      ),
      ComfortPickModel(
        title: "Flowy Midi Skirt",
        subtitle: "Breathable and comfortable",
        icon: "👗",
      ),
    ],
  );
}
