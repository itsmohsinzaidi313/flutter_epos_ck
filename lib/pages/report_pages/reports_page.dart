import 'package:flutter/material.dart';
import 'package:pos_app/shared/app_theme.dart';

class ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.appBarNormal(
        appBarTitle: 'Reports',
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.amber)),
            child: Row(
              children: [
                Icon(Icons.settings, color: Colors.red),
                Text(
                  'Settings',
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {},
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Update'),
        ],
      ),
    );
  }
}
