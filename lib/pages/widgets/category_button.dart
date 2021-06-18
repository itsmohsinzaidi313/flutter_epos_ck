import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/bloc/pos_bloc/pos_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/models/objects/items_category.dart';
import 'package:pos_app/shared/config.dart';

Widget categoryButton(BuildContext context, List<Category> list, int index) => Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      color: list[index].selected ? Colors.redAccent[200] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () => context
              .read<POSBloc>()
              .add(CategoryChanged(categoryId: list[index].id)),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.yellow.shade700,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 13,
                  child: CircleAvatar(
                    backgroundColor: list[index].selected
                        ? Colors.grey.shade700
                        : Colors.white,
                    radius: 9,
                  ),
                ),
              ),
              Container(
                height: Config.getDeviceHeight(context) * 0.1,
                width: Config.getDeviceHeight(context) * 0.18,
                color:
                    list[index].selected ? Colors.redAccent[200] : Colors.white,
                child: Center(
                  child: Text(
                    list[index].name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ubuntuCondensed(
                      color: list[index].selected
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
