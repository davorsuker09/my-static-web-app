import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/enums.dart';
import '../../providers/providers.dart';

class TournamentDetailsScreen extends ConsumerWidget {
  const TournamentDetailsScreen({super.key, required this.tournamentId});

  final String tournamentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournament = ref.watch(repositoryProvider).tournamentById(tournamentId);
    final isFavorite = ref.watch(favoriteIdsProvider).contains(tournamentId);
    final dateFmt = DateFormat('MMM d, yyyy');

    if (tournament == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not found')),
        body: const Center(child: Text('Tournament not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tournament.name),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null),
            onPressed: () async {
              await ref.read(repositoryProvider).toggleFavorite(tournament.id);
              ref.read(favoritesTickProvider.notifier).state++;
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Chip(label: Text(tournament.skillLevel.label)),
              const SizedBox(width: 8),
              Chip(label: Text('\$${tournament.cost.toStringAsFixed(0)}')),
            ],
          ),
          const SizedBox(height: 16),
          Text(tournament.description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.calendar_today,
            text:
                '${dateFmt.format(tournament.startDate)} - ${dateFmt.format(tournament.endDate)}',
          ),
          _InfoRow(icon: Icons.location_on, text: tournament.location),
          _InfoRow(
            icon: Icons.groups,
            text: tournament.ageGroups.map((a) => a.label).join(', '),
          ),
          _InfoRow(
            icon: Icons.event_busy,
            text: 'Registration deadline: ${dateFmt.format(tournament.registrationDeadline)}',
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.open_in_new),
            label: Text(tournament.registrationOpen ? 'Register' : 'Registration Closed'),
            onPressed: tournament.registrationOpen
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening ${tournament.registrationUrl}')),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
