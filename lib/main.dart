import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

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
