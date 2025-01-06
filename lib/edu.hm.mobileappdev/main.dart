import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileappdev/edu.hm.mobileappdev/screen/home_screen.dart';
import 'package:mobileappdev/edu.hm.mobileappdev/state/play_state.dart';
import 'package:mobileappdev/edu.hm.mobileappdev/screen/kniffel_game_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider<KniffelGameState>(
        create: (_) => _createKniffelGameState(),
      )
    ],
    child: MainApp(),
  ));
}

KniffelGameState _createKniffelGameState() {
  KniffelGameState gameState = KniffelGameState();

  //gameState.addPlayer(Player("Max"));
  //gameState.addPlayer(Player("Musterman"));

  return gameState;
}

class MainApp extends StatelessWidget {

  //To change page: context.go('/');
  late final GoRouter _route = GoRouter(
    routes: [
      _createGoRoute('/', HomeScreen()),
      _createGoRoute('/play', KniffelGameScreen()),
    ],
    initialLocation: "/",
    redirect: (context, state) {
      return null;
    },
  );

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Kniffel",
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      routeInformationParser: _route.routeInformationParser,
      routerDelegate: _route.routerDelegate,
      routeInformationProvider: _route.routeInformationProvider,
    );
  }

  GoRoute _createGoRoute(String path, Widget screen) {
    return GoRoute(
        path: path,
        pageBuilder: (context, state) => _buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: screen,
            ));
  }

  CustomTransitionPage _buildPageWithDefaultTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: animation,
              child: child,
            ));
  }
}
