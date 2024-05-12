import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/components/jump_button.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';

class PixelAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late CameraComponent cam;
  Player player = Player(character: 'Mask Dude');
  late JoystickComponent joystick;
  bool showControls = false;
  bool playSounds = false;
  double soundVolume = 1.0;
  List<String> levelNames = [
    'Level-01',
    'Level-02',
  ];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();
    // Level world = Level(
    //   levelName: levelNames[currentLevelIndex],
    //   player: player,
    // );
    // add(world);
    // camera = CameraComponent.withFixedResolution(
    //   world: world,
    //   width: 640,
    //   height: 360,
    // );
    // camera.viewfinder.anchor = Anchor.topLeft;
    // add(camera);

    _loadLevel();
    // if (showControls) {
    //   addJoystick();
    //   camera.viewport.add(JumpButton()..priority = 2);
    // }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 2,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    cam.viewport.add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void loadNextLevel() {
    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      currentLevelIndex = 0;
      _loadLevel();
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      Level world = Level(
        levelName: levelNames[currentLevelIndex],
        player: player,
      );

      cam = CameraComponent.withFixedResolution(
        world: world,
        width: 640,
        height: 360,
      );

      cam.viewfinder.anchor = Anchor.topLeft;

      addAll([cam, world]);

      if (showControls) {
        addJoystick();
        cam.viewport.add(JumpButton()..priority = 2);
      }
    });
  }
}
