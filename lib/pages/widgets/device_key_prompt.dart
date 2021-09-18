import 'package:flutter/material.dart';
import 'package:pos_app/shared/config.dart';

Future<String> deviceKeyPrompt(BuildContext context) async {
  final dKeyController = TextEditingController(text: Config.tempDevKey);
  return (await showDialog<String>(
        context: context,
        barrierLabel: 'Hello',
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
            'Attention',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setState) => Container(
              width: Config.getDeviceWidth(context) * 0.5,
              child: TextField(
                controller: dKeyController,
                decoration: InputDecoration(
                    labelText: 'Device Key', hintText: '0123456789'),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(dKeyController.text),
                child: Text('Save')),
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(''),
                child: Text('Exit')),
          ],
        ),
      )) ??
      '';
}
