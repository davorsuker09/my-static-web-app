import 'dart:math' as math;

import 'enums.dart';

class League {
  final String id;
  final String name;
  final String description;
  final String city;
  final String state;
  final double latitude;
  final double longitude;
  final SkillLevel skillLevel;
  final List<AgeGroup> ageGroups;
  final double cost;
  final String website;
  final String registrationUrl;
  final bool indoor;
  final List<String> photoUrls;
  final double rating;
  final int reviewCount;
  final String contactInfo;
  final String schedule;
  final OpportunityType type;

  const League({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.skillLevel,
    required this.ageGroups,
    required this.cost,
    required this.website,
    required this.registrationUrl,
    required this.indoor,
    required this.photoUrls,
    required this.rating,
    required this.reviewCount,
    required this.contactInfo,
    required this.schedule,
    this.type = OpportunityType.league,
  });

  double distanceMilesFrom(double fromLat, double fromLng) {
    return haversineMiles(fromLat, fromLng, latitude, longitude);
  }
}

double haversineMiles(double lat1, double lon1, double lat2, double lon2) {
  const earthRadiusMiles = 3958.8;
  final dLat = _deg2rad(lat2 - lat1);
  final dLon = _deg2rad(lon2 - lon1);
  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_deg2rad(lat1)) *
          math.cos(_deg2rad(lat2)) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return earthRadiusMiles * c;
}

double _deg2rad(double deg) => deg * (math.pi / 180.0);
