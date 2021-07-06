import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/elements/Actor.dart';
import 'package:provider/provider.dart';

class Game {
  final GameView gameView;
  final GameEngine gameEngine;
  Game(this.gameView, this.gameEngine);
}



abstract class GameView extends StatelessWidget{




  Widget getStartPageConent(BuildContext context);
  Widget getRunningPageContent(BuildContext context);
  Widget getEndOfGamePageContent(BuildContext context);

  GameView(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    GameEngine game = Provider.of<GameEngine>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: _getPageContents(context, game),
    );
  }
  
  Widget _getPageContents(BuildContext context, GameEngine game){
    switch (game.gameState) {
      case GameState.waitForStart:
        return getStartPageConent(context);
      case GameState.running:
        return getRunningPageContent(context);
      case GameState.endOfGame:
        return getEndOfGamePageContent(context);
      default:
        throw UnimplementedError("Invalid GameState");
    }
  }

}



enum GameState {
  waitForStart, running, endOfGame
}

abstract class GameEngine extends ChangeNotifier{
  Timer? _timer;
  GameState _gameState;
  int _tickCounter;
  GameEngine() : _gameState = GameState.waitForStart, _tickCounter = 0;

  List _allActors = List.empty();
  get AllActors => _allActors;

  addActor(Actor actor){
    _allActors.add(actor);
  }


  void stateChanged(GameState oldState, GameState newState);

    GameState get gameState => _gameState;
    set gameState(GameState newState){
    if(_gameState==newState) return;
    _gameState = newState;

    if(_gameState == GameState.running) {
      _startGameLoop();
    }else{
      _stopGameLoop();
    }

    updateView();
  }

  void _startGameLoop() {
    _stopGameLoop();
    _tickCounter = 0;
    _timer = new Timer.periodic(Duration(milliseconds: 20), _processTick);
  }

  void _stopGameLoop() {
    _timer?.cancel(); //eq. if(_timer!=null) {_timer.cancel();}
  }

  void updateView() {
    notifyListeners();
  }

  void _processTick(dynamic notUsed){
      ++_tickCounter;
      updatePhysics(_tickCounter);
  }



  void updatePhysics(int tickCounter){

  }

  int get tickCounter => _tickCounter;


}