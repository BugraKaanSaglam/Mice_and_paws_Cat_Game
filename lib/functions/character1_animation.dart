// Load up the sprite sheet with an even step time framerate
import 'package:flame/sprite.dart';

SpriteAnimation getCharacter1Animation(dynamic boomImage) {
  const columns = 8;
  const rows = 8;
  const frames = columns * rows;
  final spriteImage = boomImage;
  final spritesheet = SpriteSheet.fromColumnsAndRows(image: spriteImage, columns: columns, rows: rows);
  final sprites = List<Sprite>.generate(frames, spritesheet.getSpriteById);
  return SpriteAnimation.spriteList(sprites, stepTime: 0.1);
}
