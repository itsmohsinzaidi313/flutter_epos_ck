import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pos_app/objects/menu_item.dart';
import 'package:pos_app/shared/config.dart';

const double _WIDTH_FACTOR = 0.6;
Future<MenuItem> openFoodDialog(BuildContext context, String categoryId) async {
  final nameCntrlr = TextEditingController(text: '');
  final priceCntrlr = TextEditingController(text: '0');
  final qtyCntrlr = TextEditingController(text: '0');
  final taxCntrlr = TextEditingController(text: '13');
  return await showDialog<MenuItem>(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return SimpleDialog(
        titlePadding: EdgeInsets.all(0.0),
        title: Container(
          padding: EdgeInsets.all(8.0),
          color: Colors.red,
          child: Center(
            child: Text(
              'Open Food',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: StatefulBuilder(
              builder: (context, setState) => Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: Config.getDeviceWidth(context) * _WIDTH_FACTOR,
                        child: TextField(
                          controller: nameCntrlr,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            errorText: _checkItemName(nameCntrlr.text),
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: Config.getDeviceWidth(context) * _WIDTH_FACTOR,
                        child: TextField(
                          controller: priceCntrlr,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            errorText: _checkItemPrice(priceCntrlr.text),
                          ),
                          onChanged: (value) => setState(() {}),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: Config.getDeviceWidth(context) * _WIDTH_FACTOR,
                        child: TextField(
                          controller: qtyCntrlr,
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            errorText: _checkItemQuantity(priceCntrlr.text),
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: Config.getDeviceWidth(context) * _WIDTH_FACTOR,
                        child: TextField(
                          controller: taxCntrlr,
                          decoration: InputDecoration(
                            labelText: 'Tax(%)',
                            errorText: _checkItemTax(taxCntrlr.text),
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: Text('Ok'),
                          onPressed: () {
                            if ((_checkItemName(nameCntrlr.text) == null) &&
                                (_checkItemPrice(priceCntrlr.text) == null) &&
                                (_checkItemQuantity(qtyCntrlr.text) == null) &&
                                _checkItemTax(taxCntrlr.text) == null) {
                              Navigator.of(context).pop(
                                MenuItem(
                                  id: Random.secure()
                                      .nextInt(1000000)
                                      .toString(),
                                  code: MenuItem.OPENFOOD_CODE.toString(),
                                  name: nameCntrlr.text,
                                  price: priceCntrlr.text,
                                  quantity: double.parse(qtyCntrlr.text),
                                  categoryId: categoryId,
                                  taxAmount: _taxAmount(
                                          priceCntrlr.text, taxCntrlr.text)
                                      .toStringAsFixed(2),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop(null),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

String _checkItemName(String text) {
  if (text == null) {
    return 'Required';
  }
  if (text == '') {
    return 'Required';
  }
  return null;
}

String _checkItemPrice(String text) {
  if (double.tryParse(text) == null) {
    return 'Required';
  }
  if (double.tryParse(text) <= 0) {
    return 'Price cannot be zero or less';
  }
  return null;
}

String _checkItemQuantity(String text) {
  if (double.tryParse(text) == null) {
    return 'Required';
  }
  if (double.tryParse(text) <= 0) {
    return 'Quantity cannot be zero or less';
  }
  return null;
}

String _checkItemTax(String text) {
  if (double.tryParse(text) == null) {
    return 'Required';
  }
  if (double.tryParse(text) <= 0) {
    return 'Tax cannot be zero or less';
  }
  return null;
}

double _taxAmount(String amount, String tax) {
  return (double.parse(amount) * (double.parse(tax) / 100)) +
      double.parse(amount);
}
