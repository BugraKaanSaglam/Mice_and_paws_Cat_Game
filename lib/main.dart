import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:game_for_cats_flutter/screens/credits_screen.dart';
import 'package:game_for_cats_flutter/screens/game_screen.dart';
import 'package:game_for_cats_flutter/screens/howtoplay_screen.dart';
import 'package:game_for_cats_flutter/screens/main_screen.dart';
import 'package:game_for_cats_flutter/screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: gameTheme,
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
      routes: {
        '/main_screen': (context) => const MainScreen(),
        '/settings_screen': (context) => const SettingsScreen(),
        '/credits_screen': (context) => const CreditsScreen(),
        '/howtoplay_screen': (context) => const HowToPlayScreen(),
        '/game_screen': (context) => const GameScreen(),
      },
    );
  }

  ThemeData gameTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    canvasColor: Colors.green,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Colors.white, //General Text Color
      onPrimary: Colors.black, //X
      secondary: Colors.black, //X
      onSecondary: Colors.black, //X
      error: Colors.red, //Validation Errors (Not Needed)
      onError: Colors.white, //Validation Errors Text (Not Needed)
      background: Colors.yellow, //True Background Color
      onBackground: Colors.black, //X
      surface: Colors.purpleAccent, //App Color
      onSurface: Colors.black, //AppBar Text Color
    ),
  );
}
