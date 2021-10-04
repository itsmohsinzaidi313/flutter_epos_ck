import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';
import 'package:pos_app/models/objects/server_response.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';

class GeneralRepo {
  static GeneralRepo repo = GeneralRepo._internal();
  GeneralRepo._internal();
  // Future<bool> isServerOnline() async {
  //   final response = ServerResponse(
  //       response: await get(Uri.parse(await Config.checkServerApi)).timeout(
  //           Duration(seconds: Config.SERVER_TIMEOUT),
  //           onTimeout: () => null));
  //   return response.status;
  // }

  static Response _sessionsResponse;
  Future<Response> getSessions() async {
    try {
      if (_sessionsResponse == null ||
          _sessionsResponse.statusCode != HttpStatus.ok) {
        _sessionsResponse = await get(await Config.getSessions).timeout(
            Duration(seconds: Config.SERVER_TIMEOUT),
            onTimeout: () => Lib.timeOutResponse);
      }
      return _sessionsResponse;
    } catch (e) {
      return Lib.httpErrorResponseHandler(error: e, caller: 'GeneralRepo');
    }
  }

  static Response _venueResponse;
  Future<Response> getVenues() async {
    try {
      if (_venueResponse == null ||
          _venueResponse.statusCode != HttpStatus.ok) {
        _venueResponse = await get(await Config.getVenues).timeout(
            Duration(seconds: Config.SERVER_TIMEOUT),
            onTimeout: () => Lib.timeOutResponse);
      }
      return _venueResponse;
    } catch (e) {
      return Lib.httpErrorResponseHandler(error: e, caller: 'GeneralRepo');
    }
  }
}
