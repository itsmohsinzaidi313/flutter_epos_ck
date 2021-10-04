import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:pos_app/models/objects/member.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';

class MembersRepo {
  static MembersRepo repo = MembersRepo._internal();

  MembersRepo._internal();
  Future<List<Member>> searchingMember({String phrase}) async {
    List<Member> list;
    try {
      final response =
          await get('${await Config.searchMembersApi}&phrase=$phrase').timeout(
        Duration(seconds: Config.SERVER_TIMEOUT),
        onTimeout: () => Lib.timeOutResponse,
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        list = (json as List<dynamic>).map((e) => Member.fromJson(e)).toList();
      } else if (response.statusCode == HttpStatus.notFound) {
        list = [];
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      log("Error", error: e, name: "MembersRepo");
      Lib.httpErrorResponseHandler(error: e);
    }
    return list;
  }
}
