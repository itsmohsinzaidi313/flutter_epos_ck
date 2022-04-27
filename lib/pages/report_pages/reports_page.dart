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
            child: Row(
              children: [Icon(Icons.settings), Text('Settings')],
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
