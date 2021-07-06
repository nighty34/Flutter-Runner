import 'package:flutter_game/game/elements/Actor.dart';

/**
 * Abstract Component class
 */
abstract class base_component{

  Actor parent;

  base_component(this.parent);

  update();


}