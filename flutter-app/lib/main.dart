import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'providers/providers.dart';
import 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<dynamic>(profileBoxName);
  await Hive.openBox<String>(favoritesBoxName);
  runApp(const ProviderScope(child: FindMySoccerApp()));
}

class FindMySoccerApp extends ConsumerWidget {
  const FindMySoccerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'FindMySoccer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1B8A4B),
      ),
      routerConfig: router,
    );
  }
}
