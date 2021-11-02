import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/payment_bloc/payment_bloc.dart';
import 'package:pos_app/models/item.dart';
import 'package:pos_app/shared/config.dart';
import '../shared/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentPage extends StatelessWidget {
  final Color cashColor = Colors.grey, percentageColor = Colors.grey;
  final List<String> paymentMethodList = ['Cash', 'Credit'];
  final paymentController = TextEditingController();
  final discountController = TextEditingController();
  final cardNumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    passEvent(context, PaymentBuild());
    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is InvalidCardNumber) {
        } else if (state is InvalidDiscount) {
          AppTheme.snackbar(context, state.message, duration: 1);
        } else if (state is InvalidSubmission) {
          AppTheme.snackbar(context, state.message, duration: 1);
        } else if (state is InvalidPayment) {
          AppTheme.snackbar(context, state.message, duration: 1);
        } else if (state is InvalidCardNumber) {
          AppTheme.snackbar(context, state.message, duration: 1);
        } else if (state is ValidSubmission) {
          AppTheme.snackbar(context, 'Valid Inputs', duration: 1);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.appBarColor,
          title: Text('Payment'.toUpperCase()),
          centerTitle: true,
          actions: [
            Container(
              width: Config.getDeviceWidth(context) * 0.2,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.yellow[700])),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('PAY', style: TextStyle(color: Colors.red)),
                    Icon(
                      Icons.done,
                      color: Colors.red,
                    )
                  ],
                ),
                onPressed: () => passEvent(context, Submit()),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
          height: Config.getDeviceHeight(context) * 0.85,
          width: Config.getDeviceWidth(context),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BlocBuilder<PaymentBloc, PaymentState>(
                      buildWhen: (previous, current) {
                        if (current is CartItems) {
                          return true;
                        } else {
                          return false;
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.attach_money_sharp),
                              title: Text(
                                'Total Amount'.toUpperCase(),
                                style: TextStyle(color: Colors.red),
                              ),
                              subtitle: Text(
                                state.totalAmount,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.redAccent),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.attach_money_sharp),
                              title: Text('Tax Amount'.toUpperCase()),
                              subtitle: Text(state.totalTaxAmount),
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                    BlocBuilder<PaymentBloc, PaymentState>(
                      buildWhen: (previous, current) {
                        if (current is PaymentType) {
                          return true;
                        } else {
                          return false;
                        }
                      },
                      builder: (context, state) {
                        if (state is PaymentType)
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                            ),
                            child: Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.center,
                              children: [
                                Container(
                                  color: state.mode == PAYMENTMODE.CASH
                                      ? Colors.red
                                      : Colors.white,
                                  child: TextButton(
                                    child: Text(
                                      'CASH',
                                      style: TextStyle(
                                          color: state.mode == PAYMENTMODE.CASH
                                              ? Colors.white
                                              : Colors.red),
                                    ),
                                    style: ButtonStyle(),
                                    onPressed: () => passEvent(
                                      context,
                                      PaymentModeChanged(
                                          mode: PAYMENTMODE.CASH),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: state.mode == PAYMENTMODE.CREDIT
                                        ? Colors.red
                                        : Colors.white,
                                    border: Border(
                                      left: BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  child: TextButton(
                                    style: ButtonStyle(),
                                    child: Text(
                                      'CREDIT',
                                      style: TextStyle(
                                          color:
                                              state.mode == PAYMENTMODE.CREDIT
                                                  ? Colors.white
                                                  : Colors.red),
                                    ),
                                    onPressed: () => passEvent(
                                      context,
                                      PaymentModeChanged(
                                          mode: PAYMENTMODE.CREDIT),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        else {
                          return Container();
                        }
                      },
                    ),
                    BlocBuilder<PaymentBloc, PaymentState>(
                      buildWhen: (previous, current) {
                        if (current is PaymentType) {
                          return true;
                        } else {
                          return false;
                        }
                      },
                      builder: (context, state) {
                        if (state is PaymentType) {
                          paymentController.text = '0';
                          cardNumController.text = '0';
                          if (state.mode == PAYMENTMODE.CASH) {
                            return ListTile(
                              leading: Icon(Icons.arrow_forward_rounded),
                              title: TextField(
                                controller: paymentController,
                                decoration:
                                    InputDecoration(labelText: 'Payment'),
                                onChanged: (value) => passEvent(
                                    context, PaymentChanged(payment: value)),
                                keyboardType: TextInputType.number,
                              ),
                            );
                          } else {
                            return ListTile(
                              leading: Icon(Icons.arrow_forward_rounded),
                              title: TextField(
                                controller: cardNumController,
                                decoration:
                                    InputDecoration(labelText: 'Card Number'),
                                onChanged: (value) => passEvent(
                                  context,
                                  CardNumberChanged(cardNumber: value),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            );
                          }
                        } else {
                          return Container();
                        }
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.arrow_forward_rounded),
                      title: TextField(
                        controller: discountController,
                        decoration: InputDecoration(labelText: 'Discount'),
                        onChanged: (value) => passEvent(
                            context, DiscountChanged(discount: value)),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<PaymentBloc, PaymentState>(
                  buildWhen: (previous, current) {
                    if (current is CartItems) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                  builder: (context, state) {
                    if (state is CartItems) {
                      if (state.list.length < 1) {
                        return Container(
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              // scale: 10,
                              image: AssetImage(
                                'assets/empty_cart.png',
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(5),
                            shape: BoxShape.rectangle,
                            border: Border(
                              left: BorderSide(
                                color: Colors.grey[300],
                                width: 2,
                              ),
                              right: BorderSide(
                                color: Colors.grey[300],
                                width: 2,
                              ),
                              bottom: BorderSide(
                                color: Colors.grey[300],
                                width: 2,
                              ),
                              top: BorderSide(
                                color: Colors.grey[300],
                                width: 2,
                              ),
                            ),
                          ),
                          child: ListView(
                            children:
                                getCartItemsNewWidgets(context, state.list),
                          ),
                        );
                      }
                    } else {
                      return AppTheme.progIndicator;
                    }
                  },
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  List<Widget> getCartItemsNewWidgets(
          BuildContext context, List<Item> lstItem) =>
      lstItem
          .map((item) => Card(
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
                            onPressed: () {
                              context
                                  .read<PaymentBloc>()
                                  .add(ReduceItem(itemId: int.parse(item.id)));
                            },
                          ),
                          Text(
                            item.quantity.toString(),
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
                                .read<PaymentBloc>()
                                .add(AddItem(itemId: int.parse(item.id))),
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
                            String comments = item.comment;

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
                                      controller:
                                          TextEditingController(text: comments),
                                      onChanged: (value) => comments = value,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('Ok'),
                                    ),
                                  ]),
                            );
                            item.comment = comments;
                            context.read<PaymentBloc>().add(AddComment(
                                itemId: int.parse(item.id), comment: comments));
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.yellow.shade800,
                            size: 22,
                          ),
                          onPressed: () => context
                              .read<PaymentBloc>()
                              .add(RemoveItem(itemId: int.parse(item.id))),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          .toList() ??
      [];

  Widget getWidget(PaymentState state) {
    if (state is PaymentType && state.mode == paymentMethodList[0]) {
      return Container(
        margin: EdgeInsets.only(
          top: 20,
        ),
        child: Card(
          color: Colors.grey[100],
          child: ListTile(
            leading: Icon(
              Icons.credit_card,
              color: Colors.yellow[700],
            ),
            title: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amberAccent, width: 1),
                  ),
                  hintText: 'Credit Number',
                  errorText: null),
            ),
          ),
        ),
      );
    } else if (state is PaymentType && state.mode == paymentMethodList[1]) {
      return Container(
        margin: EdgeInsets.only(
          top: 20,
        ),
        child: Card(
          color: Colors.grey[100],
          child: ListTile(
            leading: Icon(Icons.monetization_on, color: Colors.yellow[700]),
            title: TextField(
              keyboardType: TextInputType.number,
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amberAccent, width: 1),
                ),
                hintText: 'Amount',
                errorText: null,
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 10,
      );
    }
  }

  void passEvent(BuildContext context, PaymentEvent event) =>
      context.read<PaymentBloc>().add(event);
}
