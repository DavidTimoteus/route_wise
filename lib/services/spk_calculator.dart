import 'dart:math' as math;
import 'package:route_wise/models/route_models.dart';

class SpkCalculator {
  static const double weightDistance = 0.30;
  static const double weightItemCount = 0.25;
  static const double weightCost = 0.20;
  static const double weightTravelTime = 0.25;

  static List<SpkAlternative> rankBySaw(List<SpkAlternative> alternatives) {
    if (alternatives.isEmpty) {
      return const [];
    }

    final minDistance = alternatives
        .map((item) => item.distanceKm <= 0 ? 0.1 : item.distanceKm)
        .reduce(math.min);
    final maxItems = alternatives
        .map((item) => item.itemCount <= 0 ? 1 : item.itemCount)
        .reduce(math.max);
    final minCost = alternatives
        .map((item) => item.estimatedCostRp <= 0 ? 1.0 : item.estimatedCostRp)
        .reduce(math.min);
    final minTime = alternatives
        .map((item) =>
            item.travelTimeMinutes <= 0 ? 1.0 : item.travelTimeMinutes)
        .reduce(math.min);

    final scored = alternatives.map((item) {
      final safeDistance = item.distanceKm <= 0 ? 0.1 : item.distanceKm;
      final safeItems = item.itemCount <= 0 ? 1 : item.itemCount;
      final safeCost = item.estimatedCostRp <= 0 ? 1.0 : item.estimatedCostRp;
      final safeTime =
          item.travelTimeMinutes <= 0 ? 1.0 : item.travelTimeMinutes;

      final normDistance = minDistance / safeDistance;
      final normItems = safeItems / maxItems;
      final normCost = minCost / safeCost;
      final normTime = minTime / safeTime;

      final totalScore = (normDistance * weightDistance) +
          (normItems * weightItemCount) +
          (normCost * weightCost) +
          (normTime * weightTravelTime);

      return item.copyWith(
        sawScore: double.parse(totalScore.toStringAsFixed(4)),
      );
    }).toList();

    scored.sort((a, b) => b.sawScore.compareTo(a.sawScore));
    return scored;
  }

  static double haversineDistanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadiusKm = 6371.0;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return double.parse((earthRadiusKm * c).toStringAsFixed(2));
  }

  static double _toRadians(double degrees) => degrees * (math.pi / 180.0);
}
