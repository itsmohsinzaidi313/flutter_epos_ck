import 'package:flutter/foundation.dart';
import 'package:pos_app/models/objects/server_response.dart';
import 'package:pos_app/repositories/general_repository.dart';

class Installation {

  Future<bool> auto()
  Future<ServerResponse> fetchData() async => await GeneralRepo.repo.getInstallationData();

  Future<void> import() async {
    final serverResponse = await fetchData();
    if (serverResponse.status) {

    } else {
      throw Exception(serverResponse.message);
    }
  }

  bool validResponse(ServerResponse response) {
    return true;
  }
}
