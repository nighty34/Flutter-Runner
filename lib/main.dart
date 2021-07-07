import 'package:flutter/material.dart';
import 'package:flutter_game/game/game_core.dart';
import 'package:flutter_game/game/sspGame.dart';
import 'package:provider/provider.dart';

void main() {
  Game game;
  game = new Game(SSPView("A Game"), SSPEngine());
  runApp(MyApp(game, "SSP Game"));
}

class MyApp extends StatelessWidget {
  final Game game;
  final String title;

  MyApp(this.game, this.title);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: game.gameEngine,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
      home: game.gameView,)
    );
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }
}