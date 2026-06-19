import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavScaffold extends StatelessWidget {
  const MainNavScaffold({
    super.key,
    required this.currentIndex,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  final int currentIndex;
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  static const _routes = ['/home', '/search', '/favorites', '/profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => context.go(_routes[i]),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'My Soccer'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
