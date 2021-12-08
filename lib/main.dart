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
  // final firstAreaNameController = TextEditingController();

  final List<TextEditingController> _controllers = [];
  final List<TextField> _fields = [];

  var visible = false;
  var areasOfLife = 1;
  final defaultSeekerValue = 5;

  var map = Map<int, int>();

  @override
  void initState() {
    super.initState();
    List.generate(areasOfLife,
            (index) => map.putIfAbsent(index, () => defaultSeekerValue));
    print(" map after initState = $map");
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
            SizedBox(
              width: 300,
              child: _fields[index]
            ),
            SizedBox(
              width: 300,
              child: FlutterSlider(
                values: [
                  map[index]?.toDouble() ?? defaultSeekerValue.toDouble()
                ],
                max: 10,
                min: 0,
                onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                  setState(() {
                    print(" index = $index");
                    print(" lowerValue = $lowerValue");
                    map.update(index, lowerValue);
                    print(" map = $map");
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
        areasOfLife,
            (index) =>
            Text(
              "area of life = ",
              style: const TextStyle(color: Colors.amber),
            ),
      ),
    );
  }
}
