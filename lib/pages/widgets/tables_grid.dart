import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/models/customer_table.dart';

class TablesGrid extends StatefulWidget {
  final List<Tables> listTables;
  final void Function(BuildContext context, Tables table) onTap;
  const TablesGrid({this.listTables, this.onTap});

  @override
  _TablesGridState createState() => _TablesGridState();
}

class _TablesGridState extends State<TablesGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.listTables.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) => Card(
        elevation: 10,
        color: widget.listTables[index].selected
            ? Colors.redAccent[200]
            : Colors.grey.shade100,
        child: InkWell(
          child: Stack(
            children: [
              Positioned(
                top: 2,
                left: 2,
                child: Text(
                  widget.listTables[index].tableName,
                  style: GoogleFonts.ubuntuCondensed(
                    color: Colors.grey.shade900,
                    fontSize: 16,
                    letterSpacing: 1.0,
                    wordSpacing: 1.0,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Image(
                    image: AssetImage('assets/table.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(-1, -1),
                        blurRadius: 2,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: widget.listTables[index].reserved
                      ? Icon(Icons.lock, color: Colors.black)
                      : Icon(Icons.check,
                          color: widget.listTables[index].selected
                              ? Colors.green
                              : Colors.white),
                ),
              ),
            ],
          ),
          onTap: () {
            widget.onTap(context, widget.listTables[index]);
          },
        ),
      ),
    );
  }
}
