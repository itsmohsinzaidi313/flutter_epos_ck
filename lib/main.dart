import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pos_app/routes/app_routes.dart';
import 'pages/splash_page.dart';
import './shared/config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Screen orientation set to landscape
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) {
    runApp(App(
      appRoutes: AppRoutes(),
    ));
  });
}

class App extends StatefulWidget {
  final AppRoutes appRoutes;
  App({this.appRoutes});
  @override
  _AppState createState() => _AppState(appRoutes: appRoutes);
}

class _AppState extends State<App> {
  AppRoutes appRoutes;
  _AppState({this.appRoutes});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config.appTitle,
      // debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        primaryColor: Colors.redAccent,
        accentColor: Colors.yellow[800],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      onGenerateRoute: appRoutes.onGeneratedRoute,
    );
  }

  @override
  void dispose() {
    super.dispose();
    appRoutes.dispose();
  }
}
