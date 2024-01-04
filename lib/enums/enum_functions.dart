import 'package:game_for_cats_flutter/enums/game_enums.dart';
import 'package:game_for_cats_flutter/global/global_variables.dart';

Language getLanguageFromValue(int? value) {
  switch (value) {
    case 0:
      return Language.turkish;
    case 1:
      return Language.english;
    default:
      return Language.english;
  }
}

Difficulty getDifficultyFromValue(int? value) {
  switch (value) {
    case 0:
      gameDifficultyTimer = 100;
      return Difficulty.easy;
    case 1:
      gameDifficultyTimer = 75;
      return Difficulty.medium;
    case 2:
      gameDifficultyTimer = 50;
      return Difficulty.hard;
    case 3:
      gameDifficultyTimer = 100000;
      return Difficulty.sandbox;
    default:
      return Difficulty.easy;
  }
}
