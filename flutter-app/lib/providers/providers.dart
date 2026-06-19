import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../data/mock_data.dart';
import '../data/soccer_repository.dart';
import '../models/league.dart';
import '../models/search_filters.dart';
import '../models/tournament.dart';
import '../models/user_profile.dart';

const profileBoxName = 'profile_box';
const favoritesBoxName = 'favorites_box';
const profileKey = 'current_profile';

final favoritesBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>(favoritesBoxName);
});

final repositoryProvider = Provider<SoccerRepository>((ref) {
  return SoccerRepository(ref.watch(favoritesBoxProvider));
});

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(_load());

  static Box<dynamic> get _box => Hive.box<dynamic>(profileBoxName);

  static UserProfile _load() {
    final raw = _box.get(profileKey);
    if (raw == null) return const UserProfile();
    return UserProfile.fromMap(raw as Map);
  }

  Future<void> update(UserProfile Function(UserProfile) updater) async {
    state = updater(state);
    await _box.put(profileKey, state.toMap());
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});

class SearchFiltersNotifier extends StateNotifier<SearchFilters> {
  SearchFiltersNotifier() : super(const SearchFilters());

  void update(SearchFilters Function(SearchFilters) updater) {
    state = updater(state);
  }

  void reset() => state = const SearchFilters();
}

final searchFiltersProvider =
    StateNotifierProvider<SearchFiltersNotifier, SearchFilters>((ref) {
  return SearchFiltersNotifier();
});

final searchResultsProvider = Provider<List<League>>((ref) {
  final profile = ref.watch(userProfileProvider);
  final filters = ref.watch(searchFiltersProvider);
  final repo = ref.watch(repositoryProvider);
  final lat = profile.latitude ?? MockData.defaultLat;
  final lng = profile.longitude ?? MockData.defaultLng;
  return repo.searchLeagues(lat: lat, lng: lng, filters: filters);
});

final tournamentResultsProvider = Provider<List<Tournament>>((ref) {
  final profile = ref.watch(userProfileProvider);
  final filters = ref.watch(searchFiltersProvider);
  final repo = ref.watch(repositoryProvider);
  final lat = profile.latitude ?? MockData.defaultLat;
  final lng = profile.longitude ?? MockData.defaultLng;
  return repo.searchTournaments(lat: lat, lng: lng, filters: filters);
});

final recommendedLeaguesProvider = Provider<List<League>>((ref) {
  final repo = ref.watch(repositoryProvider);
  final profile = ref.watch(userProfileProvider);
  return repo.recommendedLeagues(profile);
});

/// Bumped whenever a favorite is toggled so widgets watching
/// [favoriteIdsProvider] rebuild.
final favoritesTickProvider = StateProvider<int>((ref) => 0);

final favoriteIdsProvider = Provider<Set<String>>((ref) {
  ref.watch(favoritesTickProvider);
  return ref.watch(repositoryProvider).favoriteIds;
});
