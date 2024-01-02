// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:game_for_cats_flutter/database/db_helper.dart';
import 'package:game_for_cats_flutter/enums/game_enums.dart';
import 'package:game_for_cats_flutter/global/argumentsender_class.dart';
import 'package:game_for_cats_flutter/main.dart';
import '../database/db_error.dart';
import '../database/opc_database_list.dart';
import '../functions/settings_form_functions.dart';
import '../global/global_functions.dart';
import '../global/global_variables.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  OPCDataBase? _db;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ArgumentSender;
    return Scaffold(appBar: mainAppBar(args.title!, context, true), body: mainBody(context));
  }

  Widget mainBody(BuildContext context) {
    return FutureBuilder<OPCDataBase?>(
        future: DBHelper().getList(databaseVersion),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return dbError(context);
              }
              _db = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [languageDropDownFormField(), difficultyDropDownFormField(), musicField(), miceSoundField(), saveButton()],
                ),
              );
            default:
              return dbError(context);
          }
        });
  }

//*FormFields
  Column languageDropDownFormField() {
    List<DropdownMenuItem> items = [
      DropdownMenuItem(value: Language.turkish.value, child: Text(Language.turkish.name)),
      DropdownMenuItem(value: Language.english.value, child: Text(Language.english.name)),
    ];
    return Column(
      children: [
        const Text('Select Language'),
        DropdownButtonFormField(
          dropdownColor: Colors.white,
          value: _db?.languageCode ?? 0,
          decoration: formDecoration(),
          items: items,
          onChanged: (value) => _db?.languageCode = value,
        ),
      ],
    );
  }

  Column difficultyDropDownFormField() {
    List<DropdownMenuItem> items = [
      DropdownMenuItem(value: Difficulty.easy.value, child: Text(Difficulty.easy.name)),
      DropdownMenuItem(value: Difficulty.medium.value, child: Text(Difficulty.medium.name)),
      DropdownMenuItem(value: Difficulty.hard.value, child: Text(Difficulty.hard.name)),
    ];
    return Column(
      children: [
        const Text('Select Difficulty'),
        DropdownButtonFormField(
          dropdownColor: Colors.white,
          value: _db?.difficulty ?? 0,
          decoration: formDecoration(),
          items: items,
          onChanged: (value) => _db?.difficulty = value,
        ),
      ],
    );
  }

  StatefulBuilder musicField() {
    return StatefulBuilder(
      builder: (context, musicState) {
        return Column(
          children: [
            const Text('Select Music Volume'),
            Slider(
              min: 0,
              max: 1,
              value: _db!.musicVolume.toDouble(),
              onChanged: (newValue) {
                musicState(() => _db!.musicVolume = newValue);
              },
            ),
          ],
        );
      },
    );
  }

  StatefulBuilder miceSoundField() {
    return StatefulBuilder(
      builder: (context, miceSoundState) {
        return Column(
          children: [
            const Text('Select Mice Volume'),
            Slider(
              min: 0,
              max: 1,
              value: _db!.miceVolume.toDouble(),
              onChanged: (newValue) {
                miceSoundState(() => _db!.miceVolume = newValue);
              },
            ),
          ],
        );
      },
    );
  }

  ElevatedButton saveButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          DBHelper().update(_db!);
          MainApp.of(context)!.setLocale(_db!.languageCode);
        });
      },
      child: const Text('Save'),
    );
  }
}
