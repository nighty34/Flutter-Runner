

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/components/movement_component.dart';
import 'package:flutter_game/game/game_core.dart';
import 'package:provider/provider.dart';

import 'elements/Actor.dart';


class SSPEngine extends GameEngine {



  @override
  void stateChanged(GameState oldState, GameState newState) {
    // TODO: implement stateChanged
  }

  @override
  void updatePhysics(int tickCounter) {
    // TODO: implement updatePhysics
    if(tickCounter==1){
      print("Start");
      createActors().forEach((element) {addActor(element);});
    }
    super.updatePhysics(tickCounter);
  }



  List createActors(){
    var actors = List.empty();
    Actor mainActor = Actor(Offset(0,1), "graphics/actor.png", 200);
    mainActor.addComponent(new Movement(mainActor));

    actors.add(mainActor);
    return actors;
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
    GameEngine engine = Provider.of<GameEngine>(context);

    return Stack(
      children: engine.AllActors,
    );
  }

}