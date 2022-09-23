import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/models/item.dart';
import 'package:pos_app/shared/config.dart';

Widget itemButton1(BuildContext context, Item item) => Stack(
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
                image: (item.image != null
                    ? NetworkImage(item.image)
                    : AssetImage('assets/no_image1.jpg')) as ImageProvider<Object>,
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
                        item.name.toUpperCase(),
                        textAlign: TextAlign.left,
                        style: GoogleFonts.ubuntuCondensed(
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
                          'PKR ${item.price.toInt().toString()}',
                          style: GoogleFonts.ubuntuCondensed(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            wordSpacing: 1.0,
                          ),
                        ),
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

Widget itemButton2(
    {BuildContext? context,
    required Item item,
    bool showSubtitle = false,
    String? subtitle,
    bool isSelectable = false,
    bool? selected = false,
    void Function()? onTap}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 3,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Positioned(
              bottom: 10,
              right: 10,
              child: isSelectable
                  ? Center(
                      child: selected!
                          ? Icon(Icons.check_circle_rounded)
                          : Icon(Icons.check_circle_outline_outlined),
                    )
                  : Container(),
            ),
            Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    item.name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ubuntuCondensed(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0,
                      wordSpacing: 0.5,
                    ),
                  ),
                ),
                showSubtitle
                    ? Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              subtitle!,
                              style: GoogleFonts.ubuntuCondensed(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                wordSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Divider(),
                Expanded(
                  child: Text(
                    'PKR ${item.price}',
                    style: GoogleFonts.ubuntuCondensed(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
