import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:pos_app/models/feedback.dart';
import 'package:pos_app/models/server_response.dart';
import 'package:pos_app/shared/config.dart';

class FeedbackRepo {
  static FeedbackRepo repo = FeedbackRepo._internal();
  FeedbackRepo._internal();
  List<String> getFeedbackQuestions() => [
        'How would you rate the taste of your meal?',
        'How was the temperature of the food?',
        'Please rate your visit on value for the money?',
        'Cleanliness?',
      ];
  Future<ServerResponse> uploadFeedback(CustomerFeedback feedback) async => ServerResponse(
        response: await post(Uri.parse(await Config.postFeedbackApi),
                headers: {'Content-type': 'application/json'},
                body: jsonEncode(feedback.toMap()))
            .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
                onTimeout: () => null));
}
