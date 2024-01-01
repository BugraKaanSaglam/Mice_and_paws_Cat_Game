// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:game_for_cats_flutter/database/db_error.dart';
import 'package:game_for_cats_flutter/database/db_helper.dart';
import 'package:game_for_cats_flutter/database/opc_database_list.dart';
import 'package:game_for_cats_flutter/global/argumentsender_class.dart';

import '../global/global_functions.dart';
import '../global/global_variables.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  OPCDataBase? _db;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: mainAppBar('Game Name', context, false), body: mainBody(context));
  }

  Widget mainBody(BuildContext context) {
    return FutureBuilder<OPCDataBase?>(
        future: DBHelper().getList(databaseVersion),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.data == null) {
                OPCDataBase initDataBase = OPCDataBase(ver: databaseVersion, languageCode: 0, musicVolume: 0.5, miceVolume: 1);
                DBHelper().add(initDataBase);
                _db = initDataBase;
              } else {
                _db = snapshot.data;
              }
              if (snapshot.hasError && _db == null) {
                return dbError(context);
              }
              return Column(children: [
                const Spacer(flex: 20),
                mainMenuButtons(context, 'Start!', '/game_screen', const Icon(Icons.arrow_right_alt_sharp), dataBase: _db),
                mainMenuButtons(context, 'Settings', '/settings_screen', const Icon(Icons.settings)),
                mainMenuButtons(context, 'How To Play?', '/howtoplay_screen', const Icon(Icons.menu_book)),
                mainMenuButtons(context, 'Credits', '/credits_screen', const Icon(Icons.pest_control_rodent_sharp)),
                const Spacer(flex: 1),
                exitButton(context),
              ]);

            default:
              return dbError(context);
          }
        });
  }

//* Buttons
  ElevatedButton mainMenuButtons(BuildContext context, String buttonString, String adressString, Icon buttonIcon, {OPCDataBase? dataBase}) {
    ArgumentSender? argumentSender;

    argumentSender = ArgumentSender(title: buttonString, dataBase: dataBase);

    return ElevatedButton(
      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, adressString, (route) => false, arguments: argumentSender),
      child: Row(children: [Text(buttonString), buttonIcon]),
    );
  }

  ElevatedButton exitButton(BuildContext context) {
    return ElevatedButton(onPressed: () => exit(0), child: const Row(children: [Text('Exit'), Icon(Icons.exit_to_app_outlined)]));
  }
}
