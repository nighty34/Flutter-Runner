import 'package:flutter_game/game/elements/Actor.dart';

abstract class base_component{

  Actor parent;

  base_component(this._parent);

  update();



}