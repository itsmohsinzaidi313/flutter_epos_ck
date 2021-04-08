import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/dashboard_screen.dart';
import 'package:pos_app/bloc/login_bloc/login_bloc.dart';
import '../shared/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username;
  String password;
  String ipAddress;
  TextEditingController ipController;

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
    ipController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<LoginBloc, LoginBlocState>(
        listener: (context, state) {
          if (state is LoginBlocInitial) {
            Config.serverIp = state.ipAddress;
            ipController.text = Config.serverIp;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Please Wait...'),
              duration: Duration(microseconds: 1000),
            ));
          } else if (state is Successful) {
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => DashboardScreen(),
            ));
            // Navigator.of(context)
            //     .pushAndRemoveUntil(new MaterialPageRoute(
            //   builder: (context) => DashboardScreen(),
            // ), (route) => false);
          } else if (state is Failed) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is InvalidSubmission) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is ValidIpAddress) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is InvalidIpAddress) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<LoginBloc, LoginBlocState>(
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            Config.activeStatus,
                                            style: GoogleFonts.ubuntuCondensed(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                                letterSpacing: 1.0,
                                                color: activeColor),
                                          ),
                                          Switch(
                                            value: true,
                                            onChanged: _onSwitchTap,
                                            activeTrackColor:
                                                Colors.yellowAccent[600],
                                            activeColor: Colors.yellow[700],
                                            inactiveTrackColor:
                                                Colors.grey[200],
                                            inactiveThumbColor: Colors.grey,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.grey[100]),
                                                ),
                                              ),
                                              child: TextField(
                                                controller: ipController,
                                                enabled: true,
                                                decoration: InputDecoration(
                                                  icon: Icon(Icons.computer),
                                                  border: InputBorder.none,
                                                  labelText: 'Ip Address',
                                                  labelStyle: TextStyle(
                                                    color: Colors.grey[400],
                                                  ),
                                                  errorText:
                                                      state is InvalidIpAddress
                                                          ? 'Required'
                                                          : null,
                                                ),
                                                textInputAction:
                                                    TextInputAction.next,
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (value) =>
                                                    ipAddress = value,
                                              ),
                                              // child: FutureBuilder(
                                              //   future: SharedPreferences
                                              //       .getInstance(),
                                              //   builder: (context, snapshot) {
                                              //     TextEditingController
                                              //         ipController =
                                              //         TextEditingController();
                                              //     if (snapshot.hasData) {
                                              //       final perf = snapshot.data
                                              //           as SharedPreferences;
                                              //       ipAddress = perf
                                              //           .getString('ipAddress');
                                              //       Config.serverIp = ipAddress;
                                              //     }
                                              //     return TextField(
                                              //       controller: ipController,
                                              //       enabled: true,
                                              //       decoration: InputDecoration(
                                              //         icon:
                                              //             Icon(Icons.computer),
                                              //         border: InputBorder.none,
                                              //         labelText: 'Ip Address',
                                              //         labelStyle: TextStyle(
                                              //           color: Colors.grey[400],
                                              //         ),
                                              //         errorText: state
                                              //                 is InvalidIpAddress
                                              //             ? 'Required'
                                              //             : null,
                                              //       ),
                                              //       textInputAction:
                                              //           TextInputAction.next,
                                              //       keyboardType:
                                              //           TextInputType.number,
                                              //       onChanged: (value) =>
                                              //           ipAddress = value,
                                              //     );
                                              //   },
                                              // ),
                                            ),
                                          ),
                                          TextButton(
                                            child: Text('SUBMIT'),
                                            onPressed: () => context
                                                .read<LoginBloc>()
                                                .add(IpAddressChanged(
                                                    ipaddress: ipAddress)),
                                          )
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey[100]))),
                                        child: TextField(
                                          enabled: true,
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.person),
                                            border: InputBorder.none,
                                            labelText: 'Username',
                                            errorText: state is InvalidUsername
                                                ? state.message
                                                : null,
                                            labelStyle: TextStyle(
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          onChanged: (value) =>
                                              username = value,
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
                                                ipaddress: ipAddress,
                                                username: username,
                                                password: password));
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
