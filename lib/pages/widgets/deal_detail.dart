import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/models/deals.dart';

Future<void> showDealDetail(BuildContext context, OnSpotDeal deal) async {
  String dealItems = '';
  for (var item in deal.dealItems) {
    dealItems += '${item.name} ${item.quantity.toInt().toString()}\n';
  }
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        '${deal.name}',
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
            dealItems,
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
