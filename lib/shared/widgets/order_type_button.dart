import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/shared/config.dart';

Widget orderTypeButton(
          BuildContext context, String title, Function onTap, ImageProvider asset) =>
      Card(
        color: Color(0xff7c94b6),
        elevation: 5,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: asset,
                // colorFilter: new ColorFilter.mode(
                //     Colors.black.withOpacity(0.6), BlendMode.dstATop),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 2,
            ),
            height: Config.getDeviceHeight(context) * 0.25,
            width: Config.getDeviceWidth(context),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                title,
                style: GoogleFonts.ptSans(
                  fontSize: 35,
                  letterSpacing: 3.0,
                  wordSpacing: 1.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );