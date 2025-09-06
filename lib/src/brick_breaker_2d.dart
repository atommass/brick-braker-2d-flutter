import 'dart:async';
import 'dart:math' as math;

import 'package:brick_braker_2d/src/components/bat_touch_field.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/components.dart';
import 'config.dart';
import 'components/levels.dart';

enum PlayState { welcome, playing, gameOver, won, lifeLost }

class BrickBreaker extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapDetector {
  BrickBreaker()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  final ValueNotifier<int> score = ValueNotifier(0);
  final ValueNotifier<int> levelCard = ValueNotifier(1);
  final ValueNotifier<int> lives = ValueNotifier(3);
  final rand = math.Random();
  double get width => size.x;
  double get height => size.y;

  late int level;
  late double difficulty;
  late PlayState _playState;
  PlayState get playState => _playState;

  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
      case PlayState.gameOver:
      case PlayState.won:
      case PlayState.lifeLost:
        overlays.add(playState.name);
        break;
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
        overlays.remove(PlayState.lifeLost.name);
        break;
    }
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());

    level = 1;
    difficulty = 1.0;
    playState = PlayState.welcome;
  }

  void startGame() {
    if (playState == PlayState.playing) return;

    overlays.remove(PlayState.welcome.name);
    overlays.remove(PlayState.gameOver.name);
    overlays.remove(PlayState.won.name);
    overlays.remove(PlayState.lifeLost.name);

    if (playState == PlayState.lifeLost) {
      lives.value--;
      if (lives.value <= 0) {
        playState = PlayState.gameOver;
        return;
      }
    }

    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());
    world.removeAll(world.children.query<BatTouchField>());

    if (playState == PlayState.won) {
      level++;
      lives.value--;
      difficulty *= 1.02;
      levelCard.value = level;
      if (level > brickLevels.length) {
        playState = PlayState.won;
        return;
      }
    }

    if (playState == PlayState.gameOver) {
      level = 1;
      difficulty = 1.0;
      score.value = 0;
      lives.value = 3;
      levelCard.value = 1;
    }

    playState = PlayState.playing;
    //score.value = 0;

    world.add(
      Ball(
        difficultyModifier: difficulty,
        radius: ballRadius,
        position: size / 2,
        velocity: Vector2(
          (rand.nextDouble() - 0.5) * width,
          height * 0.2,
        ).normalized()..scale(height / 4),
      ),
    );

    final bat = Bat(
      size: Vector2(batWidth, batHeight),
      cornerRadius: const Radius.circular(ballRadius / 2),
      position: Vector2(width / 2, height * 0.95),
    );
    world.add(bat);

    final touchFieldWidth = width;
    final touchFieldHeight = batHeight * 5;
    final touchFieldY = bat.position.y;

    world.add(
      BatTouchField(
        bat: bat,
        size: Vector2(touchFieldWidth, touchFieldHeight),
        position: Vector2(width / 2, touchFieldY),
      ),
    );

    final levelLayout = brickLevels[level - 1];

    world.addAll([
      for (var i = 0; i < levelLayout.length; i++)
        for (var j = 0; j < levelLayout[i].length; j++)
          if (levelLayout[i][j] == 'x')
            Brick(
              position: Vector2(
                (j + 0.5) * brickWidth + (j + 1) * brickGutter,
                (i + 2.0) * brickHeight + i * brickGutter,
              ),
              color: brickColors[j % brickColors.length],
            ),
    ]);
  }

  @override
  void onTap() {
    super.onTap();
    startGame();
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    super.onKeyEvent(event, keysPressed);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        world.children.query<Bat>().first.moveBy(-batStep);
      case LogicalKeyboardKey.arrowRight:
        world.children.query<Bat>().first.moveBy(batStep);
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.enter:
        startGame();
    }
    return KeyEventResult.handled;
  }

  @override
  Color backgroundColor() => const Color(0xfff2e8cf);
}
