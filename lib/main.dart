import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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

  final DEFAULT_SEEKER_VALUE = 7.0;
  final MINIMUM_AMOUNT_OF_LIFE_AREAS = 2;

  List<Color> colors = [Colors.black, Colors.black, Colors.black, Colors.black];

  @override
  void initState() {
    super.initState();

    for (var areaOfLife in _initialAreasOfLife) {
      final controller = buildTextController(areaOfLife);
      final field = buildTextField(controller);
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
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildTheWheel(),
              buildInputs(),
              buildAddAreaButton()
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTheWheel() {
    return CustomPaint(
      child: Container(
        height: 300.0,
        width: MediaQuery.of(context).size.width,
      ),
      painter: WheelPainter(_sliderValues.map((e) => e.toInt()).toList()),
    );
  }

  Widget buildAddAreaButton() {
    return TextButton(
      onPressed: () {
        final controller = buildTextController();
        final field = buildTextField(controller);
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
    );
  }

  TextEditingController buildTextController([String areaOfLife = ""]) {
    return TextEditingController()
      ..text = areaOfLife
      ..addListener(
        () => {
          setState(() {}),
        },
      );
  }

  TextField buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "some input",
      ),
    );
  }

  void changeColor(Color color, int index) {
    setState(() => colors[index] = color);
  }

  List<Color> currentColors = [Colors.yellow, Colors.green];

  Widget buildInputs() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _fields.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            SizedBox(
              width: 300,
              child: _fields[index],
            ),
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
            ColorPicker(
              pickerColor: colors[index],
              onColorChanged: (Color color) => changeColor(color, index),
              colorPickerWidth: 100,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (_controllers.length > MINIMUM_AMOUNT_OF_LIFE_AREAS) {
                    _sliderValues.remove(_sliderValues[index]);
                    _controllers.remove(_controllers[index]);
                    _fields.remove(_fields[index]);
                  } else {
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
                Text(
                    'You have to have at least 2 life areas in your wheel :) '),
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
}

class WheelPainter extends CustomPainter {
  List<int> values = [];

  WheelPainter(this.values);

  Paint getPaint(Color color, {bool isStroke = false}) {
    return Paint()
      ..color = color
      ..style = isStroke ? PaintingStyle.stroke : PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double wheelSize = 100;

    final colors = [
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange
    ];

    final palette1 = [
      Color(0xffeae4e9),
      Color(0xfffff1e6),
      Color(0xfffde2e4),
      Color(0xfffad2e1),
      Color(0xffe2ece9),
      Color(0xffbee1e6),
      Color(0xfff0efeb),
      Color(0xffdfe7fd),
      Color(0xffcddafd),
    ];

    double radius = (2 * math.pi) / values.length;

    canvas.drawPath(getWheelPath(wheelSize, 0, radius, values[0] * 10),
        getPaint(palette1[0]));

    for (var i = 1; i < values.length; i++) {
      canvas.drawPath(
          getWheelPath(wheelSize, radius * i, radius, values[i] * 10),
          getPaint(palette1[i]));
      canvas.drawPath(getWheelPath(wheelSize, radius * i, radius, wheelSize),
          getPaint(const Color(0xffaa44aa), isStroke: true));
    }

    drawGrid(canvas, wheelSize);
  }

  void drawGrid(Canvas canvas, double wheelSize) {
    for (var i = 1; i <= 10; i++) {
      canvas.drawCircle(
        Offset(wheelSize, wheelSize),
        wheelSize / 10 * i,
        getPaint(const Color(0xffaa44aa), isStroke: true),
      );
    }
  }

  Path getWheelPath(double wheelSize, double fromRadius, double toRadius,
      double sizeOfRadius) {
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

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
