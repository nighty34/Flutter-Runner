

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/components/movement_component.dart';
import 'package:flutter_game/game/game_core.dart';
import 'package:provider/provider.dart';

import 'elements/Actor.dart';


class SSPEngine extends GameEngine {

  Actor? _player;

  @override
  void stateChanged(GameState oldState, GameState newState) {
    // TODO: implement stateChanged
  }

  @override
  void updatePhysics(int tickCounter) {
    super.updatePhysics(tickCounter);
    // TODO: implement updatePhysics
    if(tickCounter==1){
      print("Start");
      createActors().forEach((element) {addActor(element);});
    }


  }


  @override
  void inputHandler(List<String> commands) {
    commands.forEach((cmd) {
      switch(cmd){
        case "JUMP":
          jump();
          break;
        case "RIGHT":
          break;

        default:
          return;
      }
    });
  }

  List<Actor> createActors(){
    List<Actor> actors = [];
    Actor mainActor = Actor(Offset(0,1), "graphics/actor.png", 200);
    mainActor.addComponent(new Movement(mainActor));

    actors.add(mainActor);
    _player = mainActor;
    return actors;
  }

  jump(){
    _player!.GetComponent<Movement>().jump();
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
        children: [Stack(
          children: engine.AllActors,
        ),
          Container(
            height: 200,
            width: 200,
            child: ElevatedButton(
              child: Text("Jump"),
              onPressed: () => jump(context),
            ),
          ),
          Container(
            height: 10,
            width: 10,
            child: ListView(
            ),
          )],
    );
  }

  jump(BuildContext con){
    GameEngine engine = Provider.of<GameEngine>(con, listen: false);
    engine.inputHandler(["JUMP"]);
  }

}