import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/enums.dart';
import '../models/search_filters.dart';
import '../providers/providers.dart';

class FilterSheet extends ConsumerWidget {
  const FilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const FilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(searchFiltersProvider);
    final notifier = ref.read(searchFiltersProvider.notifier);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
            children: [
              Text('Filters', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text('Distance: ${filters.radiusMiles.toStringAsFixed(0)} mi'),
              Slider(
                value: filters.radiusMiles,
                min: 5,
                max: 100,
                divisions: 19,
                label: '${filters.radiusMiles.toStringAsFixed(0)} mi',
                onChanged: (v) => notifier.update((f) => f.copyWith(radiusMiles: v)),
              ),
              const SizedBox(height: 8),
              const Text('Age Group'),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Any'),
                    selected: filters.ageGroup == null,
                    onSelected: (_) => notifier.update((f) => f.copyWith(clearAgeGroup: true)),
                  ),
                  ...AgeGroup.values.map((a) => ChoiceChip(
                        label: Text(a.label),
                        selected: filters.ageGroup == a,
                        onSelected: (_) => notifier.update((f) => f.copyWith(ageGroup: a)),
                      )),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Skill Level'),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Any'),
                    selected: filters.skillLevel == null,
                    onSelected: (_) =>
                        notifier.update((f) => f.copyWith(clearSkillLevel: true)),
                  ),
                  ...SkillLevel.values.map((s) => ChoiceChip(
                        label: Text(s.label),
                        selected: filters.skillLevel == s,
                        onSelected: (_) => notifier.update((f) => f.copyWith(skillLevel: s)),
                      )),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Indoor / Outdoor'),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Any'),
                    selected: filters.indoor == null,
                    onSelected: (_) => notifier.update((f) => f.copyWith(clearIndoor: true)),
                  ),
                  ChoiceChip(
                    label: const Text('Indoor'),
                    selected: filters.indoor == true,
                    onSelected: (_) => notifier.update((f) => f.copyWith(indoor: true)),
                  ),
                  ChoiceChip(
                    label: const Text('Outdoor'),
                    selected: filters.indoor == false,
                    onSelected: (_) => notifier.update((f) => f.copyWith(indoor: false)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => notifier.reset(),
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
