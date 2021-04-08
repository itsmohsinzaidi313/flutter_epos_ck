import 'package:flutter/material.dart';
import '../config.dart';

class DashboardCard extends StatelessWidget {
  DashboardCard({
    @required this.title,
    @required this.onTap,
    @required this.asset
  });
  final String asset;
  final String title;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Config.getDeviceHeight(context),
      width: Config.getDeviceWidth(context),
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
                  width: 80,
                  height: 80,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                    letterSpacing: 2.0,
                    color: Colors.redAccent,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    '',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
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
