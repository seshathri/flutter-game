import 'package:flutter_test/flutter_test.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:endless_runner/endless_runner_game.dart'; // Adjust with your actual game file path

void main() {
  // Ensure that Flutter bindings are initialized for Flame testing
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlayerComponent', () {
    testWithGame<EndlessRunnerGame>(
      'should load sprite on onLoad',
      () async {
        // Pre-clear cache if modifying Flame.images globally for tests
        Flame.images.clearCache();
        
        // Create and mount the component
        final playerComponent = PlayerComponent();
        
        // The game instance is provided by testWithGame
        // Adding the component to a game and waiting for it to be mounted
        // will trigger onLoad.
        await game.ensureAdd(playerComponent);
        
        // Assert that the sprite is loaded
        expect(playerComponent.sprite, isNotNull);
        
        // Optional: verify sprite dimensions or other properties if known
        // expect(playerComponent.sprite?.originalSize, Vector2(expectedWidth, expectedHeight));

        // Clean up cache after test if necessary, though testWithGame might handle some of this
        Flame.images.clearCache();
      },
      // You can provide a custom game instance if needed, otherwise a default EndlessRunnerGame is created.
      // createGame: () => EndlessRunnerGame(), 
    );
  });
}
