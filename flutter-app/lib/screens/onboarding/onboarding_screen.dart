import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../models/enums.dart';
import '../../providers/providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _step = 0;

  UserRole _role = UserRole.player;
  AgeGroup _ageGroup = AgeGroup.adult;
  SkillLevel _skillLevel = SkillLevel.beginner;
  bool _requestingLocation = false;
  String? _locationError;

  static const _totalSteps = 4;

  void _next() {
    if (_step == _totalSteps - 1) return;
    setState(() => _step++);
    _pageController.animateToPage(_step,
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  void _back() {
    if (_step == 0) return;
    setState(() => _step--);
    _pageController.animateToPage(_step,
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  Future<void> _requestLocationAndFinish() async {
    setState(() {
      _requestingLocation = true;
      _locationError = null;
    });

    double? lat;
    double? lng;
    String locationLabel = '';
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition();
        lat = position.latitude;
        lng = position.longitude;
        locationLabel = 'Current location';
      } else {
        _locationError = 'Location permission denied. You can set it later in Profile.';
      }
    } catch (_) {
      _locationError = 'Could not determine location. You can set it later in Profile.';
    }

    await ref.read(userProfileProvider.notifier).update((p) => p.copyWith(
          role: _role,
          ageGroup: _ageGroup,
          skillLevel: _skillLevel,
          latitude: lat,
          longitude: lng,
          locationLabel: locationLabel,
          onboardingComplete: true,
        ));

    if (!mounted) return;
    if (_locationError != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_locationError!)));
    }
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to FindMySoccer'),
        leading: _step > 0
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: _back)
            : null,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: (_step + 1) / _totalSteps),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _RoleStep(
                  selected: _role,
                  onSelected: (r) => setState(() => _role = r),
                  onNext: _next,
                ),
                _AgeStep(
                  selected: _ageGroup,
                  onSelected: (a) => setState(() => _ageGroup = a),
                  onNext: _next,
                ),
                _SkillStep(
                  selected: _skillLevel,
                  onSelected: (s) => setState(() => _skillLevel = s),
                  onNext: _next,
                ),
                _LocationStep(
                  loading: _requestingLocation,
                  onFinish: _requestLocationAndFinish,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleStep extends StatelessWidget {
  const _RoleStep({required this.selected, required this.onSelected, required this.onNext});
  final UserRole selected;
  final ValueChanged<UserRole> onSelected;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'I am a...',
      onNext: onNext,
      children: UserRole.values.map((r) {
        return RadioListTile<UserRole>(
          title: Text(r.label),
          value: r,
          groupValue: selected,
          onChanged: (v) => onSelected(v!),
        );
      }).toList(),
    );
  }
}

class _AgeStep extends StatelessWidget {
  const _AgeStep({required this.selected, required this.onSelected, required this.onNext});
  final AgeGroup selected;
  final ValueChanged<AgeGroup> onSelected;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'Choose your age group',
      onNext: onNext,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AgeGroup.values.map((a) {
            return ChoiceChip(
              label: Text('${a.label} (${a.range})'),
              selected: selected == a,
              onSelected: (_) => onSelected(a),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SkillStep extends StatelessWidget {
  const _SkillStep({required this.selected, required this.onSelected, required this.onNext});
  final SkillLevel selected;
  final ValueChanged<SkillLevel> onSelected;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'Choose your skill level',
      onNext: onNext,
      children: SkillLevel.values.map((s) {
        return RadioListTile<SkillLevel>(
          title: Text(s.label),
          subtitle: Text(s.description),
          value: s,
          groupValue: selected,
          onChanged: (v) => onSelected(v!),
        );
      }).toList(),
    );
  }
}

class _LocationStep extends StatelessWidget {
  const _LocationStep({required this.loading, required this.onFinish});
  final bool loading;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on, size: 64, color: Color(0xFF1B8A4B)),
          const SizedBox(height: 16),
          const Text(
            'Allow location access to see leagues, tournaments and academies near you.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: loading ? null : onFinish,
            child: loading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Allow & view opportunities'),
          ),
        ],
      ),
    );
  }
}

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({required this.title, required this.children, required this.onNext});
  final String title;
  final List<Widget> children;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Expanded(child: ListView(children: children)),
          FilledButton(onPressed: onNext, child: const Text('Continue')),
        ],
      ),
    );
  }
}
