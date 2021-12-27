import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:wheeloflife/utils.dart';
import 'package:wheeloflife/wheel.dart';
import 'package:wheeloflife/assets/colors.dart';
import 'dart:ui' as ui;
import 'package:wheeloflife/assets/constants.dart' as Constants;
import 'package:wheeloflife/widgets/widget_to_image.dart';

import 'dialogs/dialogs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  late GlobalKey key1;

  final List<TextEditingController> _controllers = [];
  final List<TextField> _fields = [];
  final List<double> _sliderValues = [];
  final List<String> _initialAreasOfLife = [
    "Health",
    "Career & Money",
    "Social / Friends",
    "Love, Family, Kids",
    "Personal Growth"
  ];

  late List<Color> colors;
  late Color colorToApply;
  final hexInputTextController = TextEditingController();

  Uint8List? bytes;

  @override
  void initState() {
    super.initState();
    palette4.shuffle();
    colors = List.generate(
        palette4.length, (index) => Color(int.parse("0xff${palette4[index]}")));

    for (var areaOfLife in _initialAreasOfLife) {
      final controller = buildTextController(areaOfLife);
      final field = buildTextField(controller);
      _controllers.add(controller);
      _fields.add(field);
      _sliderValues.add(Constants.DEFAULT_SEEKER_VALUE);
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
      body: buildTheUI(),
    );
  }

  void onSavePressed() {}

  Widget buildTheUI() {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Row(
          children: [
            WidgetToImage(builder: (key) {
              key1 = key;

              return buildTheWheel();
            }),
            buildLegend(),
          ],
        ),
        TextButton(
          onPressed: () async {
            final resultBytes = await Utils.capture(key1);
            setState(() {
              bytes = resultBytes;
            });
          },
          child: const Text("save"),
        ),
        buildInputs(),
        buildAddAreaButton(),
        buildImage(bytes),
      ],
    );
  }

  Widget buildImage(Uint8List? bytes) => bytes != null ? Image.memory(bytes) : Container();

  Widget buildLegend() {
    return SizedBox(
      height: 400,
      width: 300,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _controllers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(_controllers[index].text),
                ),
                Text(" == ${_sliderValues[index].toInt()}")
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildTheWheel() {
    return Center(
      child: CustomPaint(
        child: Container(
            height: 500.0,
            width:
                500.0 //TODO figure this out - I don't understand the width here
            ),
        painter:
            WheelPainter(_sliderValues.map((e) => e.toInt()).toList(), colors),
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
          _sliderValues.add(Constants.DEFAULT_SEEKER_VALUE);
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
      decoration: InputDecoration(border: const OutlineInputBorder()),
    );
  }

  void changeColor(Color color, int index) {
    colorToApply = color;
  }

  List<Color> currentColors = [Colors.yellow, Colors.green];

  void onColorChosen(BuildContext context, int index) {
    Navigator.of(context).pop();
    setState(() => colors[index] = colorToApply);
  }

  Widget buildColorPicker(int index) {
    return Column(
      children: [
        ColorPicker(
          pickerColor: colors[index],
          onColorChanged: (Color color) => changeColor(color, index),
          colorPickerWidth: 300,
          pickerAreaHeightPercent: 0.7,
          enableAlpha: true,
          // hexInputController will respect it too.
          displayThumbColor: true,
          paletteType: PaletteType.hsvWithHue,
          labelTypes: const [],
          pickerAreaBorderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2),
            topRight: Radius.circular(2),
          ),
          hexInputController: hexInputTextController,
          // <- here
          portraitOnly: true,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: CupertinoTextField(
            controller: hexInputTextController,
            // Everything below is purely optional.
            prefix: const Padding(
                padding: EdgeInsets.only(left: 8), child: Icon(Icons.tag)),
            autofocus: true,
            maxLength: 9,
            inputFormatters: [
              // Any custom input formatter can be passed
              // here or use any Form validator you want.
              UpperCaseTextFormatter(),
              FilteringTextInputFormatter.allow(RegExp(kValidHexPattern)),
            ],
          ),
        )
      ],
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
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  setState(() {
                    _sliderValues[index] = lowerValue.toDouble();
                  });
                },
              ),
            ),
            TextButton(
              onPressed: () {
                showChooseColorDialog(
                    context, index, onColorChosen, buildColorPicker(index));
              },
              child: Text(
                "choose color",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (_controllers.length >
                      Constants.MINIMUM_AMOUNT_OF_LIFE_AREAS) {
                    _sliderValues.remove(_sliderValues[index]);
                    _controllers.remove(_controllers[index]);
                    _fields.remove(_fields[index]);
                  } else {
                    showMinLifeAreasDialog(context);
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

  bool inside = false;
  late Uint8List imageInMemory;

/*  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      inside = true;
      RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
//      String bs64 = base64Encode(pngBytes);
//      print(pngBytes);
//      print(bs64);
      print('png done');
      setState(() {
        imageInMemory = pngBytes;
        inside = false;
      });
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }*/
}
