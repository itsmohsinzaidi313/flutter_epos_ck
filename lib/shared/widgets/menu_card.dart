import 'package:flutter/material.dart';
import 'package:pos_app/shared/config.dart';

class MainMenuCard extends StatelessWidget {
  MainMenuCard(
      {required this.title,
      this.subtitle,
      required this.onTap,
      required this.asset});
  final String asset;
  final String title;
  final String? subtitle;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Config.getDeviceHeight(context) / 5,
      width: Config.getDeviceWidth(context) / 5,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 10.0,
        child: InkWell(
          onTap: onTap as void Function()?,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                                  child: Image(
                    image: AssetImage('assets/$asset'),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Config.getDeviceWidth(context) * 0.02,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                    letterSpacing: 2.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    subtitle!,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Config.getDeviceWidth(context) * 0.01,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
