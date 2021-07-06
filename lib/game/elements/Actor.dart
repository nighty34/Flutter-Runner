import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Actor extends StatelessWidget{
  Offset offset;
  String spritePath;
  double size;
  Actor(this.offset, this.spritePath, this.size){

  }

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


}