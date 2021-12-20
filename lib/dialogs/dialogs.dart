
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showMinLifeAreasDialog(BuildContext context) async {
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


void showChooseColorDialog(BuildContext context, int index, Function onColorChosen, Widget colorPicker) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("OK"),
            onPressed: () {
              onColorChosen(context, index);
            /*  Navigator.of(context).pop();
              setState(() => colors[index] = colorToApply);*/
            },
          ),
        ],
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.all(0),
        content: colorPicker,
      );
    },
  );
}