

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/components/movement_component.dart';
import 'package:flutter_game/game/components/paralax_component.dart';
import 'package:flutter_game/game/components/platform_component.dart';
import 'package:flutter_game/game/elements/SizeProviderWidget.dart';
import 'package:flutter_game/game/game_core.dart';
import 'package:provider/provider.dart';

import 'elements/Actor.dart';


class SSPEngine extends GameEngine {

  Actor? _player;
  List<Platform> _platforms = [];

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

    double _playerPosX = _player!.offset.dx;
    double distance = double.infinity;
    Platform? activePlatform;

    _platforms.forEach((platform) {
      //TODO: get active platform (platform Player was last on
    });

    //TODO: set Players floorlvl to currentPlatform

    //End of Evangelion or Gameloop
    if(activePlatform!.currentHeight >= _player!.offset.dy+2){
      stateChanged(GameState.running, GameState.endOfGame);
    }

    updateView();
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

    ActorWidget backgroundLayer = ActorWidget(Offset(0,0), "graphics/background.png", 450, name: "BackGround"); //BackgroundLayer
    actors.add(backgroundLayer);

    ActorWidget houseLayer = ActorWidget(Offset(0,200), "graphics/houseLayer.png", 300, name: "HouseLayer"); //BackgroundLayer
    houseLayer.brain.addComponent(new Paralax(houseLayer.brain, -0.3, () => {}));
    actors.add(houseLayer);

    ActorWidget roofLayer = ActorWidget(Offset(0,550), "graphics/houseTop.png", 400, name: "RoofLayer"); //BackgroundLayer
    Platform platform = new Platform(roofLayer.brain);
    roofLayer.brain.addComponent(platform);
    roofLayer.brain.addComponent(new Paralax(roofLayer.brain, -4, () => {platform.generateNew()}));
    _platforms.add(platform);
    actors.add(roofLayer);

    ActorWidget mainActor = ActorWidget(Offset(0,-1), "graphics/player.png", 300, name: "Player"); //PLAYER
    mainActor.brain.addComponent(new Movement(mainActor.brain));
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
  BuildContext? _context;

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
    _context = context;
    new Timer.periodic(Duration(milliseconds: 30), rebuildAllChildren);
    return SizeProviderWidget(onChildSize: (size) {
      engine.setGameSize(size!);
    },
        child: Stack(
        children: [Stack(
          children: engine.AllActors,
        ),
          Container(
            height: 200,
            width: 200,
            child: ElevatedButton(
              child: Text("Jump"),
              onPressed: () => {jump(context)},
            ),
          ),
          Container(
            height: 10,
            width: 10,
            child: ListView(
            ),
          )],
      )
    );
  }

  //jump again - View
  jump(BuildContext con){
    GameEngine engine = Provider.of<GameEngine>(con, listen: false);
    engine.inputHandler(["JUMP"]);
    rebuildAllChildren(con);
  }

  void rebuildAllChildren(dynamic notused) {
    BuildContext? context = this._context;
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }

}