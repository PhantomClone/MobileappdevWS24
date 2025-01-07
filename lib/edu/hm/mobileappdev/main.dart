import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/online/client.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/repository/player_repository.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/repository/player_repository_impl.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/screen/home_screen.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/screen/kniffel_game_screen_multiplayer.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/screen/kniffel_game_screen_single.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/screen/online_wait_for_players_screen.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/screen/result_screen.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/screen/scoreboard_screen.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/state/play_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider<KniffelGameState>(
        create: (_) => _createKniffelGameState(),
      ),
      Provider<KniffelServiceClient>(create: (_) => KniffelServiceClient()),
      Provider<PlayerRepository>(create: (_) => PlayerRepositoryImplementation())
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
      _createGoRoute('/play', KniffelGameScreenSingle()),
      _createGoRoute('/result', ResultScreen()),
      _createGoRoute('/score', ScoreboardScreen()),
      _createGoRoute('/wait_for_players', OnlineWaitForPlayersScreen()),
      _createGoRoute('/play_online', KniffelGameScreenMultiplayer()),
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
