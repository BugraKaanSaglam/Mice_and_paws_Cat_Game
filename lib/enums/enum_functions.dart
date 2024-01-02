import 'package:game_for_cats_flutter/enums/game_enums.dart';

Language getLanguageFromValue(int value) {
  switch (value) {
    case 0:
      return Language.turkish;
    case 1:
      return Language.english;
    default:
      return Language.turkish;
  }
}
