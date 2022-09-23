import 'package:flutter/material.dart';
import 'package:pos_app/shared/config.dart';

class CustomAppBar extends StatelessWidget {
  final Widget searchBar;
  final Widget radioButtons;
  final String appBarTitle;
  final Function onBackPressed;

  CustomAppBar(
      {required this.searchBar,
      required this.radioButtons,
      required this.appBarTitle,
      required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
              size: 20,
            ),
            onPressed: onBackPressed as void Function()?,
          ),
          Text(
            appBarTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(child: SizedBox()),
          Container(
            width: Config.getDeviceWidth(context) * 0.5,
            child: Card(child: searchBar),
          ),
        ],
      ),
    );
  }
}
