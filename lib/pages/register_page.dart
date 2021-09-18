import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/register_bloc/register_bloc.dart';
import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/shared/app_theme.dart';
import '../shared/config.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _ShiftScreen createState() => _ShiftScreen();
}

class _ShiftScreen extends State<RegisterScreen> {
  TextEditingController closingAmount = TextEditingController();
  TextEditingController openingAmount = TextEditingController();
  bool checkField = false;
  String errorMessage = 'Required';

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    passEvent(context, LoadRegister());
    return BlocListener<VerboseBloc, VerboseState>(
      listenWhen: (previous, current) => current is VerboseSnackBarState,
        listener: (context, state) {
          AppTheme.snackbar(context, state.message);
        },
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterOpened) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/menu', (route) => false);
          } else if (state is RegisterClosed) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/login', (route) => false);
          }
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Register'),
              centerTitle: true,
              backgroundColor: Colors.redAccent,
              elevation: 0.0,
            ),
            body: Center(
              heightFactor: 2,
              child: Container(
                child: SingleChildScrollView(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60),
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
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        if (state is RegisterExists) {
                          return bodyLayoutController(1);
                        } else {
                          return bodyLayoutController(2);
                        }
                      },
                    )
                  ]),
                ),
              ),
            ),
            floatingActionButton: BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
                if (state is RegisterExists) {
                  return floatingButtonLayoutController(1);
                } else {
                  return floatingButtonLayoutController(2);
                }
              },
            )),
      ),
    ); // CHANGES FOATING ACTION BUTTON ICON
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
              child: Container(
                width: Config.getDeviceWidth(context) * 0.5,
                child: TextField(
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
                  controller: openingAmount,
                  onChanged: (value) => passEvent(
                    context,
                    OpeningAmountChanged(
                      amount: double.parse(value == '' ? '0.0' : value),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        break;
      case 2:
        return Container(
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
                              borderSide: BorderSide(
                                  color: Colors.amberAccent, width: 1),
                            ),
                            hintText: 'Closing Amount',
                            errorText: checkField ? errorMessage : null),
                        onChanged: (value) => passEvent(
                              context,
                              ClosingAmountChanged(
                                amount: double.parse(value),
                              ),
                            )),
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
          heroTag: 0,
          onPressed: () => passEvent(context, RegisterOpen()),
          child: Icon(Icons.check),
          backgroundColor: Colors.yellow[600],
        );
        break;
      case 2:
        return ButtonBar(
          children: [
            FloatingActionButton(
              heroTag: 1,
              onPressed: () => passEvent(context, RegisterClose()),
              child: Icon(Icons.close),
              backgroundColor: Colors.yellow[600],
            ),
            FloatingActionButton(
              heroTag: 2,
              onPressed: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil('/menu', (route) => false),
              child: Icon(Icons.arrow_right_alt),
              backgroundColor: Colors.yellow[600],
            ),
          ],
        );
        break;
      default:
        return Container();
        break;
    }
  }

  void passEvent(BuildContext context, RegisterEvent event) =>
      context.read<RegisterBloc>().add(event);
}
