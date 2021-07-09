import 'package:flutter/material.dart';

void main() {
  runApp(SnakeGame());
}

class SnakeGame extends StatelessWidget {
  const SnakeGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameField(),
    );
  }
}

class GameField extends StatefulWidget {
  const GameField({Key? key}) : super(key: key);

  @override
  _GameFieldState createState() => _GameFieldState();
}

class _GameFieldState extends State<GameField> {
//TODO: 1 build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [],
    ));
  }
}

// TODO 2 Piece
class Piece extends StatelessWidget {
  double size;
  double posX;
  double posY;
  Color color;
  Piece(
      {Key? key,
      required this.size,
      required this.posX,
      required this.posY,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: posY,
      left: posX,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
