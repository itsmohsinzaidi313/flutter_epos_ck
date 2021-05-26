import 'package:flutter/material.dart';
import '../config.dart';

class MainMenuCard extends StatelessWidget {
  MainMenuCard(
      {@required this.title,
      this.subtitle,
      @required this.onTap,
      @required this.asset});
  final String asset;
  final String title;
  final String subtitle;
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/$asset'),
                  fit: BoxFit.contain,
                  width: Config.getDeviceWidth(context) * 0.12,
                  height: Config.getDeviceHeight(context) * 0.12,
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
                    color: Colors.redAccent,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    subtitle,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Config.getDeviceWidth(context) * 0.01,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 2.0,
                      color: Colors.grey,
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
