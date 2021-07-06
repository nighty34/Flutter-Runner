import 'package:flutter/cupertino.dart';
import 'package:flutter_game/game/components/base_component.dart';
import 'package:flutter_game/game/elements/Actor.dart';

class Movement extends base_component{
  bool isJumping = false;
  bool isOnGround = false;
  int timeLastJump = 0;
  static const int maxJumpTime = 20; //TODO: Tweak
  static const double jumpDivider = 50; //TODO: Tweak
  static const double fallingSpeed = -0.2;
  //Velocity?

  Movement(Actor parent) : super(parent);

  @override
  update() {
    if(parent.offset.dy<=0){
      isOnGround = true;
    }else{
      isOnGround = false;
    }
    if(!isOnGround && !isJumping){
      parent.offset = Offset(parent.offset.dx, parent.offset.dy + fallingSpeed);
    }

    if(isJumping){
      timeLastJump++;
      if(timeLastJump<=maxJumpTime){
        double velocity = (maxJumpTime-timeLastJump)/jumpDivider;
        print(velocity);

        parent.offset = Offset(parent.offset.dx, parent.offset.dy + velocity);
        print(parent.offset);
      }else{
        isJumping = false;
        timeLastJump = 0;
      }
    }
  }


  jump(){
    if(isJumping){
      return;
    }else{
      isJumping = true;
    }

  }

}