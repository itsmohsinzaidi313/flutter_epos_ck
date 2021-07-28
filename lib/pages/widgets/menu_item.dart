import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/models/objects/menu_item.dart';
import 'package:pos_app/shared/config.dart';

Widget itemButton1(BuildContext context, MenuItem item) => Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          child: Container(
            height: Config.getDeviceHeight(context) * 0.2,
            width: Config.getDeviceWidth(context) * 0.159,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              image: DecorationImage(
                image: item.image != null
                    ? NetworkImage(item.image)
                    : AssetImage('assets/no_image1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        item.image == null
            ? Align(
                alignment: Alignment.center,
                child: Text(
                  'No Image'.toUpperCase(),
                  style: GoogleFonts.anton(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Container(),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            padding: EdgeInsets.only(top: 15, bottom: 8, left: 8, right: 8),
            height: Config.getDeviceHeight(context) * 0.094,
            width: Config.getDeviceWidth(context) * 0.158,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        item.NAME.toUpperCase(),
                        textAlign: TextAlign.left,
                        style: GoogleFonts.ubuntuCondensed(
                          color: Colors.grey.shade800,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0,
                          wordSpacing: 0.5,
                        ),
                      ),
                    ),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'PKR ${double.parse(item.PRICE).toInt().toString()}',
                          style: GoogleFonts.ubuntuCondensed(
                            color: Colors.red.shade500,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            wordSpacing: 1.0,
                          ),
                        ),
                        // Row(
                        //   children: [
                        //     Icon(
                        //       Icons.star,
                        //       size: 10,
                        //       color: Colors.yellow.shade900,
                        //     ),
                        //     Icon(
                        //       Icons.star,
                        //       size: 10,
                        //       color: Colors.yellow.shade900,
                        //     ),
                        //     Icon(
                        //       Icons.star_half_outlined,
                        //       size: 10,
                        //       color: Colors.yellow.shade900,
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );

Widget itemButton2(BuildContext context, MenuItem item) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              item.NAME.toUpperCase(),
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
              'PKR ${double.parse(item.PRICE).toInt().toString()}',
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
