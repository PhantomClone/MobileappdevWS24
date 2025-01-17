import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/repository/player.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/repository/player_repository.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/screen/scoreboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class MockPlayerRepository extends Mock implements PlayerRepository {}

void main() {
  late MockPlayerRepository mockPlayerRepository;

  setUp(() {
    mockPlayerRepository = MockPlayerRepository();
  });

  Future<void> createScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Provider<PlayerRepository>(
          create: (_) => mockPlayerRepository,
          child: const ScoreboardScreen(),
        ),
      ),
    );
  }

  testWidgets('ScoreboardScreen displays players correctly', (WidgetTester tester) async {
    final List<PlayerDTO> mockPlayers = [
      PlayerDTO(id: 1, name: 'Player 1', score: 100),
      PlayerDTO(id: 2, name: 'Player 2', score: 90),
      PlayerDTO(id: 3, name: 'Player 3', score: 80),
    ];

    when(() => mockPlayerRepository.getPlayersRanking(limit: 10))
        .thenAnswer((_) async => mockPlayers);

    await createScreen(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Player 1'), findsOneWidget);
    expect(find.text('Player 2'), findsOneWidget);
    expect(find.text('Player 3'), findsOneWidget);
    expect(find.text('Score: 100'), findsOneWidget);
    expect(find.text('Score: 90'), findsOneWidget);
    expect(find.text('Score: 80'), findsOneWidget);
  });

  testWidgets('ScoreboardScreen displays CircularProgressIndicator correctly', (WidgetTester tester) async {
    when(() => mockPlayerRepository.getPlayersRanking(limit: 10))
        .thenAnswer((_) async => Future.delayed(const Duration(seconds: 1)));

    await createScreen(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('ScoreboardScreen shows error message when no players are available', (WidgetTester tester) async {
    when(() => mockPlayerRepository.getPlayersRanking(limit: 10))
        .thenAnswer((_) async => []);

    await createScreen(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('No players available.'), findsOneWidget);
  });

  /*
  testWidgets('ScoreboardScreen shows error message when API request fails', (WidgetTester tester) async {
    when(() => mockPlayerRepository.getPlayersRanking(limit: 10))
        .thenThrow(Exception('Failed to load players'));

    await createScreen(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Error: Exception: Failed to load players'), findsOneWidget);
  });
   */

  testWidgets('ScoreboardScreen displays correct rank colors', (WidgetTester tester) async {
    final List<PlayerDTO> mockPlayers = [
      PlayerDTO(id: 1, name: 'Player 1', score: 100), // First place
      PlayerDTO(id: 2, name: 'Player 2', score: 90),  // Second place
      PlayerDTO(id: 3, name: 'Player 3', score: 80),  // Third place
      PlayerDTO(id: 4, name: 'Player 4', score: 70),  // Other players
    ];

    when(() => mockPlayerRepository.getPlayersRanking(limit: 10))
        .thenAnswer((_) async => mockPlayers);

    await createScreen(tester);
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate((widget) =>
      widget is CircleAvatar &&
          widget.child is Text &&
          (widget.child as Text).data == '1' &&
          widget.backgroundColor == Colors.amber),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((widget) =>
      widget is CircleAvatar &&
          widget.child is Text &&
          (widget.child as Text).data == '2' &&
          widget.backgroundColor == Colors.grey),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((widget) =>
      widget is CircleAvatar &&
          widget.child is Text &&
          (widget.child as Text).data == '3' &&
          widget.backgroundColor == Colors.deepOrangeAccent),
      findsOneWidget,
    );
  });

  testWidgets('ScoreboardScreen displays background image correctly', (WidgetTester tester) async {
    final List<PlayerDTO> mockPlayers = [
      PlayerDTO(id: 1, name: 'Player 1', score: 100),
      PlayerDTO(id: 2, name: 'Player 2', score: 90),
      PlayerDTO(id: 3, name: 'Player 3', score: 80),
    ];

    when(() => mockPlayerRepository.getPlayersRanking(limit: 10))
        .thenAnswer((_) async => mockPlayers);

    await createScreen(tester);
    await tester.pumpAndSettle();

    final containerFinder = find.byWidgetPredicate((widget) =>
    widget is Container &&
        widget.decoration is BoxDecoration &&
        (widget.decoration as BoxDecoration).image != null);

    expect(containerFinder, findsOneWidget);

    final containerWidget = tester.widget<Container>(containerFinder.first);
    final boxDecoration = containerWidget.decoration as BoxDecoration;
    final decorationImage = boxDecoration.image as DecorationImage;
    final imageProvider = decorationImage.image;

    expect(imageProvider, isA<AssetImage>());
    expect((imageProvider as AssetImage).assetName, 'assets/background/dice_background.jpg');
  });

  testWidgets('ScoreboardScreen displays Home button  correctly', (WidgetTester tester) async {
  final List<PlayerDTO> mockPlayers = [];

  when(() => mockPlayerRepository.getPlayersRanking(limit: 10))
      .thenAnswer((_) async => mockPlayers);

  await createScreen(tester);
  await tester.pumpAndSettle();
  expect(find.text('Home'), findsOneWidget);
  });
}
