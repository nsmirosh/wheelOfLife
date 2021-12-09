import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'dart:math' as math;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<TextEditingController> _controllers = [];
  final List<TextField> _fields = [];
  final List<double> _sliderValues = [];
  final List<String> _initialAreasOfLife = [
    "Health & Fitness",
    "Money",
    "Career / Business",
    "Social / Friends",
    // "Love, Family, Kids",
    // "Personal Growth",
    // "Fun",
    // "Spirituality",
  ];

  var areasOfLife = 1;
  final DEFAULT_SEEKER_VALUE = 5.0;
  final MINIMUM_AMOUNT_OF_LIFE_AREAS = 2;

  @override
  void initState() {
    super.initState();

    for (var areaOfLife in _initialAreasOfLife) {
      final controller = TextEditingController();
      controller.text = areaOfLife;
      controller.addListener(() => {setState(() {})});
      final field = TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "some input",
        ),
      );

      print("_controllers = $_controllers");
      _controllers.add(controller);
      _fields.add(field);
      _sliderValues.add(DEFAULT_SEEKER_VALUE);
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextButton(
              onPressed: () {
                final controller = TextEditingController();
                controller.addListener(() => {setState(() {})});
                final field = TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "name${_controllers.length + 1}",
                  ),
                );
                setState(() {
                  _controllers.add(controller);
                  _fields.add(field);
                  _sliderValues.add(DEFAULT_SEEKER_VALUE);
                });
              },
              child: const Text(
                "add another area",
                style: TextStyle(color: Colors.black),
              ),
            ),
            CustomPaint(
              child: Container(
                height: 300.0,
              ),
              painter: WheelPainter(),
            ),
            _listView(),
            buildBottomView()
          ],
        ),
      ),
    );
  }

  Widget _listView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _fields.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            SizedBox(width: 300, child: _fields[index]),
            SizedBox(
              width: 300,
              child: FlutterSlider(
                values: [_sliderValues[index].toDouble()],
                max: 10,
                min: 0,
                onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                  setState(() {
                    _sliderValues[index] = lowerValue.toDouble();
                  });
                },
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (_controllers.length > MINIMUM_AMOUNT_OF_LIFE_AREAS) {
                    _sliderValues.remove(_sliderValues[index]);
                    _controllers.remove(_controllers[index]);
                    _fields.remove(_fields[index]);
                  }
                  else {
                    _showMyDialog();
                  }
                });
              },
              child: Text(
                "delete",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sorry'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('You have to have at least 2 life areas in your wheel :) '),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Widget buildBottomView() {
    return Column(
      children: List.generate(
        _controllers.length,
        (index) => Text(
          "area of life = ${_controllers[index].text}, value = ${_sliderValues[index]}",
          style: const TextStyle(color: Colors.amber),
        ),
      ),
    );
  }
}


class WheelPainter extends CustomPainter {
  Path getWheelPath(double wheelSize, double fromRadius, double toRadius, double sizeOfRadius) {
    return Path()
      ..moveTo(wheelSize, wheelSize)
      ..arcTo(
          Rect.fromCircle(
              radius: sizeOfRadius, center: Offset(wheelSize, wheelSize)),
          fromRadius,
          toRadius,
          false)
      ..close();
  }

  Paint getColoredPaint(Color color) {
    Paint paint = Paint();
    paint.color = color;
    return paint;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double wheelSize = 100;
    double nbElem = 6;
    double radius = (2 * math.pi) / nbElem;

    canvas.drawPath(
        getWheelPath(wheelSize, 0, radius, wheelSize), getColoredPaint(Colors.red));
    canvas.drawPath(
        getWheelPath(wheelSize, radius, radius, wheelSize), getColoredPaint(Colors.purple));
    canvas.drawPath(getWheelPath(wheelSize, radius * 2, radius, wheelSize),
        getColoredPaint(Colors.blue));
    canvas.drawPath(getWheelPath(wheelSize, radius * 3, radius, 50),
        getColoredPaint(Colors.green));
    canvas.drawPath(getWheelPath(wheelSize, radius * 4, radius, wheelSize),
        getColoredPaint(Colors.yellow));
    canvas.drawPath(getWheelPath(wheelSize, radius * 5, radius, 20),
        getColoredPaint(Colors.orange));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
