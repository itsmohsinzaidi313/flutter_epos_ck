import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pos_app/shared/config.dart';

class ShiftScreen extends StatefulWidget {
  @override
  _ShiftScreen createState() => _ShiftScreen();
}

class _ShiftScreen extends State<ShiftScreen> {
  String _dropdown = 'Morning';
  TextEditingController closingAmount = TextEditingController();
  TextEditingController openingAmount = TextEditingController();
  bool checkField = false;
  String errorMessage = 'Required';

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Shift'),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
          elevation: 0.0,
        ),
        body: Center(
          child: Container(
            child: SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CircleAvatar(
                      radius: 90.0,
                      backgroundColor: Colors.yellow[600],
                      child: CircleAvatar(
                        radius: 80.0,
                        backgroundImage: AssetImage('assets/money-bag.jpg'),
                      ),
                    ),
                  ),
                ),
                bodyLayoutController(1)
              ]),
            ),
          ),
        ),
        floatingActionButton: floatingButtonLayoutController(
            1)); // CHANGES FOATING ACTION BUTTON ICON
  }

  Widget bodyLayoutController(int layoutType) {
    switch (layoutType) {
      case 1:
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                // autovalidate: _autoValidate,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Select Shift',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                              )),
                          DropdownButton<String>(
                            value: _dropdown,
                            icon: Icon(Icons.arrow_drop_down_circle),
                            iconSize: 24,
                            elevation: 16,
                            isExpanded: true,
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                _dropdown = newValue;
                              });
                            },
                            items: <DropdownMenuItem<String>>[],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Amount",
                          prefixIcon: Icon(
                            Icons.attach_money,
                            size: 20,
                            color: Colors.amber,
                          ),
                          hintText: "1000",
                          hintStyle: TextStyle(
                            color: Colors.grey[300],
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          if (value.isEmpty ||
                              value.length < 0 ||
                              int.parse(value) <= 0) {
                            return 'Invalid Amount';
                          }
                          return null;
                        },
                        controller: openingAmount,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        break;
      case 2:
        return Container(
          // padding: EdgeInsets.all(10.0),
          // margin: EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          width: Config.getDeviceWidth(context) * 0.4,
          child: Wrap(
            children: [
              Container(
                child: Card(
                  color: Colors.grey[100],
                  child: ListTile(
                    leading: Icon(
                      Icons.monetization_on,
                      color: Colors.grey[600],
                    ),
                    title: TextField(
                      keyboardType: TextInputType.number,
                      controller: closingAmount,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.amberAccent, width: 1),
                          ),
                          hintText: 'Closing Amount',
                          errorText: checkField ? errorMessage : null),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      default:
        return Container(
          child: Text('Invalid Layout Type'),
        );
        break;
    }
  }

  Widget floatingButtonLayoutController(int layoutType) {
    switch (layoutType) {
      case 1:
        return FloatingActionButton(
          onPressed: () {
            setState(() {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
              } else {
                // _autoValidate = true;
              }
            });
          },
          child: Icon(Icons.check),
          backgroundColor: Colors.yellow[600],
        );
        break;
      case 2:
        return FloatingActionButton(
          onPressed: () async {
            try {} catch (e) {
              log(e);
            }
          },
          child: Icon(Icons.close),
          backgroundColor: Colors.yellow[600],
        );
        break;
      default:
        return Container();
        break;
    }
  }
}
