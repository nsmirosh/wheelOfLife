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
    "Love, Family, Kids",
    "Personal Growth",
    "Fun",
    "Spirituality",
  ];

  final DEFAULT_SEEKER_VALUE = 7.0;
  final MINIMUM_AMOUNT_OF_LIFE_AREAS = 2;

  final colors = [
    Color(0xffeae4e9),
    Color(0xfffff1e6),
    Color(0xfffde2e4),
    Color(0xfffad2e1),
    Color(0xffe2ece9),
    Color(0xffbee1e6),
    Color(0xffdfe7fd),
    Color(0xffcddafd),
  ];

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
    return Center(
      child: CustomPaint(
        child: Container(
          height: 500.0,
          width: 500.0 //TODO figure this out - I don't understand the width here
        ),
        painter: WheelPainter(_sliderValues.map((e) => e.toInt()).toList(), colors),
      ),
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
        border: OutlineInputBorder()
      ),
    );
  }

  void changeColor(Color color, int index) {
    setState(() => colors[index] = color);
  }

  List<Color> currentColors = [Colors.yellow, Colors.green];

  void showSomeDialog(int index) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          titlePadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(0),
          content: Column(
            children: [
              ColorPicker(
                pickerColor: const Color(0xffeae4e9),
                onColorChanged: (Color color) => changeColor(color, index),
                colorPickerWidth: 300,
                pickerAreaHeightPercent: 0.7,
                enableAlpha: true, // hexInputController will respect it too.
                displayThumbColor: true,
                paletteType: PaletteType.hsvWithHue,
                labelTypes: const [],
                pickerAreaBorderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
                // hexInputController: textController, // <- here
                portraitOnly: true,
              ),
/*              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                *//* It can be any text field, for example:

                            * TextField
                            * TextFormField
                            * CupertinoTextField
                            * EditableText
                            * any text field from 3-rd party package
                            * your own text field

                            so basically anything that supports/uses
                            a TextEditingController for an editable text.
                            *//*
                child: CupertinoTextField(
                  controller: textController,
                  // Everything below is purely optional.
                  prefix: const Padding(padding: EdgeInsets.only(left: 8), child: Icon(Icons.tag)),
                  suffix: IconButton(
                    icon: const Icon(Icons.content_paste_rounded),
                    onPressed: () => copyToClipboard(textController.text),
                  ),
                  autofocus: true,
                  maxLength: 9,
                  inputFormatters: [
                    // Any custom input formatter can be passed
                    // here or use any Form validator you want.
                    UpperCaseTextFormatter(),
                    FilteringTextInputFormatter.allow(RegExp(kValidHexPattern)),
                  ],
                ),
              )*/
            ],
          ),
        );
      },
    );
  }

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
            TextButton(
              onPressed: () {
                showSomeDialog(index);
              },
              child: Text(
                "choose color",
                style: TextStyle(color: Colors.blueAccent),
              ),
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
  List<Color> colors = [];

  WheelPainter(this.values, this.colors);

  Paint getPaint(Color color, {bool isStroke = false}) {
    return Paint()
      ..color = color
      ..style = isStroke ? PaintingStyle.stroke : PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double wheelSize = 200;
    int totalPossibleGrades = 10;



    double radius = (2 * math.pi) / values.length;

    canvas.drawPath(getWheelPath(wheelSize, 0, radius, values[0] * wheelSize / totalPossibleGrades),
        getPaint(colors[0]));

    for (var i = 1; i < values.length; i++) {
      canvas.drawPath(
          getWheelPath(wheelSize, radius * i, radius, values[i] * wheelSize / totalPossibleGrades),
          getPaint(colors[i]));
      canvas.drawPath(getWheelPath(wheelSize, radius * i, radius, wheelSize),
          getPaint(Colors.black, isStroke: true));
    }

    drawGrid(canvas, wheelSize);
  }

  void drawGrid(Canvas canvas, double wheelSize) {
    for (var i = 1; i <= 10; i++) {
      canvas.drawCircle(
        Offset(wheelSize, wheelSize),
        wheelSize / 10 * i,
        getPaint(Colors.black, isStroke: true),
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
