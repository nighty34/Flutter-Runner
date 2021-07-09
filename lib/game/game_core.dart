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


/**
 * Abstract GameView
 */
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

  //Get the right Content
  Widget _getPageContents(BuildContext context, GameEngine game){
    switch (game.gameState) {
      case GameState.waitForStart:
        return getStartPageConent(context); //or Conent
      case GameState.running:
        return getRunningPageContent(context);
      case GameState.endOfGame:
        return getEndOfGamePageContent(context);
      default:
        throw UnimplementedError("Invalid GameState");
    }
  }
}


//Gamestates
enum GameState {
  waitForStart, running, endOfGame
}


/**
 * Abstract GameEngine - Handels some stuff in the background
 */
abstract class GameEngine with ChangeNotifier{
  Timer? _timer;
  GameState _gameState;
  int _tickCounter;
  GameEngine() : _gameState = GameState.waitForStart, _tickCounter = 0;
  static Size? _gameSize; //ScreenSize
  int _score = 0;

  List<ActorWidget> _allActors = [];


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
    _allActors = [];
  }

  void updateView() {
    notifyListeners();
  }

  void _processTick(dynamic notUsed){
      ++_tickCounter;
      updatePhysics(_tickCounter);
      _allActors.forEach((actor) {
        actor.brain.update();
      });
  }

  void updatePhysics(int tickCounter){

  }

  void inputHandler(List<String> commands){

  }


  /*
  =============================
  GETTER AND SETTER
  =============================
   */

  get AllActors => _allActors;

  addActor(ActorWidget actor){
    _allActors.add(actor);
  }

  int get tickCounter => _tickCounter;

  setGameSize(Size value) {
    _gameSize = value;
  }

  static Size get gameSize => _gameSize!;

  int get score => _score;

  set score(int value) {
    _score = value;
  }
}