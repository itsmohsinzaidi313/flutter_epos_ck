import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/models/item.dart';

Future<void> showDealDetail(
    BuildContext context, String dealName, List<Item> dealItems) async {
  String itemNames = '';
  for (var item in dealItems) {
    itemNames += '${item.name} ${(item.quantity.toInt() + 1).toString()}\n';
  }
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        '$dealName',
        style: GoogleFonts.ubuntuCondensed(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          wordSpacing: 0.5,
        ),
      ),
      content: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          child: Text(
            itemNames,
            style: GoogleFonts.ubuntuCondensed(
              color: Colors.grey.shade500,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              wordSpacing: 0.5,
            ),
          ),
        ),
      ),
    ),
  );
}
