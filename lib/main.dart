import 'dart:async';
import 'dart:math';

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

enum Direction { up, down, left, right }

class _GameFieldState extends State<GameField> {
//TODO 3: initialization of variable
  bool _isAlive = true;
  int length = 1;
  Direction _direction = Direction.up;
  List<Offset> _positions = [];
  double? height;
  double? width;
  Timer? timer;
  double speed = 4;
  int _score = 0;
  Offset? foodPosition;
  Widget food = Container();
//TODO: 1 build method
  @override
  Widget build(BuildContext context) {
    changeSpeed();

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: _isAlive
            ? Stack(
                children: [
                  Stack(
                    children: snakePieces(),
                  ),
                  score(),
                  food,
                  gamePad(),
                ],
              )
            : onEnd());
  }

//TODO on End
  Widget onEnd() {
    return Column(
      children: [
        Text("Game Over"),
        Text("Your Score is $_score"),
        TextButton(
          child: Text("Restart Game"),
          onPressed: () {
            setState(() {
              _score = 0;
              speed = 4;
              length = 1;
              _positions = [];
              _isAlive = true;
            });
          },
        )
      ],
    );
  }

//check Alive
  checkAlive() {
    for (int i = 1; i < _positions.length; i++) {
      if (_positions[i] == _positions[0]) {
        _isAlive = false;
      }
    }
  }

//TODO gamePAd
  Widget gamePad() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: width! / 2,
        width: width! / 2,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                  onPressed: () {
                    if (_direction != Direction.up) _direction = Direction.down;
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 35,
                  )),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: IconButton(
                  onPressed: () {
                    if (_direction != Direction.down) _direction = Direction.up;
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_up,
                    size: 35,
                  )),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  onPressed: () {
                    if (_direction != Direction.left)
                      _direction = Direction.right;
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_right,
                    size: 35,
                  )),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  onPressed: () {
                    if (_direction != Direction.right)
                      _direction = Direction.left;
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    size: 35,
                  )),
            ),
          ],
        ),
      ),
    );
  }

//TODO score
  Positioned score() => Positioned(
      top: 50,
      right: 50,
      child:
          Text("$_score", style: TextStyle(color: Colors.cyan, fontSize: 22)));

//TODO speed
  changeSpeed() {
    if (timer != null) if (timer!.isActive) timer!.cancel();
    timer = Timer.periodic(Duration(milliseconds: 500 ~/ speed), (timer) {
      setState(() {});
    });
  }

//TODO snakePieces
  List<Piece> snakePieces() {
    List<Piece> pieces = [];
    if (_isAlive) {
      setState(() {
        draw();
        foodDraw();
      });
    }
    for (int i = 0; i < _positions.length; i++) {
      pieces.add(Piece(
          size: 15,
          posX: _positions[i].dx,
          posY: _positions[i].dy,
          color: Colors.blue));
    }
    checkAlive();
    return pieces;
  }

// TODO foodDraw
  foodDraw() {
    if (foodPosition == null) foodPosition = getRandomPositionWithinScreen();
    food = Piece(
        color: Colors.orange,
        posX: foodPosition!.dx,
        posY: foodPosition!.dy,
        size: 15);
    if (foodPosition! <= (_positions[0] + Offset(10, 10)) &&
        foodPosition! >= (_positions[0] - Offset(10, 10))) {
      _score += 5;
      length += 1;
      foodPosition = getRandomPositionWithinScreen();
      speed += 0.15;
    }
  }

// TODO draw()
  draw() {
    if (_positions.length == 0) {
      _positions.add(getRandomPositionWithinScreen());
    }
    while (length > _positions.length) {
      _positions.add(_positions[_positions.length - 1]);
    }
    for (int i = _positions.length - 1; i > 0; i--) {
      _positions[i] = _positions[i - 1];
    }
    _positions[0] = checkBorder(_positions[0]);
    _positions[0] = getNextPosition(_positions[0]);
  }

//TODO getNextPosition
  Offset getNextPosition(Offset position) {
    Offset nextPosition = Offset(5, 6);
    if (_direction == Direction.up) nextPosition = position - Offset(0, 15);
    if (_direction == Direction.down) nextPosition = position + Offset(0, 15);
    if (_direction == Direction.right) nextPosition = position + Offset(15, 0);
    if (_direction == Direction.left) nextPosition = position - Offset(15, 0);

    return nextPosition;
  }

//TODO chck border
  checkBorder(Offset position) {
    if (position.dy >= height! - 30) position = Offset(position.dx, 16);
    if (position.dy <= 0) position = Offset(position.dx, height! - 16);
    if (position.dx >= width! - 30) position = Offset(16, position.dy);
    if (position.dx <= 0) position = Offset(width! - 16, position.dy);
    return position;
  }

//TODO getRandomPosition
  Offset getRandomPositionWithinScreen() {
    Random rand = Random();
    double x = rand.nextInt(width!.toInt()).toDouble();
    double y = rand.nextInt(height!.toInt()).toDouble();
    return Offset(x, y) - Offset(15, 15);
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
