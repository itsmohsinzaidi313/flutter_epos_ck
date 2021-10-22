import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/models/item.dart';
import 'package:pos_app/shared/config.dart';

Widget cartItemTile(
    {BuildContext context,
    Item item,
    void Function() onTap,
    void Function() onAddItem,
    void Function() onReduceItem,
    void Function() onRemoveItem,
    void Function(String) onQuantityChanged,
    void Function() onItemCommentPressed}) {
  final controller = TextEditingController(text: item.quantity.toString());
  return InkWell(
    onTap: onTap,
    child: Card(
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
          item.name.toUpperCase(),
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
              ' ${item.price.toInt().toString()} x ${item.quantity} '
              '= ${(item.price.toInt() * item.quantity).toString()}',
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
                  onPressed: onReduceItem,
                ),
                // Text(
                //   item.quantity.toString(),
                //   style: TextStyle(
                //     color: Colors.grey.shade900,
                //     fontSize: 12,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                Container(
                  width: Config.getDeviceWidth(context) * 0.05,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onSubmitted: onQuantityChanged,
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                          ),
                          controller: controller,
                          style: TextStyle(
                            color: Colors.grey.shade900,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.red,
                  ),
                  onPressed: onAddItem,
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
                onPressed: onItemCommentPressed,
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.yellow.shade800,
                  size: 22,
                ),
                onPressed: onRemoveItem,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
