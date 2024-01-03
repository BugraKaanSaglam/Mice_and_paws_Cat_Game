import 'package:flutter/material.dart';

AppBar mainAppBar(String title, BuildContext context, bool hasBackButton) {
  Widget? leading = const SizedBox();
  if (hasBackButton) {
    leading = BackButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/main_screen', (route) => false));
  }
  return AppBar(title: Text(title), centerTitle: true, leading: leading);
}

/*
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
*/
TextStyle labelTextStyle() => const TextStyle(fontSize: 22, color: Colors.red, fontWeight: FontWeight.bold);
TextStyle normalTextStyle() => const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w300);
