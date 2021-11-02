import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/models/waiter.dart';

class WaitersGrid extends StatefulWidget {
  final List<Waiter> listWaiters;
  final void Function(Waiter waiter) onTap;
  WaitersGrid({this.listWaiters, this.onTap});
  @override
  _WaitersGridState createState() => _WaitersGridState();
}

class _WaitersGridState extends State<WaitersGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.listWaiters.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemBuilder: (context, index) => Container(
        child: Card(
          color: widget.listWaiters[index].selected
              ? Colors.redAccent[200]
              : Colors.white,
          child: InkWell(
            child: Stack(
              children: [
                Positioned(
                  bottom: 2,
                  left: 2,
                  child: Text(
                    widget.listWaiters[index].name.toUpperCase(),
                    style: GoogleFonts.ubuntuCondensed(
                      color: widget.listWaiters[index].selected
                          ? Colors.black
                          : Colors.grey[800],
                      fontSize: 14,
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
                    margin: EdgeInsets.all(20),
                    child: Image(
                      image: AssetImage('assets/waiter.png'),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              widget.onTap(widget.listWaiters[index]);
            },
          ),
        ),
      ),
    );
  }
}
