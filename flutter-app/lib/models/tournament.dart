import 'enums.dart';
import 'league.dart';

class Tournament {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime registrationDeadline;
  final String location;
  final double latitude;
  final double longitude;
  final SkillLevel skillLevel;
  final List<AgeGroup> ageGroups;
  final double cost;
  final String description;
  final String registrationUrl;
  final OpportunityType type = OpportunityType.tournament;

  const Tournament({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.registrationDeadline,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.skillLevel,
    required this.ageGroups,
    required this.cost,
    required this.description,
    required this.registrationUrl,
  });

  bool get registrationOpen => DateTime.now().isBefore(registrationDeadline);

  double distanceMilesFrom(double fromLat, double fromLng) {
    return haversineMiles(fromLat, fromLng, latitude, longitude);
  }
}
