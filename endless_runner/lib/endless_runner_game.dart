import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

final Random _random = Random();

class EndlessRunnerGame extends FlameGame {
  static const int lanes = 3;
  int playerLane = 1;
  late PlayerComponent player;
  double _obstacleTimer = 0;
  double _obstacleInterval = 1.2; // seconds

  @override
  Future<void> onLoad() async {
    player = PlayerComponent();
    add(player);
    // Add keyboard listener for desktop
    add(_LaneKeyboardListener(onLeft: () => switchLane(-1), onRight: () => switchLane(1)));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _obstacleTimer += dt;
    if (_obstacleTimer > _obstacleInterval) {
      _obstacleTimer = 0;
      int lane = (_random.nextDouble() * lanes).floor();
      add(ObstacleComponent(lane: lane));
    }
  }

  void switchLane(int direction) {
    int newLane = playerLane + direction;
    if (newLane >= 0 && newLane < lanes) {
      playerLane = newLane;
      player.moveToLane(playerLane);
    }
  }

  // For swipe gestures, use a Flutter overlay in main.dart
}

class PlayerComponent extends SpriteComponent {
  PlayerComponent() : super(size: Vector2(64, 128));

  void moveToLane(int lane) {
    double laneWidth = 100;
    position.x = lane * laneWidth + 50;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad(); // It's good practice to call super.onLoad()
    sprite = Sprite(await Flame.images.load('player.png'));
    moveToLane(1);
    position.y = 400;
  }
}

class ObstacleComponent extends RectangleComponent {
  final int lane;
  final double speed;

  ObstacleComponent({required this.lane, this.speed = 200})
      : super(
          size: Vector2(64, 64),
          paint: Paint()..color = const Color(0xFFB71C1C),
        );

  @override
  Future<void> onLoad() async {
    double laneWidth = 100;
    position.x = lane * laneWidth + 50;
    position.y = -size.y; // Start above the screen
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;
    if (position.y > 800) { // Off screen
      removeFromParent();
    }
  }
}

class _LaneKeyboardListener extends Component with KeyboardHandler {
  final VoidCallback onLeft;
  final VoidCallback onRight;
  _LaneKeyboardListener({required this.onLeft, required this.onRight});

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        onLeft();
        return true;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        onRight();
        return true;
      }
    }
    return false;
  }
}
