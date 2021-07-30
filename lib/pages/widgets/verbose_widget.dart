import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/shared/config.dart';

class VerboseWidgets {
  final BuildContext context;
  VerboseWidgets({this.context});
  Future<void> showVerboseDialog() async => await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          child: Container(
            width: Config.getDeviceWidth(context) * 0.6,
            child: BlocBuilder<VerboseBloc, VerboseState>(
              builder: (context, state) {
                String title = state.title ?? '-----';
                String message = state.message ?? '-----';
                try {
                  if (title == 'Completed') {
                    Timer(Duration(seconds: 2), () {
                      Navigator.pop(context);
                    });
                  }
                  return Wrap(
                    children: [
                      ListTile(
                        leading: title == 'Completed'
                            ? Icon(Icons.check, color: Colors.green)
                            : Icon(Icons.info),
                        title: Text(
                          title.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    message,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: state.value,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                } catch (e) {
                  Timer(Duration(seconds: 2), () {
                    Navigator.pop(context);
                  });
                  return Wrap(
                    children: [
                      ListTile(
                          leading: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                          title: Text('Error Occured'),
                          subtitle: Text(e.toString())),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      );
}
