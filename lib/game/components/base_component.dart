import 'package:flutter_game/game/elements/Actor.dart';

abstract class base_component{

  Actor _parent;

  base_component(this._parent);

  update();



}