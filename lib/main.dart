import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Performance Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  static const numCols = 15;
  static const numRows = 30;
  static final Random rng = Random();

  static final TextStyle style = TextStyle(
    fontSize: 8,
    color: Colors.black,
    decoration: TextDecoration.none,
  );

  static final Widget goodWidget = makeWidget(true);
  static final Widget badWidget = makeWidget(false);

  static Widget makeWidget(bool isGood) {
    return Container(
      padding: EdgeInsets.all(2),
      color: isGood ? Colors.green : Colors.red,
      child: Text(isGood ? 'grn' : 'red', style: style),
    );
  }

  AnimationController _controller;
  List<List<bool>> _grid;

  MyHomePageState() {
    _grid = List<List<bool>>.generate(numCols, (i) => List<bool>.generate(numRows, (i) => rng.nextBool()));
  }

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void flipOne() {
    int row = rng.nextInt(numRows);
    int col = rng.nextInt(numCols);
    _grid[col][row] = !_grid[col][row];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext c, Widget w) {
        flipOne();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var col in _grid)
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var isGood in col)
                    isGood ? goodWidget : badWidget,
                ]
              ),
          ],
        );
      },
    );
  }
}
