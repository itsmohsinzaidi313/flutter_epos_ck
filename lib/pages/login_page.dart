import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/pages/widgets/verbose_widget.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/bloc/login_bloc/login_bloc.dart';
import 'package:pos_app/shared/web_data_import.dart';
import '../shared/config.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username;
  String password;
  String deviceKey;
  TextEditingController dKeyController;
  TextEditingController loginBtnText;

  bool _obscureText = true;
  bool isLoading = false;

  Icon _icon = Icon(Icons.visibility_off);
  Color activeColor = Colors.yellow[700];

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
      _icon =
          _obscureText ? Icon(Icons.visibility_off) : Icon(Icons.visibility);
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<LoginBloc>().add(LoginInit());
    dKeyController = TextEditingController();
    loginBtnText = TextEditingController(text: 'Login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<VerboseBloc, VerboseState>(
        listenWhen: (previous, current) => current is VerboseSnackBarState,
        listener: (context, state) {
          AppTheme.snackbar(context, state.message);
        },
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is LoginBlocInitial) {
              Config.deviceKey = Future.value(state.deviceKey);
              dKeyController.text = (await Config.deviceKey) ?? '';
              deviceKey = dKeyController.text;
              AppTheme.snackbar(context, state.message);
            } else if (state is ValidSubmission) {
              AppTheme.snackbar(context, state.message);
            } else if (state is LoginSuccessful) {
              AppTheme.snackbar(context, state.message);
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/menu', (route) => false);
            } else if (state is LoginFailed) {
              AppTheme.snackbar(context, state.message, textColor: Colors.red);
            } else if (state is InvalidSubmission) {
              AppTheme.snackbar(context, state.message);
            } else if (state is ValidDevicekey) {
              final bloc = context.read<VerboseBloc>();
              final import = ImportData(
                  bloc: bloc,
                  database: await LocalDatabase.database.getDatabase());
              bool status = await import.import();
              VerboseWidgets(context: context).showVerboseDialog();
              status
                  ? bloc.add(VerboseNewEvent(message: 'Installation successful.'))
                  : bloc.add(VerboseNewEvent(message: 'Installation failed.'));
              AppTheme.snackbar(context, state.message);
            } else if (state is InvalidDeviceKey) {
              AppTheme.snackbar(context, state.message);
            } else if (state is DatabaseMissing) {
              VerboseWidgets(context: context).showVerboseDialog();
              LocalDatabase.database
                  .initialize(verboseBloc: context.read<VerboseBloc>());
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: SafeArea(
                  child: Container(
                    // margin: EdgeInsets.all(8.0),
                    height: Config.getDeviceHeight(context),
                    width: Config.getDeviceWidth(context),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: Config.getDeviceHeight(context),
                          width: Config.getDeviceWidth(context) * 0.4,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber,
                                Colors.redAccent,
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(
                                  Config.getDeviceHeight(context)),
                            ),
                            color: Colors.amber,
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/dt2.png',
                              ),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(10, 10),
                                            color: Colors.grey[300],
                                            blurRadius: 20),
                                        BoxShadow(
                                            offset: Offset(-10, -10),
                                            color: Colors.grey[300],
                                            blurRadius: 20)
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        color:
                                                            Colors.grey[100]),
                                                  ),
                                                ),
                                                child: TextField(
                                                  controller: dKeyController,
                                                  enabled: true,
                                                  decoration: InputDecoration(
                                                    icon: Icon(Icons.computer),
                                                    border: InputBorder.none,
                                                    labelText: 'Device Key',
                                                    labelStyle: TextStyle(
                                                      color: Colors.grey[400],
                                                    ),
                                                    errorText: state
                                                            is InvalidDeviceKey
                                                        ? 'Required'
                                                        : null,
                                                  ),
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  keyboardType:
                                                      TextInputType.url,
                                                  onChanged: (value) =>
                                                      deviceKey = value,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              child: Text('SUBMIT'),
                                              onPressed: () => context
                                                  .read<LoginBloc>()
                                                  .add(DeviceKeyChanged(
                                                      deviceKey: deviceKey)),
                                            )
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          Colors.grey[100]))),
                                          child: TextField(
                                            enabled: true,
                                            decoration: InputDecoration(
                                              icon: Icon(Icons.person),
                                              border: InputBorder.none,
                                              labelText: 'Username',
                                              errorText:
                                                  state is InvalidUsername
                                                      ? state.message
                                                      : null,
                                              labelStyle: TextStyle(
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                            textInputAction:
                                                TextInputAction.next,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            onChanged: (value) {
                                              return username = value;
                                            },
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          child: Stack(
                                            children: <Widget>[
                                              Positioned(
                                                child: TextField(
                                                  enabled: true,
                                                  decoration: InputDecoration(
                                                    icon: Icon(Icons.vpn_key),
                                                    border: InputBorder.none,
                                                    labelText: 'Password',
                                                    labelStyle: TextStyle(
                                                      color: Colors.grey[400],
                                                    ),
                                                    errorText:
                                                        state is InvalidPassword
                                                            ? 'Required'
                                                            : null,
                                                  ),
                                                  obscureText: _obscureText,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                  onChanged: (value) =>
                                                      password = value,
                                                ),
                                              ),
                                              Positioned(
                                                right: 5,
                                                child: IconButton(
                                                  icon: _icon,
                                                  color: Colors.grey,
                                                  onPressed: _toggle,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.redAccent,
                                          Colors.amber,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(10, 10),
                                            color: Colors.grey[300],
                                            blurRadius: 20),
                                        BoxShadow(
                                            offset: Offset(-10, -10),
                                            color: Colors.grey[300],
                                            blurRadius: 20)
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        splashColor: Colors.yellow[100],
                                        onTap: () {
                                          context.read<LoginBloc>().add(
                                              LoginPressed(
                                                  deviceKey: deviceKey ?? '',
                                                  username: username ?? '',
                                                  password: password ?? ''));
                                        },
                                        child: Center(
                                          child: Text(
                                            'Login',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onSwitchTap(bool value) {
    setState(() {
      if (value) {
        activeColor = Colors.yellow[700];
        Config.activeStatus = 'Online';
      } else {
        activeColor = Colors.grey;
        Config.activeStatus = 'Offline';
      }
    });
  }
}
