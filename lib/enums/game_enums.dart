enum Language {
  turkish(0, "Türkçe", "tr"),
  english(1, "English", "en");

  const Language(this.value, this.name, this.shortName);
  final int value;
  final String name;
  final String shortName;
}

enum Difficulty {
  easy(0, 'Easy'),
  medium(1, 'Medium'),
  hard(2, 'Hard');

  const Difficulty(this.value, this.name);
  final int value;
  final String name;
}
