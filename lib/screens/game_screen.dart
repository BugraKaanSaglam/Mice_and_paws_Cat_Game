// ignore_for_file: must_be_immutable
import 'dart:async';
import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:game_for_cats_flutter/database/opc_database_list.dart';
import 'package:game_for_cats_flutter/global/argumentsender_class.dart';
import 'package:game_for_cats_flutter/global/global_variables.dart';
import 'package:game_for_cats_flutter/objects/mouse.dart';
import '../global/global_images.dart';
import '../utils/utils.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ArgumentSender;
    return GameWidget(game: Game(args.dataBase));
  }
}

class Game extends FlameGame with TapDetector, DoubleTapDetector, HasGameRef, HasCollisionDetection {
  Game(this.gameDataBase);
  OPCDataBase? gameDataBase;
  bool isGameRunning = true; // Is Game Running ?

  late Timer interval; // Time Variable
  int elapsedTicks = 0; // Seconds
  @override
  bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    //Loading Audio
    await FlameAudio.audioCache.load('mice_tap.mp3');
    //Loading Images
    await Images().load('mice.png').then((value) => globalMiceImage = value);
    await Images().load('yellow_background.jpg').then((value) => globalYellowBackgroundImage = value);
    //Add Button

    add(ScreenHitbox());

    interval = Timer(
      1.0,
      onTick: () {
        if (elapsedTicks % 5 == 0) {
          //Adding Mice Every 5 Seconds
          Vector2 startPosition = Vector2(0, gameScreenTopBarHeight + Random().nextDouble() * (size.y - gameScreenTopBarHeight));
          Vector2 startRndVelocity = Utils.generateRandomVelocity(size, 10, 100);
          double startingSpeed = 50;
          Mice mice = Mice(startPosition, startRndVelocity, startingSpeed);
          add(mice);
        }
        if (elapsedTicks == 100) {
          //End Game
          pauseEngine();
          showDialog(
            context: buildContext!,
            builder: (context) {
              return const Column();
            },
          );
        }
        elapsedTicks++;
      },
      repeat: true,
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    final touchPoint = info.eventPosition.game;
    children.any((component) {
      if (component is Mice && component.containsPoint(touchPoint)) {
        FlameAudio.play('mice_tap.mp3', volume: gameDataBase?.miceVolume ?? 1);
        remove(component);
        return true;
      }
      return false;
    });
  }

  @override
  void render(Canvas canvas) {
    canvas.drawImageRect(globalYellowBackgroundImage, const Rect.fromLTWH(0, 0, 6016, 4016), Rect.fromLTWH(0, 0, size.x, size.y), Paint());
    canvas.drawRect(Vector2(gameRef.size.x, gameScreenTopBarHeight).toRect(), Paint()..color = Colors.purpleAccent); //TopBar
    drawCountdown(canvas);
    super.render(canvas);
  }

  void drawCountdown(Canvas canvas) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: 'Countdown: $elapsedTicks', style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Position the countdown text in the center of the top bar
    final textPosition = Offset((size.x - textPainter.width) / 2, gameScreenTopBarHeight / 2);

    // Draw the countdown text on the canvas
    textPainter.paint(canvas, textPosition);
  }
}

class MyButton extends PositionComponent with TapCallbacks {
  bool isTapping = false;

  @override
  void onTapDown(TapDownEvent event) {
    isTapping = true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    isTapping = true;
  }
}
