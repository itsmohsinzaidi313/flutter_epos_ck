import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pos_app/bloc/order_info_bloc/order_info_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/models/objects/venue.dart';
import 'package:pos_app/shared/config.dart';

class VenueDropdown extends StatefulWidget {
  final List<Venue> venues;
  VenueDropdown({this.venues});

  @override
  _VenueDropdownState createState() => _VenueDropdownState();
}

class _VenueDropdownState extends State<VenueDropdown> {
  Venue selectedVenue;
  List<DropdownMenuItem<Venue>> items;
  @override
  void initState() {
    super.initState();
    selectedVenue = widget.venues.first;
    items = widget.venues
        .map((e) => DropdownMenuItem<Venue>(value: e, child: Text(e.venueName)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        padding: EdgeInsets.all(3.0),
        margin: EdgeInsets.all(5.0),
        height: Config.getDeviceHeight(context) * 0.1,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: DropdownButton<Venue>(
          icon: Icon(Icons.arrow_drop_down_circle),
          iconSize: 24,
          elevation: 16,
          value: selectedVenue,
          isExpanded: true,
          style: TextStyle(
            color: Colors.grey[700],
          ),
          onChanged: (newValue) {
            setState(() {
              selectedVenue = newValue;
              context
                  .read<OrderInfoBloc>()
                  .add(OrderInfoVenueChanged(venue: newValue));
            });
          },
          items: items,
        ),
      ),
    );
  }
}
