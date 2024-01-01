enum Language {
  turkish(0, "Türkçe"),
  english(1, "English");

  const Language(this.value, this.name);
  final int value;
  final String name;
}

enum Difficulty {
  easy(0, 'Easy'),
  medium(1, 'Medium'),
  hard(2, 'Hard');

  const Difficulty(this.value, this.name);
  final int value;
  final String name;
}
