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
  static const useRepaintBoundary = false;

  static TextStyle makeStyle(Color color) =>
      TextStyle(
        fontSize: 8,
        color: color,
        decoration: TextDecoration.none,
      );

  static final TextStyle redStyle   = makeStyle(Colors.red);
  static final TextStyle greenStyle = makeStyle(Colors.green);
  static final TextStyle blackStyle = makeStyle(Colors.black);
  static final TextStyle greyStyle  = makeStyle(Colors.grey);

  static Widget makeWidget(Color bgColor, TextStyle gStyle, TextStyle rStyle) {
    Widget w = Container(
      padding: EdgeInsets.all(2),
      color: bgColor,
      child: Row(children: [ Text('g', style: gStyle), Text('b', style: rStyle)]),
    );
    if (useRepaintBoundary) w = RepaintBoundary(child: w);
    return w;
  }

  static Widget cellForState(bool state) {
    if (state == null) {
      return makeWidget(Colors.grey,  greyStyle,  greyStyle);
    } else if (state) {
      return makeWidget(Colors.green, blackStyle, greenStyle);
    } else {
      return makeWidget(Colors.red,   redStyle,   blackStyle);
    }
  }

  AnimationController _controller;
  List<List<bool>> _stateGrid;
  List<List<Widget>> _widgetGrid;

  MyHomePageState() {
    _stateGrid = List<List<bool>>.generate(numCols, (i) => List<bool>.filled(numRows, null));
    final Widget empty = cellForState(null);
    _widgetGrid = List<List<Widget>>.generate(numCols, (i) => List<Widget>.filled(numRows, empty));
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
    _stateGrid[col][row] ??= rng.nextBool();
    _stateGrid[col][row] = !_stateGrid[col][row];
    _widgetGrid[col][row] = cellForState(_stateGrid[col][row]);
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
            for (var col in _widgetGrid)
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: col,
              ),
          ],
        );
      },
    );
  }
}
