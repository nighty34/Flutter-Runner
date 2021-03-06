import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game/components/animation_component.dart';
import 'package:flutter_game/game/components/movement_component.dart';
import 'package:flutter_game/game/components/paralax_component.dart';
import 'package:flutter_game/game/components/platform_component.dart';
import 'package:flutter_game/game/elements/SizeProviderWidget.dart';
import 'package:flutter_game/game/game_core.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensors.dart';

import 'elements/Actor.dart';


class SSPEngine extends GameEngine {

  Actor? _player;
  List<Platform> _platforms = [];
  double _input = 0;

  @override
  void stateChanged(GameState oldState, GameState newState) {
  }

  @override
  void updatePhysics(int tickCounter) {
    super.updatePhysics(tickCounter);
    if(tickCounter==1){ //onStart
      print("Start");
      createActors().forEach((element) {addActor(element);});
      gyroscopeEvents.listen((event) {_input = event.y;});
    }
    readSensors();
    this.score=tickCounter;

    double _playerPosX = _player!.offset.dx;
    double distance = double.infinity;
    Platform? activePlatform;

    //Get Active Platform
    _platforms.forEach((platform) {
      double dis = (_playerPosX - platform.parent.offset.dx).abs();
      if(dis<distance){
        distance=dis;
        activePlatform = platform;
      }
    });

    _player!.GetComponent<Movement>().currentFloor = activePlatform!.currentHeight; //set current height

    //End of Evangelion or Gameloop
    if(activePlatform!.currentHeight <= _player!.offset.dy-50) {
      this.gameState = GameState.endOfGame;
    }
    updateView();
  }

  //Weird way of handeling Inputs... hope it works - nope but I'll keep it for jumping
  @override
  void inputHandler(List<String> commands) {
    commands.forEach((cmd) {
      switch(cmd){
        case "JUMP":
          jump();
          break;
        default:
          return;
      }
    });
  }

  void readSensors(){
    _player!.GetComponent<Movement>().move(_input);
  }

  //Spawn all the objects I need for the game
  List<ActorWidget> createActors(){

    List<ActorWidget> actors = [];

    //BackGround
    ActorWidget backgroundLayer = ActorWidget(Offset(0,0), "graphics/background.png", 450, name: "BackGround"); //BackgroundLayer
    actors.add(backgroundLayer);

    //BackgroundLayer
    ActorWidget houseLayer = ActorWidget(Offset(0,200), "graphics/houseLayer.png", 300, name: "HouseLayer"); //BackgroundLayer
    houseLayer.brain.addComponent(new Paralax(houseLayer.brain, -0.3, () => {}));
    actors.add(houseLayer);

    //BackGroundLayer
    ActorWidget houseLayer2 = ActorWidget(Offset(300,200), "graphics/houseLayer.png", 300, name: "HouseLayer2"); //BackgroundLayer
    houseLayer2.brain.addComponent(new Paralax(houseLayer2.brain, -0.3, () => {}));
    actors.add(houseLayer2);

    //Platform
    ActorWidget roofLayer = ActorWidget(Offset(0,550), "graphics/houseTop.png", 400, name: "RoofLayer"); //BackgroundLayer
    Platform platform = new Platform(roofLayer.brain);
    roofLayer.brain.addComponent(platform);
    roofLayer.brain.addComponent(new Paralax(roofLayer.brain, -4, () => {platform.generateNew()}));
    _platforms.add(platform);
    actors.add(roofLayer);

    //Platform
    ActorWidget roofLayer2 = ActorWidget(Offset(600,550), "graphics/houseTop.png", 400, name: "RoofLayer2"); //BackgroundLayer
    Platform platform2 = new Platform(roofLayer2.brain);
    roofLayer2.brain.addComponent(platform2);
    roofLayer2.brain.addComponent(new Paralax(roofLayer2.brain, -4, () => {platform2.generateNew()}));
    _platforms.add(platform2);
    actors.add(roofLayer2);

    //Player
    ActorWidget mainActor = ActorWidget(Offset(0,-1), "graphics/player.png", 300, name: "Player"); //PLAYER
    mainActor.brain.addComponent(new Movement(mainActor.brain));
    mainActor.brain.addComponent(new Animator(mainActor.brain, "graphics/Einzelbild", 19, 4));
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
    String score = "Dein Score: ${engine.score}";
    return Stack(children: [
      Center(
        child: Container(
          height: 80,
          width: 200,
          child: ElevatedButton(
            onPressed: () => {engine.gameState = GameState.running},
            child: Column(
             children: [
                Center(child: Text('Restart Game'),)
              ],
            ),
          ),
        ),
      ),
      Center(
        heightFactor: 10,
        child: Card(
            child: Text(score, style: TextStyle(fontSize: 30),)
        )
      )
    ]);
  }

  @override
  Widget getStartPageConent(BuildContext context) {
    GameEngine engine = Provider.of<GameEngine>(context);
    return Center(
      child: Container(
        height: 80,
        width: 200,
        child:ElevatedButton(
          onPressed: () => {engine.gameState = GameState.running},
          child: Column(
            children: [
              Center(child: Text('Start Game'),)
            ],
          ),
        )
      ),
    );
  }


  @override
  Widget getRunningPageContent(BuildContext context) {
    GameEngine engine = Provider.of<GameEngine>(context);
    _context = context;

    String score = "${engine.score}";
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
          Positioned(
            left: 210,
            height: 30,
              width: 200,
              child: Card(
                child: Text(score)
            )
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

  //Redraw all Widgets
  void rebuildAllChildren(dynamic notused) {
    BuildContext? context = this._context;
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }

}