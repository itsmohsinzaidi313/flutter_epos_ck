import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/pages/widgets/device_key_prompt.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/shared/web_data_import.dart';
import 'package:sqflite/sqflite.dart';
import '../shared/config.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final globalScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _launchPage(context);
  }

  void _launchPage(BuildContext context) async {
    Config.deviceKey = Future.value('');
    // FOR TESTING ONLY
    await deleteDatabase(Config.DATABASE_NAME);
    final bloc = context.read<VerboseBloc>();
    final deviceKey = await Config.deviceKey;

    if (deviceKey == '') {
      final input = await deviceKeyPrompt(context);
      if (input != '') {
        Config.deviceKey = Future.value(input);
        final db = await LocalDatabase.database
            .initialize(verboseBloc: context.read<VerboseBloc>());
        final import = ImportData(database: db, bloc: bloc);
        final importSuccessful = await import.import();
        if (!importSuccessful) {
          await AppTheme.showAlertDialogOK(context,
              title: 'Error',
              message:
                  'An error has occured while installation.\nKindly go through the following check list:-\n - Tally your device key\n - Check your internet connection\n - Clear app storage from settings and retry\n - Uninstall the app, reinstall and retry\nIf error continues please contact I.T.Support/Sorry for inconvenience.',
              onOK: () => exit(0),
              barrierDismissible: false);
        }
      } else {
        exit(0);
      }
    }
    Timer(Duration(seconds: Config.SPLASH_DURATION),
        () => Navigator.of(context).pushNamed('/login'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerboseBloc, VerboseState>(
      listener: (context, state) {},
      child: Scaffold(
        backgroundColor: Colors.yellow[600],
        key: globalScaffoldKey,
        body: Container(
          height: Config.getDeviceHeight(context),
          width: Config.getDeviceWidth(context),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomCenter,
                  height: Config.getDeviceHeight(context) * 0.3,
                  width: Config.getDeviceWidth(context) * 0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/splash_pic.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Text(
                  Config.appTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.red,
                    letterSpacing: 3.0,
                  ),
                ),
                BlocBuilder<VerboseBloc, VerboseState>(
                  builder: (context, state) {
                    return Center(
                      child: RichText(
                        text: TextSpan(children: [
                          // TextSpan(
                          //     text: state.title,
                          //     style: TextStyle(color: Colors.red)),
                          //     TextSpan(text: '\n'),
                          TextSpan(
                              text: state.message,
                              style: TextStyle(color: Colors.red)),
                        ]),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
