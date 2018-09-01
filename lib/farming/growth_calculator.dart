import 'package:app/models/farming_patch.dart';

class GrowthCalculator {
  /// Estimate when the given farming patch will be ready to harvest
  DateTime estimate(FarmingPatch patch) {
    final produce = patch.produce;
    final tickRate = Duration(minutes: produce.tickRate);
    final estimate = patch.plantedAt.add(tickRate * produce.tickCount);
    final savings = _savings(patch, tickRate);
    return estimate.subtract(savings);
  }

  /// Due to the nature of growth cycles, the user can skip some time if they
  /// plant between growth cycles
  ///
  /// e.g. for herbs with a 20 minute tick rate and 4 stages
  ///      planting at 8:00 and 8:19 makes no difference
  ///      they both finish growing at 9:20
  Duration _savings(FarmingPatch patch, Duration tickRate) {
    // Get the minute difference since some 00:00 time e.g. UNIX Epoch
    final millis = patch.plantedAt.millisecondsSinceEpoch;
    final minutes = Duration(milliseconds: millis).inMinutes;
    // Figure out time passed since the last growth cycle
    return Duration(minutes: minutes % tickRate.inMinutes);
  }
}
