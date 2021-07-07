

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/components/movement_component.dart';
import 'package:flutter_game/game/components/paralax_component.dart';
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
    if(tickCounter==1){
      print("Start");
      createActors().forEach((element) {addActor(element);});
    }
  }

 //Weird way of handeling Inputs... hope it works
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

  //Spawn all the objects I need for the game
  List<ActorWidget> createActors(){
    List<ActorWidget> actors = [];

    ActorWidget backgroundLayer = ActorWidget(Offset(0,0.5), "graphics/cloudLayer.png", 500, name: "BackGround"); //BackgroundLayer
    backgroundLayer.brain?.addComponent(new Paralax(backgroundLayer.brain!, 200));
    actors.add(backgroundLayer);

    ActorWidget mainActor = ActorWidget(Offset(0,1), "graphics/actor.png", 200, name: "Player"; //PLAYER
    mainActor.brain?.addComponent(new Movement(mainActor.brain!));
    actors.add(mainActor);
    _player = mainActor.brain;

    return actors;
  }

  //jump
  jump(){
    _player?.GetComponent<Movement>().jump();
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
      clipBehavior: Clip.none,
        children: [Stack(
          clipBehavior: Clip.none,
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

  //jump again - View
  jump(BuildContext con){
    GameEngine engine = Provider.of<GameEngine>(con, listen: false);
    engine.inputHandler(["JUMP"]);
  }

}