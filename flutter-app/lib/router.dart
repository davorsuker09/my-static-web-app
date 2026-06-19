import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/providers.dart';
import 'screens/favorites/favorites_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/league_details/league_details_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/search/search_results_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/tournament_details/tournament_details_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final onboardingComplete =
          ref.read(userProfileProvider).onboardingComplete;
      final goingToSplash = state.matchedLocation == '/splash';
      final goingToOnboarding = state.matchedLocation == '/onboarding';

      if (goingToSplash) return null;
      if (!onboardingComplete && !goingToOnboarding) return '/onboarding';
      if (onboardingComplete && goingToOnboarding) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchResultsScreen(),
      ),
      GoRoute(
        path: '/league/:id',
        builder: (context, state) =>
            LeagueDetailsScreen(leagueId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/tournament/:id',
        builder: (context, state) => TournamentDetailsScreen(
          tournamentId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
