import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/bloc/pos_bloc/pos_bloc.dart';
import 'package:pos_app/objects/menu_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget cartMenuItem(BuildContext context, List<MenuItem> items, int index, Animation<double> animation) => Card(
      elevation: 4,
      child: ListTile(
        // leading: CircleAvatar(
        //   backgroundColor: Colors.yellow.shade700,
        //   radius: 16,
        //   child: CircleAvatar(
        //     radius: 14,
        //     backgroundImage: AssetImage('assets/no_image1.jpg'),
        //   ),
        // ),
        title: Text(
          items[index].name.toUpperCase(),
          style: GoogleFonts.ubuntuCondensed(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            wordSpacing: 0.5,
          ),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            Text(
              ' ${double.parse(items[index].price).toInt().toString()} x ${items[index].quantity} '
              '= ${(double.parse(items[index].price).toInt() * items[index].quantity).toString()}',
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 12,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    context
                        .read<POSBloc>()
                        .add(ReduceItem(code: int.parse(items[index].code), itemId: int.parse(items[index].id),),);
                  },
                ),
                Text(
                  items[index].quantity.toString(),
                  style: TextStyle(
                    color: Colors.grey.shade900,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.red,
                  ),
                  onPressed: () => context
                      .read<POSBloc>()
                      .add(AddItem(code: int.parse(items[index].code), itemId: int.parse(items[index].id),),),
                ),
              ],
            ),
          ],
        ),
        isThreeLine: true,
        trailing: SizedBox(
          width: 96,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.red.shade800,
                  size: 22,
                ),
                onPressed: () async {
                  String comments = items[index].comment;

                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                        title: Text('Comments'),
                        content: ListTile(
                          leading: Icon(
                            Icons.edit,
                            color: Colors.redAccent,
                          ),
                          title: TextField(
                            controller: TextEditingController(text: comments),
                            onChanged: (value) => comments = value,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Ok'),
                          ),
                        ]),
                  );
                  items[index].comment = comments;
                  context.read<POSBloc>().add(AddComment(
                      code: int.parse(items[index].code), itemId: int.parse(items[index].id), comment: comments));
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.yellow.shade800,
                  size: 22,
                ),
                onPressed: () => context
                    .read<POSBloc>()
                    .add(RemoveItem(code: int.parse(items[index].id), itemId: int.parse(items[index].id),),),
              ),
            ],
          ),
        ),
      ),
    );
