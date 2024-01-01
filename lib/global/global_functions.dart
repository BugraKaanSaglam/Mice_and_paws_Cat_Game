import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'global_variables.dart';

AppBar mainAppBar(String title, BuildContext context, bool hasBackButton) {
  Widget? leading = const SizedBox();
  if (hasBackButton) {
    leading = BackButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/main_screen', (route) => false));
  }
  return AppBar(title: Text(title), centerTitle: true, leading: leading);
}

AppBar gameAppBar({required String title, required BuildContext context, required bool hasBackButton, required int timerTicks, required int maxTime}) {
  Widget? leading = const SizedBox();

  if (hasBackButton) {
    leading = BackButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/main_screen', (route) => false));
  }

  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text('Timer: $timerTicks'), const SizedBox(width: 10), const Text("Fare Sayısı")],
    ),
    centerTitle: true,
    leading: leading,
  );
}

class TopBar extends PositionComponent with HasGameRef {
  TopBar();
  late int countdown;
  late Timer timer;

  @override
  Future<void> onLoad() async {
    size = Vector2(gameRef.size.x, gameScreenTopBarHeight);
    position = Vector2(0, 0);
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    // Draw the top bar background
    canvas.drawRect(size.toRect(), Paint()..color = Colors.purpleAccent);
    // Draw the countdown on the top bar
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
      text: TextSpan(
        text: 'Countdown: $countdown',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Position the countdown text in the center of the top bar
    final textPosition = Offset(
      (size.x - textPainter.width) / 2,
      (size.y - textPainter.height) / 2,
    );

    // Draw the countdown text on the canvas
    textPainter.paint(canvas, textPosition);
  }
}
