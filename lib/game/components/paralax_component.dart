

import 'dart:ui';

import 'package:flutter_game/game/components/base_component.dart';
import 'package:flutter_game/game/elements/Actor.dart';
import 'package:flutter_game/game/game_core.dart';


/**
 * Not a real Paralax since the game is moving non-stop - but it still
 */
class Paralax extends base_component{
  double _paralaxlvl;
  bool inital = true; //onStart?
  final Function _onRedraw;
  static const double movementSpeed = 1;
  int i = 10; //My way of starting on Frame 11


  Paralax(Actor _parent, this._paralaxlvl, this._onRedraw) : super(_parent){}


  /*
  =============================
  METHDOS
  =============================
   */

  @override
  update() {
    if(inital){ //onStart
      parent.setRepeatImg(true);
      parent.setClipping(true);
    }

    double movement = parent.offset.dx + (movementSpeed*_paralaxlvl);
    parent.offset = Offset(movement, parent.offset.dy);
    if(i<=0 && parent.offset.dx*-1>=GameEngine.gameSize.width){
      _onRedraw();
      parent.offset = Offset(0+GameEngine.gameSize.width, parent.offset.dy);
    }
    if(i>=0){
      i--;
    }
  }
}
