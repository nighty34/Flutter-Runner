import 'package:flutter/cupertino.dart';
import 'package:flutter_game/game/components/base_component.dart';
import 'package:flutter_game/game/elements/Actor.dart';

class Movement extends base_component{
  bool isJumping = false;
  bool isOnGround = false;
  int timeLastJump = 0;
  static const int maxJumpTime = 60;
  static const double jumpDivider = 20;
  static const double fallingSpeed = 10;

  /**
   * Component that handels the movement of the main character
   */
  Movement(Actor parent) : super(parent); //Component Constructor

  @override
  update() {
    //OnGroundCheck
    if(parent.offset.dy>=300){
      isOnGround = true;
    }else{
      isOnGround = false;
    }
    //TODO: Check for actual ground - or work around a collision system

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
    }
  }

}