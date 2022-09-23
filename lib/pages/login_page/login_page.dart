import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/pages/menu_page/menu_page.dart';
import 'package:pos_app/pages/menu_page/menu_page_arguments.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/bloc/login_bloc/login_bloc.dart';

part 'login_page_widgets.dart';

class LoginPage extends StatelessWidget {
  static const String path = 'login_page';
  late TextEditingController ipAddress;
  late TextEditingController username;
  late TextEditingController password;


  bool _validateCredentials(
      String ipAddress, String username, String password) {
    if ((Lib.validateIpAddress(ipAddress)) &&
        (username).isNotEmpty &&
        (password).isNotEmpty)
      return true;
    else
      return false;
  }

  void _submitCredentials(BuildContext context) {
    if (_validateCredentials(
      ipAddress.text,
      username.text,
      password.text,
    )) {
      context.read<LoginBloc>().add(
            LoginPressed(
              ipaddress: ipAddress.text,
              username: username.text,
              password: password.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<LoginBloc>().add(LoginInit());
    ipAddress = TextEditingController(text: '');
    username = TextEditingController(text: '');
    password = TextEditingController(text: '');
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is LoginBlocInitial) {
              ipAddress.text = state.ipAddress;
              username.text = state.username;
              password.text = state.password;
            } else if (state is LoadedState) {
              AppTheme.snackbar(context, state.message);
              if (state.allowLogin) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  MenuPage.path,
                  (route) => false,
                  arguments: MenuPageArgs(
                    user: state.user,
                  ),
                );
              }
            } else if (state is LoadingState) {
              AppTheme.snackbar(context, state.message);
            } else if (state is ErrorState) {
              AppTheme.snackbar(context, state.message);
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(38.0),
                        child: Image.asset('assets/images/logo.ico'),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    child: _TextFields(
                      ipAddress: ipAddress,
                      username: username,
                      password: password,
                      onTap: _submitCredentials,
                      onSubmitted: _submitCredentials,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
