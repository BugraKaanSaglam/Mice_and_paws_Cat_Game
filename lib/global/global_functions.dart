import 'package:flutter/material.dart';

AppBar mainAppBar(String title, BuildContext context, bool hasBackButton) {
  Widget? leading = const SizedBox();
  if (hasBackButton) {
    leading = BackButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/main_screen', (route) => false));
  }
  return AppBar(title: Text(title), centerTitle: true, leading: leading);
}
