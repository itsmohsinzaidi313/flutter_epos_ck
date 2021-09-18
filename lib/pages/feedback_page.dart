import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pos_app/models/objects/customer_order.dart';
import 'package:pos_app/models/objects/feedback.dart';
import 'package:pos_app/models/objects/server_response.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/shared/config.dart';
import 'package:pos_app/repositories/feedback_repository.dart';

class FeedbackScreen extends StatelessWidget {
  final Order order;
  final List<String> ratingAnswer = [
    'BAD',
    'NEEDS IMPROVEMENT',
    'SATISFIED',
    'GOOD',
    'EXCELLENT'
  ];
  FeedbackScreen({this.order});

  List<Container> feedbackItemsWidgets;
  List<Container> feedbackQuestionsWidgets;
  TextEditingController remarksController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    if (feedbackItemsWidgets == null)
      feedbackItemsWidgets = order.items
          .map(
            (e) => Container(
              width: Config.getDeviceWidth(context) * 0.3,
              height: 40,
              child: FeedbackTile(
                text: e.name,
                fontSize: 18,
                alignment: MainAxisAlignment.center,
              ),
            ),
          )
          .toList();
    if (feedbackQuestionsWidgets == null)
      feedbackQuestionsWidgets = FeedbackRepo.repo
          .getFeedbackQuestions()
          .map(
            (e) => Container(
              height: Config.getDeviceHeight(context) * 0.2,
              child: FeedbackTile(
                text: e,
                fontSize: 22,
                alignment: MainAxisAlignment.end,
              ),
            ),
          )
          .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Feedback'),
        centerTitle: true,
        actions: [
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.amber),
              ),
              child: Row(
                children: [
                  Text(
                    'Done',
                    style: TextStyle(color: Colors.red),
                  ),
                  Icon(
                    Icons.check,
                    color: Colors.red,
                  ),
                ],
              ),
              onPressed: () async {
                final feedback = CustomerFeedback();
                feedback.orderKey = order.id;
                feedback.name = order.customer;
                feedback.contact = order.contact;
                feedback.remarks = remarksController.text;
                feedback.questions = [];
                feedback.items = [];

                feedbackQuestionsWidgets.forEach((e) {
                  int rating = 0;
                  (e.child as FeedbackTile)
                      .selectedButton
                      .forEach((element) => element ? rating++ : rating);

                  feedback.questions.add(FeedbackQuestions(
                    question: (e.child as FeedbackTile).text,
                    answer: ratingAnswer[rating - 1],
                  ));
                });

                feedbackItemsWidgets.forEach((e) {
                  int rating = 0;
                  (e.child as FeedbackTile)
                      .selectedButton
                      .forEach((element) => element ? rating++ : rating);

                  feedback.items.add(FeedbackItems(
                    itemName: order.items
                        .where((element) =>
                            element.name == (e.child as FeedbackTile).text)
                        .first
                        .name,
                    rating: rating,
                  ));
                });
                try {
                  log('${jsonEncode(feedback.toMap())}');
                  ServerResponse response =
                      await FeedbackRepo.repo.uploadFeedback(feedback);
                  if (response.status) {
                    AppTheme.snackbar(context, 'Thankyou for your time.');
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/menu', (route) => false);
                  } else {
                    AppTheme.snackbar(context,
                        'Your feedback could not be saved at the moment. Please check WiFi connectivity or contact I.T. Support.\n${response.data.toString()}');
                  }
                } catch (e) {
                  log('Error', error: e);
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/3.jpg',
                ),
                fit: BoxFit.fill),
          ),
          child: Column(
            children: [
              feedbackTitle('Items'),
              Container(
                height: Config.getDeviceHeight(context) * 0.2,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: feedbackItemsWidgets,
                ),
              ),
              feedbackTitle('Remarks'),
              Opacity(
                opacity: 0.9,
                child: Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(Icons.comment),
                          title: TextField(
                            controller: remarksController,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              feedbackTitle('Questions'),
              Column(
                children: feedbackQuestionsWidgets,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget feedbackTitle(String title) => Center(
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.red,
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
        ),
      );
}

class FeedbackTile extends StatefulWidget {
  final String text;
  final double fontSize;
  final MainAxisAlignment alignment;
  final List<bool> selectedButton = [true, false, false, false, false];
  FeedbackTile({this.text, this.fontSize, this.alignment});
  @override
  _FeedbackTileState createState() => _FeedbackTileState();
}

class _FeedbackTileState extends State<FeedbackTile> {
  List<IconData> icons = [
    Icons.looks_one,
    Icons.looks_two,
    Icons.looks_3,
    Icons.looks_4,
    Icons.looks_5,
  ];
  Color color = Colors.yellow[800]; // Colors.red;
  Color selectedColor = Colors.yellow[800];
  double iconSize = 40;
  IconData selectedStar = Icons.star_rate_rounded;
  IconData star = Icons.star_outline_rounded;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.9,
      child: Card(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.text,
                    style: TextStyle(fontSize: widget.fontSize),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: widget.alignment,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                    icon: Icon(
                      widget.selectedButton[0] ? selectedStar : star,
                      color: color,
                      size: iconSize,
                    ),
                    onPressed: () {
                      markButtonSelected(0);
                    }),
                IconButton(
                    icon: Icon(
                      widget.selectedButton[1] ? selectedStar : star,
                      color: color,
                      size: iconSize,
                    ),
                    onPressed: () {
                      markButtonSelected(1);
                    }),
                IconButton(
                    icon: Icon(
                      widget.selectedButton[2] ? selectedStar : star,
                      color: color,
                      size: iconSize,
                    ),
                    onPressed: () {
                      markButtonSelected(2);
                    }),
                IconButton(
                    icon: Icon(
                      widget.selectedButton[3] ? selectedStar : star,
                      color: color,
                      size: iconSize,
                    ),
                    onPressed: () {
                      markButtonSelected(3);
                    }),
                IconButton(
                    icon: Icon(
                      widget.selectedButton[4] ? selectedStar : star,
                      color: color,
                      size: iconSize,
                    ),
                    onPressed: () {
                      markButtonSelected(4);
                    }),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void markButtonSelected(int index) {
    for (var i = 0; i < widget.selectedButton.length; i++) {
      if (i <= index) {
        setState(() => widget.selectedButton[i] = true);
      } else {
        widget.selectedButton[i] = false;
      }
    }
  }
}
