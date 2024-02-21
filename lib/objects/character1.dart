import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:game_for_cats_flutter/global/global_images.dart';

import '../utils/utils.dart';

// Character1 class is a PositionComponent so we get the angle and position of the element.
class Character1 extends SpriteAnimationComponent with HasGameRef<FlameGame>, CollisionCallbacks {
  late Vector2 _velocity;
  late final double _speed;
  bool _isColliding = false;

  double acceleration = 2000.0;
  double friction = 0.1;
  double steeringFactor = 0.01;
  Vector2 target = Vector2.zero();

  Character1(Vector2 position, Vector2 velocity, double speed) {
    final List<Sprite> spriteList = [];

    for (int x = 0; x < globalCharacter1Image.height; x += 128) {
      // Assuming each sprite is 128x128 pixels
      for (int y = 0; y < globalCharacter1Image.width; y += 64) {
        spriteList.add(Sprite(globalCharacter1Image, srcSize: Vector2(128, 128)));
      }
    }
    super.position = position;
    super.size = Vector2(128, 128);
    super.anchor = Anchor.center;
    super.animation = SpriteAnimation.spriteList(spriteList, stepTime: 0.0001);
    _velocity = velocity;
    _speed = speed;
    add(RectangleHitbox());
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _velocity = (_velocity)..scaleTo(_speed);
    angle = _velocity.screenAngle();
    target = Utils.generateRandomPosition(gameRef.size, Vector2(0, 10));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Character1 && !_isColliding) {
      _isColliding = true;
      target = Utils.generateRandomPosition(gameRef.size, Vector2(0, 10));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    //Select Target Direction
    Vector2 directionToTarget = (target - position).normalized();

    //Add Acceleration
    Vector2 desiredVelocity = directionToTarget * acceleration;

    //Update Velocity
    _velocity += (desiredVelocity - _velocity) * steeringFactor;

    //Friction Added
    _velocity *= (1.0 - friction);

    //Max Speed Check
    if (_velocity.length > _speed) {
      _velocity = _velocity.normalized()..scaleTo(_speed);
    }

    //Update Position
    position += _velocity * dt;

    //New Target Added, When Character1 Get the Current Target
    if ((target - position).length < 10.0) {
      target = Utils.generateRandomPosition(gameRef.size, Vector2(0, 10));
    }

    //Don't Let It Go OutOfBounds
    if (Utils.isPositionOutOfBounds(gameRef.size, position)) {
      position = Utils.wrapPosition(gameRef.size, position);
    }

    //Update Character1 Angle
    angle = _velocity.screenAngle();
  }
}
