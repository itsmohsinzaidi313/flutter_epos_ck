import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/pages/menu_page/menu_page_buttons.dart';
import 'package:pos_app/shared/app_theme.dart';

class MenuScreen extends StatelessWidget {
  final closingAmount = TextEditingController();
  bool checkField = false;
  String errorMessage = 'Required';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool value = await AppTheme.showAlertDialogYNFutureReturn(context,
            message: 'Exit application?', title: 'Attention');
        return value;
      },
      child: BlocListener<VerboseBloc, VerboseState>(
        listenWhen: (previous, current) => current is VerboseSnackBarState,
        listener: (context, state) {
          AppTheme.snackbar(context, state.message);
        },
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            backgroundColor: Colors.red,
            elevation: 0.0,
            title: Row(
              children: [
                // TODO: PROVICE USER's NAME
                // Text(
                //   'User: ${Config.user.name}'.toUpperCase(),
                // ),
                Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: GridView(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
            children: MenuPageButtons(context: context).buttons,
          ),
        ),
      ),
    );
  }
}
