import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:robomas_debuger/terminal.dart';
import 'package:robomas_debuger/robomas_page.dart';

void main(){
  // final counterProvider = StateProvider<int>((ref) => 0);
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerStatefulWidget{
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/a',
    routes: [
      GoRoute(
        path: '/a',
        builder: (context, state) => Terminal(key: state.pageKey), 
      ),
      GoRoute(
        path: '/b',
        builder: (context, state) => RobomasPage(key: state.pageKey),
      )
    ]
  );
});

class _AppState extends ConsumerState<App>{
  @override
  Widget build(BuildContext context){
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      title: 'CRS_Debuger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      )
    );
  }
}