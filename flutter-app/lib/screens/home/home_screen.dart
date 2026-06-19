import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/enums.dart';
import '../../providers/providers.dart';
import '../../widgets/league_card.dart';
import '../../widgets/main_nav_scaffold.dart';
import '../../widgets/tournament_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearbyLeagues = ref.watch(searchResultsProvider).take(5).toList();
    final upcomingTournaments = ref.watch(tournamentResultsProvider).take(5).toList();
    final recommended = ref.watch(recommendedLeaguesProvider).take(5).toList();
    final profile = ref.watch(userProfileProvider);

    return MainNavScaffold(
      currentIndex: 0,
      title: 'FindMySoccer',
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () => context.push('/search'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 12),
                    Text('Search leagues, tournaments, academies...'),
                  ],
                ),
              ),
            ),
          ),
          _SectionHeader(
            title: 'Nearby Leagues',
            onSeeAll: () => context.push('/search'),
          ),
          if (nearbyLeagues.isEmpty)
            const _EmptySection(message: 'No leagues found nearby yet.')
          else
            ...nearbyLeagues.map((l) => LeagueCard(league: l)),
          _SectionHeader(
            title: 'Upcoming Tournaments',
            onSeeAll: () => context.push('/search'),
          ),
          if (upcomingTournaments.isEmpty)
            const _EmptySection(message: 'No upcoming tournaments yet.')
          else
            ...upcomingTournaments.map((t) => TournamentCard(tournament: t)),
          _SectionHeader(
            title: 'Recommended for You',
            subtitle:
                'Because you play ${profile.skillLevel.label} ${profile.ageGroup.label} soccer',
          ),
          if (recommended.isEmpty)
            const _EmptySection(message: 'Keep exploring to get recommendations.')
          else
            ...recommended.map((l) => LeagueCard(league: l)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.subtitle, this.onSeeAll});
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                if (subtitle != null)
                  Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          if (onSeeAll != null)
            TextButton(onPressed: onSeeAll, child: const Text('See all')),
        ],
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
