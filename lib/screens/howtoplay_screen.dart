// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:game_for_cats_flutter/global/argumentsender_class.dart';
import '../global/global_functions.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ArgumentSender;

    return Scaffold(appBar: mainAppBar(args.title!, context, true), body: mainBody(context));
  }

  Widget mainBody(BuildContext context) {
    return const Column(children: []);
  }
}
