

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_game/game/components/base_component.dart';
import 'package:flutter_game/game/elements/Actor.dart';


/**
 * This is basically the floor
 */
class Platform extends base_component{

  final Random _random = new Random();

  Platform(Actor parent) : super(parent) {}

  static const int maxHeight = 700;
  static const int minHeight = 500;
  static const int heightOffset = 250;

  double _currentHeight = 500;
  double get currentHeight => _currentHeight - heightOffset;


  /*
  =============================
  METHODS
  =============================
   */


  @override
  update() {}

  //Get a new random height
  void generateNew(){
      int newHeight = (_random.nextInt(maxHeight-minHeight)+minHeight).round();
      _currentHeight = newHeight + 0;
      parent.offset = new Offset(parent.offset.dx, newHeight + 0);
  }

}