
import 'package:flutter_game/game/components/base_component.dart';
import 'package:flutter_game/game/elements/Actor.dart';

class Animator extends base_component{

  int _currentFrame = 0;
  int _waitFrames = 0;
  int _speed;
  int _finalFrame;
  String _spriteName;

  //Animations start at Frame 0
  Animator(Actor _parent, this._spriteName, this._finalFrame, this._speed): super(_parent){

  }


  @override
  update() {
    _waitFrames++;
    if(_waitFrames>=_speed){
      _waitFrames=0;
      _currentFrame++;
    }
    if(_currentFrame>_finalFrame){
      _currentFrame=0;
    }

    String frameName = "${_spriteName}_${_currentFrame}.png";
    parent.spritePath = frameName;
  }
}