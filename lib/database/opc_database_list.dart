class OPCDataBase {
  OPCDataBase({required this.ver, required this.languageCode, required this.musicVolume, required this.miceVolume, required this.time});
  late int ver;
  late int languageCode;
  late double musicVolume;
  late double miceVolume;
  late int time;

  Map<String, dynamic> toMap() => {'Ver': ver, 'LanguageCode': languageCode, 'MusicVolume': musicVolume, 'MiceVolume': miceVolume, 'Time': time};

  OPCDataBase.fromMap(Map<String, dynamic> map) {
    ver = map['Ver'];
    languageCode = map['LanguageCode'];
    musicVolume = map['MusicVolume'];
    miceVolume = map['MiceVolume'];
    time = map['Time'];
  }

  // Implement toString to make it easier to see information about each column when using the print statement.
  @override
  String toString() => '{Ver: $ver ,LanguageCode: $languageCode, MusicVolume: $musicVolume, MiceVolume: $miceVolume, Time: $time}';
}
