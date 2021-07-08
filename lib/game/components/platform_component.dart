

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_game/game/components/base_component.dart';
import 'package:flutter_game/game/elements/Actor.dart';
import 'package:flutter_game/game/game_core.dart';

class Platform extends base_component{

  final Random _random = new Random();

  Platform(Actor parent) : super(parent) {
  }



  static const int maxHeight = 700;
  static const int minHeight = 500;

  int _currentHeight = 0;
  int get currentHeight => _currentHeight;

  @override
  update() {

  }

  void generateNew(){
        int newHeight = (_random.nextInt(maxHeight-minHeight)+minHeight).round();
      _currentHeight = newHeight;
      parent.offset = new Offset(parent.offset.dx, newHeight + 0);
      print("NEW HEIGHT");
  }




}