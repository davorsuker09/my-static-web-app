import 'package:hive/hive.dart';

import '../models/enums.dart';
import '../models/league.dart';
import '../models/search_filters.dart';
import '../models/tournament.dart';
import '../models/user_profile.dart';
import 'mock_data.dart';

/// Mirrors the `/api/search`, `/api/leagues/{id}`, `/api/tournaments` and
/// `/api/favorites` endpoints from the PRD. Backed by [MockData] today;
/// swap method bodies for HTTP calls against the NestJS API without
/// touching callers.
class SoccerRepository {
  SoccerRepository(this._favoritesBox);

  final Box<String> _favoritesBox;

  List<League> searchLeagues({
    required double lat,
    required double lng,
    required SearchFilters filters,
  }) {
    return MockData.leagues.where((l) {
      if (l.distanceMilesFrom(lat, lng) > filters.radiusMiles) return false;
      if (filters.ageGroup != null && !l.ageGroups.contains(filters.ageGroup)) {
        return false;
      }
      if (filters.skillLevel != null && l.skillLevel != filters.skillLevel) {
        return false;
      }
      if (filters.indoor != null && l.indoor != filters.indoor) return false;
      if (filters.maxCost != null && l.cost > filters.maxCost!) return false;
      if (filters.query.isNotEmpty &&
          !l.name.toLowerCase().contains(filters.query.toLowerCase())) {
        return false;
      }
      return true;
    }).toList()
      ..sort((a, b) =>
          a.distanceMilesFrom(lat, lng).compareTo(b.distanceMilesFrom(lat, lng)));
  }

  List<Tournament> searchTournaments({
    required double lat,
    required double lng,
    required SearchFilters filters,
  }) {
    return MockData.tournaments.where((t) {
      if (t.distanceMilesFrom(lat, lng) > filters.radiusMiles) return false;
      if (filters.ageGroup != null && !t.ageGroups.contains(filters.ageGroup)) {
        return false;
      }
      if (filters.skillLevel != null && t.skillLevel != filters.skillLevel) {
        return false;
      }
      if (filters.maxCost != null && t.cost > filters.maxCost!) return false;
      if (filters.query.isNotEmpty &&
          !t.name.toLowerCase().contains(filters.query.toLowerCase())) {
        return false;
      }
      return true;
    }).toList()
      ..sort((a, b) =>
          a.distanceMilesFrom(lat, lng).compareTo(b.distanceMilesFrom(lat, lng)));
  }

  League? leagueById(String id) =>
      MockData.leagues.where((l) => l.id == id).cast<League?>().firstOrNull;

  Tournament? tournamentById(String id) => MockData.tournaments
      .where((t) => t.id == id)
      .cast<Tournament?>()
      .firstOrNull;

  bool isFavorite(String id) => _favoritesBox.containsKey(id);

  Set<String> get favoriteIds => _favoritesBox.keys.cast<String>().toSet();

  Future<void> toggleFavorite(String id) async {
    if (_favoritesBox.containsKey(id)) {
      await _favoritesBox.delete(id);
    } else {
      await _favoritesBox.put(id, id);
    }
  }

  List<League> recommendedLeagues(UserProfile profile) {
    final lat = profile.latitude ?? MockData.defaultLat;
    final lng = profile.longitude ?? MockData.defaultLng;
    return MockData.leagues
        .where((l) =>
            l.skillLevel == profile.skillLevel &&
            l.ageGroups.contains(profile.ageGroup))
        .toList()
      ..sort((a, b) =>
          a.distanceMilesFrom(lat, lng).compareTo(b.distanceMilesFrom(lat, lng)));
  }
}

extension _FirstOrNullExt<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
