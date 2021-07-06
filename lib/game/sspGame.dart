

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/elements/Actor.dart';
import 'package:flutter_game/game/game_core.dart';
import 'package:provider/provider.dart';


class SSPEngine extends GameEngine {
  @override
  void stateChanged(GameState oldState, GameState newState) {
    // TODO: implement stateChanged
  }

  @override
  void updatePhysics(int tickCounter) {
    // TODO: implement updatePhysics
    super.updatePhysics(tickCounter);
  }



}


class SSPView extends GameView{

  SSPView(String title) : super(title);

  @override
  getEndOfGamePageContent(BuildContext context){
    GameEngine engine = Provider.of<GameEngine>(context);
    return ElevatedButton(
        onPressed: () => {engine.gameState = GameState.running},
        child: Column(
        children: [
          Text('Restart Game')
      ],
    ));
  }

  @override
  Widget getStartPageConent(BuildContext context) {
    GameEngine engine = Provider.of<GameEngine>(context);
    return ElevatedButton(
        onPressed: () => {engine.gameState = GameState.running},
        child: Column(
          children: [
            Text('Start Game')
          ],
        ));
  }

  @override
  Widget getRunningPageContent(BuildContext context) {
    return Stack(
      children: [
        Actor(Offset(1, 1), "graphics/actor.png", 200),
        Actor(Offset(1, -1), "graphics/actor.png", 200),
        Actor(Offset(-1, 1), "graphics/actor.png", 200)
      ],
    );
  }
}