import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/models/objects/member.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/shared/config.dart';

Future selectedMembersDialog(BuildContext context, List<Member> member) async {
    return AppTheme.showAlertDialog(
      context,
      title: 'Members List',
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 20,
      buttons: [
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
      content: member.length == 0
          ? Text('List is Empty')
          : SizedBox(
              height: Config.getDeviceHeight(context) * 0.5,
              width: Config.getDeviceHeight(context) * 0.7,
              child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            Text(
                              'Member Name',
                              style: GoogleFonts.ubuntuCondensed(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.black,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              'Years',
                              style: GoogleFonts.ubuntuCondensed(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.black,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: member.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              // tileColor: Colors.grey[200],
                              leading: Icon(Icons.person),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      member[index].memberName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: GoogleFonts.ubuntuMono(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17,
                                        color: Colors.grey[600],
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    (Lib.getCurrentYear() -
                                            int.tryParse(member[index]
                                                .memberElectDate))
                                        .toString(),
                                    style: GoogleFonts.ubuntuMono(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () {},
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
            ),
    );
  }