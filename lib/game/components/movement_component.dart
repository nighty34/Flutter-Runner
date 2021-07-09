import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/game/components/base_component.dart';
import 'package:flutter_game/game/elements/Actor.dart';

/**
 * Movement Controller - moves the Actor based on inputs
 */
class Movement extends base_component{
  bool isJumping = false;
  bool isOnGround = false;
  int timeLastJump = 0;
  static const int maxJumpTime = 60;
  static const double jumpDivider = 20;
  static const double fallingSpeed = 10;
  double _currentFloor = 300;
  final int _sensorThr = 1;

  /**
   * Component that handels the movement of the main character
   */
  Movement(Actor parent) : super(parent); //Component Constructor


  /*
  =============================
  METHODS
  =============================
   */
  @override
  update() {
    //OnGroundCheck
    if(parent.offset.dy>=_currentFloor){
      isOnGround = true;
    }else{
      isOnGround = false;
    }

    //Gravity
    if(!isOnGround && !isJumping){
      parent.offset = Offset(parent.offset.dx, parent.offset.dy + fallingSpeed);
    }

    //Jumping
    if(isJumping){
      timeLastJump++;
      if(timeLastJump<=maxJumpTime){ //Check for highest point
        double velocity = (maxJumpTime-timeLastJump)/jumpDivider; //slowly decrease velocity
        parent.offset = Offset(parent.offset.dx, parent.offset.dy + velocity*-1);
      }else{ //stop jumping when on highest point.
        isJumping = false;
        timeLastJump = 0;
      }
    }
  }

  jump(){ //Initialize jump
    if(!isJumping && isOnGround){
      isJumping = true;
      HapticFeedback.vibrate();
    }
  }

  //TODO: limit Movement
  move(double input){ //move sideways
    if(input>=_sensorThr){
      parent.offset = Offset(parent.offset.dx + 10, parent.offset.dy);
      print(parent.offset.dx);
    }

    if(input<=_sensorThr*-1){
      parent.offset = Offset(parent.offset.dx - 10, parent.offset.dy);
      print(parent.offset.dx);
    }
  }


  /*
  =============================
  GETTER AND SETTER
  =============================
   */


  double get currentFloor => _currentFloor;

  set currentFloor(double value) {
    _currentFloor = value;
  }
}