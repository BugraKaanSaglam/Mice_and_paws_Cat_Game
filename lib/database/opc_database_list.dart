class OPCDataBase {
  OPCDataBase({required this.ver, required this.languageCode, required this.musicVolume, required this.miceVolume});
  late int ver;
  late int languageCode;
  late double musicVolume;
  late double miceVolume;

  Map<String, dynamic> toMap() {
    return {'Ver': ver, 'LanguageCode': languageCode, 'MusicVolume': musicVolume, 'MiceVolume': miceVolume};
  }

  OPCDataBase.fromMap(Map<String, dynamic> map) {
    ver = map['Ver'];
    languageCode = map['LanguageCode'];
    musicVolume = map['MusicVolume'];
    miceVolume = map['MiceVolume'];
  }

  // Implement toString to make it easier to see information about each column when using the print statement.
  @override
  String toString() {
    return '{Ver: $ver ,LanguageCode: $languageCode, MusicVolume: $musicVolume, MiceVolume: $miceVolume}';
  }
}
