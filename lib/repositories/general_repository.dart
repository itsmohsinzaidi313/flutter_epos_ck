

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
}
