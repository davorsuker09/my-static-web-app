import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/enums.dart';
import '../../providers/providers.dart';
import '../../widgets/main_nav_scaffold.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    return MainNavScaffold(
      currentIndex: 3,
      title: 'Profile',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Role'),
            subtitle: Text(profile.role.label),
            trailing: const Icon(Icons.edit),
            onTap: () => _pickRole(context, ref),
          ),
          ListTile(
            title: const Text('Age Group'),
            subtitle: Text('${profile.ageGroup.label} (${profile.ageGroup.range})'),
            trailing: const Icon(Icons.edit),
            onTap: () => _pickAgeGroup(context, ref),
          ),
          ListTile(
            title: const Text('Skill Level'),
            subtitle: Text(profile.skillLevel.label),
            trailing: const Icon(Icons.edit),
            onTap: () => _pickSkillLevel(context, ref),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Registration reminders'),
            subtitle: const Text('Notify me about deadlines and new tournaments'),
            value: true,
            onChanged: (_) {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: const Text('Upgrade to Premium'),
            subtitle: const Text('\$4.99/mo — advanced filters, unlimited alerts'),
            onTap: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Premium coming soon')));
            },
          ),
        ],
      ),
    );
  }

  void _pickRole(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: UserRole.values
              .map((r) => ListTile(
                    title: Text(r.label),
                    onTap: () {
                      ref.read(userProfileProvider.notifier).update((p) => p.copyWith(role: r));
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _pickAgeGroup(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: AgeGroup.values
              .map((a) => ListTile(
                    title: Text('${a.label} (${a.range})'),
                    onTap: () {
                      ref
                          .read(userProfileProvider.notifier)
                          .update((p) => p.copyWith(ageGroup: a));
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _pickSkillLevel(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: SkillLevel.values
              .map((s) => ListTile(
                    title: Text(s.label),
                    subtitle: Text(s.description),
                    onTap: () {
                      ref
                          .read(userProfileProvider.notifier)
                          .update((p) => p.copyWith(skillLevel: s));
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}
