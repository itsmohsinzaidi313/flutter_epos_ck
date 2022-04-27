import 'package:flutter/material.dart';
import 'package:pos_app/shared/config.dart';

const double _WIDTH_FACTOR = 0.6;
Future<String> openItemCommentDialog(
    BuildContext context, String itemName) async {
  final commentCntrlr = TextEditingController(text: '');
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
        title: Text(itemName),
        content: Container(
          width: Config.getDeviceWidth(context) * _WIDTH_FACTOR,
          child: TextField(
            controller: commentCntrlr,
            decoration: InputDecoration(
              labelText: 'Item Comment',
              icon: Icon(
                Icons.edit,
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(commentCntrlr.text),
            child: Text('Save'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(''),
            child: Text('Cancel'),
          ),
        ]),
  );
}
