import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../models/enums.dart';
import '../models/tournament.dart';
import '../providers/providers.dart';

class TournamentCard extends ConsumerWidget {
  const TournamentCard({super.key, required this.tournament});

  final Tournament tournament;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoriteIdsProvider).contains(tournament.id);
    final dateFmt = DateFormat('MMM d');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: () => context.push('/tournament/${tournament.id}'),
        title: Text(tournament.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${dateFmt.format(tournament.startDate)} - ${dateFmt.format(tournament.endDate)}'),
            Text(tournament.ageGroups.map((a) => a.label).join(', ')),
            Text(
              tournament.registrationOpen
                  ? 'Registration closes ${dateFmt.format(tournament.registrationDeadline)}'
                  : 'Registration closed',
              style: TextStyle(
                color: tournament.registrationOpen ? Colors.green[700] : Colors.red,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null),
          onPressed: () async {
            await ref.read(repositoryProvider).toggleFavorite(tournament.id);
            ref.read(favoritesTickProvider.notifier).state++;
          },
        ),
      ),
    );
  }
}
