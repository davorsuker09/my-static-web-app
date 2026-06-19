import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/mock_data.dart';
import '../../providers/providers.dart';
import '../../widgets/filter_sheet.dart';
import '../../widgets/league_card.dart';
import '../../widgets/main_nav_scaffold.dart';
import '../../widgets/tournament_card.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  ConsumerState<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  bool _showMap = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leagues = ref.watch(searchResultsProvider);
    final tournaments = ref.watch(tournamentResultsProvider);
    final profile = ref.watch(userProfileProvider);

    return MainNavScaffold(
      currentIndex: 1,
      title: 'Search',
      actions: [
        IconButton(
          icon: Icon(_showMap ? Icons.list : Icons.map),
          tooltip: _showMap ? 'List view' : 'Map view',
          onPressed: () => setState(() => _showMap = !_showMap),
        ),
        IconButton(
          icon: const Icon(Icons.filter_list),
          tooltip: 'Filters',
          onPressed: () => FilterSheet.show(context),
        ),
      ],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) =>
                  ref.read(searchFiltersProvider.notifier).update((f) => f.copyWith(query: v)),
            ),
          ),
          Expanded(
            child: _showMap
                ? _MapView(
                    lat: profile.latitude ?? MockData.defaultLat,
                    lng: profile.longitude ?? MockData.defaultLng,
                    leagues: leagues,
                  )
                : ListView(
                    children: [
                      if (leagues.isEmpty && tournaments.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(child: Text('No results. Try adjusting filters.')),
                        ),
                      if (leagues.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                          child: Text('Leagues & Academies',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        ...leagues.map((l) => LeagueCard(league: l)),
                      ],
                      if (tournaments.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                          child: Text('Tournaments',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        ...tournaments.map((t) => TournamentCard(tournament: t)),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _MapView extends StatelessWidget {
  const _MapView({required this.lat, required this.lng, required this.leagues});

  final double lat;
  final double lng;
  final List leagues;

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('me'),
        position: LatLng(lat, lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'You'),
      ),
      for (final l in leagues)
        Marker(
          markerId: MarkerId(l.id as String),
          position: LatLng(l.latitude as double, l.longitude as double),
          infoWindow: InfoWindow(title: l.name as String),
        ),
    };

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: LatLng(lat, lng), zoom: 10),
      markers: markers,
    );
  }
}
