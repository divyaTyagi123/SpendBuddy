import 'package:go_router/go_router.dart';

import '../screens/GeneratorScreen.dart';
import '../screens/HomeScreen.dart';
import '../screens/ScannerScreen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context,state) => const HomeScreen()),
    GoRoute(path: '/scanner', builder: (context,state)=> const ScannerScreen()),
    GoRoute(path : '/generator', builder: (context,state) => const GeneratorScreen())
  ]
);