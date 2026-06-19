import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock_data.dart';
import '../../providers/providers.dart';
import '../../widgets/league_card.dart';
import '../../widgets/main_nav_scaffold.dart';
import '../../widgets/tournament_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoriteIdsProvider);
    final leagues = MockData.leagues.where((l) => favoriteIds.contains(l.id)).toList();
    final tournaments =
        MockData.tournaments.where((t) => favoriteIds.contains(t.id)).toList();

    return MainNavScaffold(
      currentIndex: 2,
      title: 'My Soccer',
      body: (leagues.isEmpty && tournaments.isEmpty)
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Nothing saved yet. Tap the heart icon on a league or tournament to save it here.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView(
              children: [
                if (leagues.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Text('Saved Leagues & Academies',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ...leagues.map((l) => LeagueCard(league: l)),
                ],
                if (tournaments.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Text('Saved Tournaments',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ...tournaments.map((t) => TournamentCard(tournament: t)),
                ],
              ],
            ),
    );
  }
}
