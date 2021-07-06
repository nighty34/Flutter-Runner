import 'package:flutter/cupertino.dart';
import 'package:flutter_game/game/components/base_component.dart';
import 'package:flutter_game/game/elements/Actor.dart';

class Movement extends base_component{
  bool isJumping = false;
  bool isOnGround = true;
  int timeLastJump = 0;
  static const int maxJumpTime = 3; //TODO: Tweak
  static const double jumpDivider = 10; //TODO: Tweak
  //Velocity?

  Movement(Actor parent) : super(parent);

  @override
  update() {
    if(isJumping){
      timeLastJump++;
      if(timeLastJump<=maxJumpTime){
        int velocity = maxJumpTime-timeLastJump;
        parent.offset = Offset(parent.offset.dx, parent.offset.dy + velocity);
      }else{
        if(isOnGround){
          isJumping = false;
          timeLastJump = 0;
        }
      }
    }
  }

  jump(){
    print("Jump");
    if(isJumping){
      return;
    }else{
      isJumping = true;
    }

  }

}