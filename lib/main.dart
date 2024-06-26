import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:robomas_debuger/start_page.dart';
import 'package:robomas_debuger/robomas_page.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
        routeInformationProvider: router.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        title: 'CRS_Debuger',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ));
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(initialLocation: '/StartPage', routes: [
    GoRoute(
      path: '/StartPage',
      builder: (context, state) => StartPage(key: state.pageKey),
    ),
    GoRoute(
      path: '/RobomasPages',
      builder: (context, state) => RobomasPages(key: state.pageKey),
    ),
  ]);
});
