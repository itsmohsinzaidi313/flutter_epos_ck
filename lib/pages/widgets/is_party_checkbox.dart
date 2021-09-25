import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/order_info_bloc/order_info_bloc.dart';

class IsPartyCheckBox extends StatefulWidget {
  final bool isChecked;
  IsPartyCheckBox({this.isChecked});
  @override
  _IsPartyCheckBoxState createState() => _IsPartyCheckBoxState();
}

class _IsPartyCheckBoxState extends State<IsPartyCheckBox> {
  bool option;
  @override
  void initState() {
    super.initState();
    option = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: option,
          onChanged: (value) {
            setState(() {
              option = value;
              context
                  .read<OrderInfoBloc>()
                  .add(OrderInfoPartyChanged(party: value));
            });
          },
        ),
        Text(
          'Party',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
