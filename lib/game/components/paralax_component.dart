

import 'dart:ui';

import 'package:flutter_game/game/components/base_component.dart';
import 'package:flutter_game/game/elements/Actor.dart';


/**
 * Not a real Paralax since the game is moving non-stop - but it still
 */
class Paralax extends base_component{
  double _paralaxlvl;
  bool inital = true;
  static const double movementSpeed = 1; //TODO: Tweak

  Paralax(Actor _parent, this._paralaxlvl) : super(_parent){

  }

  @override
  update() {
    if(inital){
      parent.setRepeatImg(true);
      parent.setClipping(false);
    }
    double movement = parent.offset.dx + (movementSpeed*_paralaxlvl);
    parent.offset = Offset(movement, parent.offset.dy);
  }
}
