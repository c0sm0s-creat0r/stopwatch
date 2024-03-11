import 'dart:ui';
import 'package:intl/intl.dart';
import '';

import 'package:flutter/material.dart';
import 'dart:async';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  String _buttonText = "Start";
  String _stopwatchText = "00:00:00";
  final _stopWatch = Stopwatch();
  Stopwatch _questionStopWatch = Stopwatch();
  final _timeout = const Duration(milliseconds: 100);
  Duration timer = Stopwatch().elapsed;

  List<Widget> numberWidgets = [];
  int _marks = 0;
  List<double> averageTimes = [];
  String _timeToCompleteQuestion = "00:00:00";
  String _averageTimeTaken = "00:00.00";

  void _startTimeout() {
    /*Timer(_timeout, _handleTimeout);*/
    Timer(_timeout, () {
      if (_stopWatch.isRunning) {
        _startTimeout();
      }
      setState(() {
        _setStopwatchText();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    for (int i = 1; i <= 9; i++) {
      numberWidgets.add(
        Padding(
          padding: const EdgeInsets.all(5),
          child: Material(
            color: Color.fromRGBO(29, 38, 48, 1),
            child: InkWell(
              onTap: () {
                _pressMark(i);
              },
              focusColor: Color.fromRGBO(29, 38, 48, 1),
              splashColor: Color.fromRGBO(29, 38, 48, 1),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  i.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FittedBox(
          fit: BoxFit.none,
          child: Text(
            _stopwatchText,
            style: const TextStyle(
              fontSize: 72,
              color: Colors.white,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: _startStopButtonPressed,
              child: Text(
                _buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            TextButton(
              onPressed: _resetButtonPressed,
              child: const Text(
                "Reset",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                alignment: Alignment.center,
                height: 90,
                width: 100,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(61, 62, 82, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Average Time",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _averageTimeTaken,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: 90,
                width: 120,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(61, 62, 82, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Marks Completed",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _marks.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: 90,
                width: 100,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(61, 62, 82, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Question Took",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _timeToCompleteQuestion,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            children: numberWidgets,
          ),
        ),
      ],
    );
  }

  void _startStopButtonPressed() {
    setState(() {
      if (_stopWatch.isRunning) {
        _buttonText = "Start";
        _stopWatch.stop();
        _questionStopWatch.stop();
      } else {
        _buttonText = "Stop";
        _stopWatch.start();
        _questionStopWatch.start();
        _startTimeout();
      }
    });
  }

  void _resetButtonPressed() {
    if (_stopWatch.isRunning) {
      _startStopButtonPressed();
    }
    setState(() {
      _stopWatch.reset();
      _questionStopWatch.reset();
      _setStopwatchText();
      _marks = 0;
      _averageTimeTaken = "00:00.00";
      averageTimes = [];
      _timeToCompleteQuestion = "00:00:00";
    });
  }

  void _setStopwatchText() {
    _stopwatchText =
        "${_stopWatch.elapsed.inHours.toString().padLeft(2, "0")}:${(_stopWatch.elapsed.inMinutes % 60).toString().padLeft(2, "0")}:${(_stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, "0")}";
  }

  void _pressMark(int mark) {
    for (int j = 0; j < mark; j++) {
      averageTimes
          .add((_questionStopWatch.elapsed.inMilliseconds / 1000) / mark);
    }
    double totalTimeTaken = 0;
    for (int i = 0; i < averageTimes.length; i++) {
      totalTimeTaken += averageTimes[i];
    }
    double averageTime = totalTimeTaken / averageTimes.length;
    DateTime formattedTime =
        DateTime.fromMillisecondsSinceEpoch((averageTime * 1000).toInt());

    setState(() {
      _marks += mark;

      _timeToCompleteQuestion =
          "${_questionStopWatch.elapsed.inHours.toString().padLeft(2, "0")}:${(_questionStopWatch.elapsed.inMinutes % 60).toString().padLeft(2, "0")}:${(_questionStopWatch.elapsed.inSeconds % 60).toString().padLeft(2, "0")}";
      _averageTimeTaken =
          "${DateFormat('mm:ss').format(formattedTime)}.${((averageTime % 1) * 100).toInt()}";

      _questionStopWatch.reset();
    });
  }
}
