import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_game/game/components/base_component.dart';


/**
 * Master-Class for all the objects on the playingfield - planning on adding an additonal abstract layer infront of this class
 */
class Actor extends StatelessWidget{
  Offset offset;
  String spritePath;
  double size;
  String? name; //TODO: Optional?
  bool _repeatImg = false;
  bool _clipImg = true;




  List<base_component?> _components;

  Actor(this.offset, this.spritePath, this.size) : _components = [];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(offset.dx, offset.dy), //Position of object
      child: Container( //Size of Object
        clipBehavior: Clip.none,
        height: size,
        width: size,
        child: Image(image: AssetImage(spritePath),repeat: _repeatImg ? ImageRepeat.repeatX : ImageRepeat.noRepeat, fit: _clipImg ? BoxFit.fitHeight : BoxFit.none),
      ),
    );
  }

  void setRepeatImg(bool repeat) {
    _repeatImg = repeat;
  }

  void setClipping(bool clip){

  }


   //Classic update function
  update(){
    _components.forEach((element) {element?.update();});
    //TODO: Actor Loop - put into Abstract parent class
    new ActorNotifyer();
  }

  //Add Components via Code
  addComponent(base_component component){
    _components.add(component);
  }


  //Should work like in Unity - limited to 1 component of each kind.
  T GetComponent<T>(){
    var com;
    _components.forEach((component) {
      if(component.runtimeType==T){
        com = component;
      }
    });
    return com;
  }
}


class ActorNotifyer extends ChangeNotifier{
  ActorNotifyer(){
    notifyListeners();
  }
}