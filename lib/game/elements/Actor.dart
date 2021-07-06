import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_game/game/components/base_component.dart';

class Actor extends StatelessWidget{
  Offset offset;
  String spritePath;
  double size;

  List<base_component> components;

  Actor(this.offset, this.spritePath, this.size) : components = List.empty();

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment(offset.dx, offset.dy), //Position of object
      child: Container( //Size of Object
        height: size,
        width: size,
        child: Image(image: AssetImage(spritePath)),
      ),
    );
  }

  update(){
    components.forEach((element) {element.update();});
    //TODO: Actor Loop - put into Abstract parent class
  }





}