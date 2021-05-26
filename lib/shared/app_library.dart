import 'package:flutter/services.dart';

class Lib {
  static forcePortraitView() async => await SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown
                  ]); 

                  static forceLandscapeView() async => await SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight
                  ]); 
}
