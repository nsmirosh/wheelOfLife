import 'dart:math';
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
import 'dart:html' as html;
import 'package:wheeloflife/assets/constants.dart' as Constants;
import 'package:wheeloflife/widgets/widget_to_image.dart';

import 'dialogs/dialogs.dart';

//TODO attribute this author for the icon <a href="https://www.flaticon.com/free-icons/delete" title="delete icons">Delete icons created by Freepik - Flaticon</a>
//TODO attribute this author <a href="https://www.flaticon.com/free-icons/color" title="color icons">Color icons created by Freepik - Flaticon</a>
//todo <a href="https://www.flaticon.com/free-icons/download" title="download icons">Download icons created by Freepik - Flaticon</a>
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
        scaffoldBackgroundColor: const Color(0xffFFFFFF),
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

  @override
  void initState() {
    super.initState();
    generateThePalette();

    var pos = 0;

    for (var areaOfLife in _initialAreasOfLife) {
      final shouldAutoFocus = pos == 0;

      final controller = buildTextController(areaOfLife);
      final field = buildTextField(controller, shouldAutoFocus);
      _controllers.add(controller);
      _fields.add(field);
      _sliderValues.add(Constants.defaulSeekerValue);

      pos++;
    }
  }

  void generateThePalette() {
    starting_palette.shuffle();

    colors = List.generate(
      starting_palette.length,
      (index) => Color(
        int.parse("0xff${starting_palette[index]}"),
      ),
    );

    for (int i = 0;
        i < Constants.maximumAmountOfLifeAreas - colors.length;
        i++) {
      final random = Random();
      final color = Color.fromRGBO(
          random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);
      colors.add(color);
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
        WidgetToImage(
          builder: (key) {
            key1 = key;
            return Container(
              color: const Color(0xffFFFFFF),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: buildTheWheel(),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(64, 24, 24, 24),
                      child: buildInputs(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        TextButton(
          onPressed: () => downloadTheWheel(),
          child: Row(
            children: [
              Image.asset('assets/images/download-arrow.png',
                  width: 40, height: 40),
              Text(
                "save",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        buildAddAreaButton(),
      ],
    );
  }

  void downloadTheWheel() async {
    final resultBytes = await Utils.capture(key1);

    final blob = html.Blob(<dynamic>[resultBytes], 'application/octet-stream');
    html.AnchorElement(href: html.Url.createObjectUrlFromBlob(blob))
      ..setAttribute('download', 'wheel_of_life.png')
      ..click();
  }

  Widget buildLegend() {
    return SizedBox(
      height: 400,
      width: 900,
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 5,
        children: getList(),
      ),
    );
  }

  List<Widget> getList() {
    List<Widget> children = [];
    for (var index = 0; index < _controllers.length; index++) {
      children.add(
        Padding(
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
                child: Center(
                  child: TextField(
                    /*hint:
                    "${_sliderValues[index].toInt()}",*/
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  _controllers[index].text,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return children;
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
        final field = buildTextField(controller, false);
        setState(() {
          _controllers.add(controller);
          _fields.add(field);
          _sliderValues.add(Constants.defaulSeekerValue);
        });
      },
      child: const Text(
        "add another area",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  TextEditingController buildTextController(
      [String areaOfLife = "area of life"]) {
    return TextEditingController()
      ..text = areaOfLife
      ..addListener(
        () => {
          setState(() {}),
        },
      );
  }

  TextField buildTextField(TextEditingController controller, bool autoFocus) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      autofocus: autoFocus,
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
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 70.0,
                height: 70.0,
                child: Center(
                  child: Text(
                    "${_sliderValues[index].toInt()}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                decoration: new BoxDecoration(
                  color: colors[index],
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(
                width: 250,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _fields[index],
                ),
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
                child: Image.asset('assets/images/colour.png',
                    width: 32, height: 32),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    if (_controllers.length >
                        Constants.minimumAmountOfLifeAreas) {
                      _sliderValues.remove(_sliderValues[index]);
                      _controllers.remove(_controllers[index]);
                      _fields.remove(_fields[index]);
                    } else {
                      showMinLifeAreasDialog(context);
                    }
                  });
                },
                child: Image.asset('assets/images/delete.png',
                    width: 32, height: 32),
              ),
            ],
          ),
        );
      },
    );
  }
}
