import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/models/objects/menu_item.dart';

Widget itemButton2(BuildContext context, MenuItem item) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              item.name.toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.ubuntuCondensed(
                color: Colors.grey.shade800,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
                wordSpacing: 0.5,
              ),
            ),
          ),
          Divider(
            color: Colors.amber[800],
          ),
          Expanded(
            child: Text(
              'PKR ${double.parse(item.price).toInt().toString()}',
              style: GoogleFonts.ubuntuCondensed(
                color: Colors.red.shade500,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                wordSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
