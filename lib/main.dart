import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Performance Demo',
      home: Scaffold(
        body: MyHomePage(),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override State createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  static const numCols = 15;
  static const numRows = 30;
  static final Random rng = Random();

  static TextStyle makeStyle(Color color) =>
      TextStyle(
        fontSize: 8,
        color: color,
        decoration: TextDecoration.none,
      );

  static Widget makeWidget(Color bgColor, TextStyle gStyle, TextStyle rStyle) =>
      Container(
        padding: EdgeInsets.all(2),
        color: bgColor,
        child: Row(children: [ Text('g', style: gStyle), Text('b', style: rStyle)]),
      );

  static final TextStyle redStyle   = makeStyle(Colors.red);
  static final TextStyle greenStyle = makeStyle(Colors.green);
  static final TextStyle blackStyle = makeStyle(Colors.black);
  static final TextStyle greyStyle  = makeStyle(Colors.grey);

  static final Widget noWidget   = makeWidget(Colors.grey,  greyStyle,  greyStyle);
  static final Widget goodWidget = makeWidget(Colors.green, blackStyle, greenStyle);
  static final Widget badWidget  = makeWidget(Colors.red,   redStyle,   blackStyle);

  AnimationController _controller;
  List<List<bool>> _grid;

  MyHomePageState() {
    _grid = List<List<bool>>.generate(numCols, (i) => List<bool>.filled(numRows, null));
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
    _grid[col][row] ??= rng.nextBool();
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
                    isGood == null ? noWidget : (isGood ? goodWidget : badWidget),
                ],
              ),
          ],
        );
      },
    );
  }
}
