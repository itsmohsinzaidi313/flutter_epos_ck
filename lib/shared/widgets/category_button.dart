import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/models/items_category.dart';
import 'package:pos_app/shared/config.dart';

Widget categoryButton(
        {BuildContext context,
        Category category,
        String text = '',
        void Function() onTap}) =>
    InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        color: category.selected ? Colors.redAccent[200] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                child: CircleAvatar(
                  radius: 13,
                  child: CircleAvatar(
                    backgroundColor:
                        category.selected ? Colors.grey.shade700 : Colors.white,
                    radius: 9,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color:
                      category.selected ? Colors.redAccent[200] : Colors.white,
                ),
                height: Config.getDeviceHeight(context) * 0.1,
                width: Config.getDeviceWidth(context) * 0.1,
                child: Center(
                  child: Text(
                    '${category.name.toUpperCase()} $text',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ubuntuCondensed(
                      color: category.selected
                          ? Colors.white
                          : Colors.red.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      wordSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
