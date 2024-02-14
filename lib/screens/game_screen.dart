// ignore_for_file: must_be_immutable, use_build_context_synchronously
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
import 'package:game_for_cats_flutter/main.dart';
import 'package:game_for_cats_flutter/objects/mice.dart';
import '../global/global_images.dart';
import '../utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ArgumentSender;
    return GameWidget(game: Game(args.dataBase, context));
  }
}

class Game extends FlameGame with TapDetector, DoubleTapDetector, HasGameRef, HasCollisionDetection {
  Game(this.gameDataBase, this.context);
  BuildContext context;
  OPCDataBase? gameDataBase;
  bool isGameRunning = true; // Is Game Running ?

  late ButtonComponent backButton;
  bool isBackButtonDialogOpen = false;

  late Timer interval; // Time Variable
  int elapsedTicks = 0; // Seconds
  //* Clicks
  int wrongTaps = 0;
  int miceTaps = 0;
  //* Inside of Bar Parameters
  double barParametersHeight = 13;
  @override
  bool get debugMode => false;

  @override
  Future<void> onLoad() async {
    try {
      //Loading Audio
      await FlameAudio.audioCache.load('mice_tap.mp3');
      //Loading Images
      await Images().load('mice.png').then((value) => globalMiceImage = value);
      await Images().load('yellow_background.jpg').then((value) => globalYellowBackgroundImage = value);
      await Images().load('back_button.png').then((value) => globalBackButtonImage = value);
      await Images().load('character1_moving.png').then((value) => globalCharacter1Image = value);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.error),
              content: Text(e.toString()),
            );
          });
    }
    //Add Button
    backButton = ButtonComponent(
        button: PositionComponent(position: Vector2(20, 20), size: Vector2(40, 40)),
        position: Vector2(10, barParametersHeight),
        children: [SpriteComponent.fromImage(globalBackButtonImage)],
        onPressed: () => showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(seconds: 2), () => closeDialog());
              return backButtonDialog();
            }));

    add(backButton);

    //Add Collision
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
        if (elapsedTicks == gameTimer) {
          //End Game
          pauseEngine();
          showDialog(context: context, builder: (context) => endGameDialog());
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
    final touchPoint = info.eventPosition.global;
    children.any((component) {
      if (component is Mice && component.containsPoint(touchPoint)) {
        FlameAudio.play('mice_tap.mp3', volume: gameDataBase?.miceVolume ?? 1);
        miceTaps++;
        remove(component);
        return true;
      }
      return false;
    });
    wrongTaps++;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawImageRect(globalYellowBackgroundImage, const Rect.fromLTWH(0, 0, 6016, 4016), Rect.fromLTWH(0, 0, size.x, size.y), Paint());
    canvas.drawRect(Vector2(gameRef.size.x, gameScreenTopBarHeight).toRect(), Paint()..color = MainAppState().gameTheme.colorScheme.surface); //TopBar
    drawCountdown(canvas);
    super.render(canvas);
  }

  //* CountDown Text
  void drawCountdown(Canvas canvas) {
    const textStyle = TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold);
    final textPainter = TextPainter(
      text: TextSpan(text: '${AppLocalizations.of(context)!.countdown}: ${gameTimer - elapsedTicks}', style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Position the countdown text in the center of the top bar
    final textPosition = Offset((size.x - textPainter.width) / 2, barParametersHeight);

    // Draw the countdown text on the canvas
    textPainter.paint(canvas, textPosition);
  }

  //* Alert for End Game
  AlertDialog endGameDialog() {
    return AlertDialog(
        title: Text(AppLocalizations.of(context)!.game_over),
        content: Container(
          height: 100,
          decoration: BoxDecoration(border: Border.all(), color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Text("${AppLocalizations.of(context)!.micetap_count} $miceTaps"),
              const Spacer(flex: 1),
              Text("${AppLocalizations.of(context)!.wrongtap_count} $wrongTaps"),
              const Spacer(flex: 3),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => {
              gameRef.pauseEngine(),
              Navigator.pushNamedAndRemoveUntil(context, '/game_screen', (route) => false, arguments: ArgumentSender(title: "", dataBase: gameDataBase))
            },
            child: Text(AppLocalizations.of(context)!.tryagain_button),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/main_screen', (route) => false),
            child: Text(AppLocalizations.of(context)!.return_mainmenu_button),
          ),
        ]);
  }

  //* Alert for BackButtonClicked
  AlertDialog backButtonDialog() {
    isBackButtonDialogOpen = true;
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.exit_validation),
      content: Container(
        height: 100,
        decoration: BoxDecoration(border: Border.all(), color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.this_will_close_automatically_in_seconds),
            const Spacer(flex: 1),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              isBackButtonDialogOpen = false;
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.i_am_cat)),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/main_screen', (route) => false);
            isBackButtonDialogOpen = false;
          },
          child: Text(AppLocalizations.of(context)!.i_am_human),
        ),
      ],
    );
  }

  //* Function to close the dialog
  void closeDialog() {
    if (isBackButtonDialogOpen && context.mounted == true) {
      Navigator.pop(context);
    }
    isBackButtonDialogOpen = false;
  }
}
