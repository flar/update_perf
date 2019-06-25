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
  static const numCols = 10;
  static const numRows = 20;
  static final Random rng = Random();
  static final TextStyle visible = makeStyle(true);
  static final TextStyle invisible = makeStyle(false);
  static final Widget goodWidget = makeWidget(true);
  static final Widget badWidget = makeWidget(false);

  static TextStyle makeStyle(bool isVisible) {
    return TextStyle(
      fontSize: 8,
      color: isVisible ? Colors.black : Colors.transparent,
      decoration: TextDecoration.none,
    );
  }

  static Widget makeWidget(bool isGood) {
    return Container(
      padding: EdgeInsets.all(2),
      color: isGood ? Colors.green : Colors.red,
      child: isGood ? Stack(
        alignment: Alignment.center,
        children: [
          Text('good', style: visible),
          Text('bad', style: invisible),
        ],
      ) : Stack(
        alignment: Alignment.center,
        children: [
          Text('good', style: invisible),
          Text('bad', style: visible),
        ],
      ),
    );
  }

  AnimationController _controller;
  List<List<bool>> _grid;

  MyHomePageState() {
    _grid = List<List<bool>>.generate(numRows, (i) => List<bool>.generate(numCols, (i) => rng.nextBool()));
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
    _grid[row][col] = !_grid[row][col];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext c, Widget w) {
        flipOne();
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var row in _grid)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var isGood in row)
                    isGood ? goodWidget : badWidget,
                ]
              ),
          ],
        );
      },
    );
  }
}
