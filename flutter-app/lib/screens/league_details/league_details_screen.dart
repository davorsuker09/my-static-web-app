import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/enums.dart';
import '../../providers/providers.dart';

class LeagueDetailsScreen extends ConsumerWidget {
  const LeagueDetailsScreen({super.key, required this.leagueId});

  final String leagueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final league = ref.watch(repositoryProvider).leagueById(leagueId);
    final isFavorite = ref.watch(favoriteIdsProvider).contains(leagueId);

    if (league == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not found')),
        body: const Center(child: Text('League not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(league.name),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null),
            onPressed: () async {
              await ref.read(repositoryProvider).toggleFavorite(league.id);
              ref.read(favoritesTickProvider.notifier).state++;
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.image_outlined, size: 48, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Chip(label: Text(league.skillLevel.label)),
              const SizedBox(width: 8),
              Chip(label: Text(league.indoor ? 'Indoor' : 'Outdoor')),
              const SizedBox(width: 8),
              Chip(label: Text('\$${league.cost.toStringAsFixed(0)}')),
            ],
          ),
          const SizedBox(height: 16),
          Text(league.description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          _InfoRow(icon: Icons.location_on, text: '${league.city}, ${league.state}'),
          _InfoRow(icon: Icons.calendar_today, text: league.schedule),
          _InfoRow(icon: Icons.groups, text: league.ageGroups.map((a) => a.label).join(', ')),
          _InfoRow(icon: Icons.email, text: league.contactInfo),
          _InfoRow(icon: Icons.language, text: league.website),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              Text(' ${league.rating} (${league.reviewCount} reviews)'),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.open_in_new),
            label: const Text('Register'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening ${league.registrationUrl}')),
              );
            },
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
