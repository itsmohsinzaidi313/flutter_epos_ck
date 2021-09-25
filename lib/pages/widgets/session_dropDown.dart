import 'package:flutter/material.dart';
import 'package:pos_app/bloc/order_info_bloc/order_info_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/models/objects/session.dart';
import 'package:pos_app/shared/config.dart';

class SessionDropdown extends StatefulWidget {
  final List<Session> sessions;
  SessionDropdown({this.sessions});

  @override
  _SessionDropdownState createState() => _SessionDropdownState();
}

class _SessionDropdownState extends State<SessionDropdown> {
  Session selectedSession;
  List<DropdownMenuItem<Session>> items;

  @override
  void initState() {
    super.initState();
    selectedSession = widget.sessions.first;
    items = widget.sessions
        .map((e) =>
            DropdownMenuItem<Session>(value: e, child: Text(e.sessionName)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        padding: EdgeInsets.all(3.0),
        margin: EdgeInsets.all(5.0),
        height: Config.getDeviceHeight(context) * 0.1,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: DropdownButton<Session>(
          icon: Icon(Icons.arrow_drop_down_circle),
          iconSize: 24,
          elevation: 16,
          value: selectedSession,
          isExpanded: true,
          style: TextStyle(
            color: Colors.grey[700],
          ),
          onChanged: (newValue) {
            setState(() {
              selectedSession = newValue;
              context
                  .read<OrderInfoBloc>()
                  .add(OrderInfoSessionChanged(session: newValue));
            });
          },
          items: items,
        ),
      ),
    );
  }
}
