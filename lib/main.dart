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
  final firstAreaNameController = TextEditingController();

  var visible = false;

  var _lowerValue = 5.0;

  var areasOfLife = 1;

  @override
  void dispose() {
    firstAreaNameController.dispose();
    super.dispose();
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
            ...buildInputFields(),
            TextButton(
              onPressed: () {
                setState(() {
                  if (firstAreaNameController.text.isNotEmpty) {
                    visible = true;
                  }

                  areasOfLife++;
                });
              },
              child: const Text(
                "add another area",
                style: TextStyle(color: Colors.black),
              ),
            ),
            buildBottomView(visible, firstAreaNameController.text),
          ],
        ),
      ),
    );
  }

  List<Widget> buildInputFields() {
    return List.generate(areasOfLife, (index) =>
        Row(
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                controller: firstAreaNameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your first area of life'),
              ),
            ),
            SizedBox(
                width: 300,
                child: FlutterSlider(
                  values: [_lowerValue],
                  max: 10,
                  min: 0,
                  onDragging: (handlerIndex, lowerValue, upperValue) {
                    _lowerValue = lowerValue;
                    setState(() {});
                  },
                )),
          ],
        )
    );
  }

  Widget buildBottomView(bool shouldShow, String area) {
    return Visibility(
      visible: shouldShow,
      child: Text(
        "area of life = $area",
        style: const TextStyle(color: Colors.amber),
      ),
    );
  }
}
