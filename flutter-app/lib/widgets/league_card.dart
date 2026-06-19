import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/mock_data.dart';
import '../models/league.dart';
import '../providers/providers.dart';

class LeagueCard extends ConsumerWidget {
  const LeagueCard({super.key, required this.league});

  final League league;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final lat = profile.latitude ?? MockData.defaultLat;
    final lng = profile.longitude ?? MockData.defaultLng;
    final distance = league.distanceMilesFrom(lat, lng);
    final isFavorite = ref.watch(favoriteIdsProvider).contains(league.id);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: () => context.push('/league/${league.id}'),
        title: Text(league.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${league.city}, ${league.state} • ${distance.toStringAsFixed(1)} mi'),
            Text('${league.skillLevel.label} • \$${league.cost.toStringAsFixed(0)}'),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                Text(' ${league.rating} (${league.reviewCount})'),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null),
          onPressed: () async {
            await ref.read(repositoryProvider).toggleFavorite(league.id);
            ref.read(favoritesTickProvider.notifier).state++;
          },
        ),
      ),
    );
  }
}
