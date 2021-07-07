
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/components/base_component.dart';


/**
 * Master-Class for all the objects on the playingfield - planning on adding an additonal abstract layer infront of this class
 */
class Actor extends State<ActorWidget>{
  String spritePath;
  double size;
  String? name; //TODO: Optional?
  bool _repeatImg = false;
  bool _clipImg = true;
  Offset _offset;

  int frame = 0;


  Offset get offset => _offset;

  set offset(Offset value) {
    _offset = value;
  }

  List<base_component?> _components;

  Actor(this._offset, this.spritePath, this.size, {this.name = ""}) : _components = [];


  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _offset.dy,
      left: _offset.dx,
      child: Container( //Size of Object
        clipBehavior: Clip.none,
        color: Colors.green,
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
    _clipImg = clip;
  }


   //Classic update function
  update(){
    _components.forEach((comp) {comp?.update();});
    //TODO: Actor Loop - put into Abstract parent class
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


class ActorWidget extends StatefulWidget{
  ActorWidget(this._offset, this._spritePath, this._size, {Key? key, this.name = ""}) : super(key: key){
    this.brain = Actor(_offset, _spritePath, _size);
  }

  Offset _offset;
  String _spritePath;
  String name;
  double _size;
  late Actor brain;




  @override
  Actor createState(){
    if(brain==null) {
      Actor _brain = Actor(_offset, _spritePath, _size, name: name);
      this.brain = _brain;
      print("Brain null");
    }
    return brain;
  }
}
