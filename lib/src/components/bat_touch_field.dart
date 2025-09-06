import 'package:brick_braker_2d/src/brick_breaker_2d.dart';
import 'package:brick_braker_2d/src/components/bat.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class BatTouchField extends PositionComponent with DragCallbacks, HasGameReference<BrickBreaker> {
  final Bat bat;

  BatTouchField({
    required this.bat,
    required Vector2 size,
    required Vector2 position,
  }) : super(
          size: size,
          position: position,
          anchor: Anchor.center,
        ) {
    // Passive hitbox to detect drag/tap input without collision reactions
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    // Move the bat based on drag input within screen bounds
    bat.position.x = (bat.position.x + event.localDelta.x).clamp(0, game.size.x);
  }

  @override
  bool containsPoint(Vector2 point) {
    // Override containsPoint to accept input within this area
    return super.containsPoint(point);
  }

  
}
