class CustomerFeedback {
  String name;
  String contact;
  String orderKey;
  String remarks;
  List<FeedbackQuestions> questions = [];
  List<FeedbackItems> items = [];

  CustomerFeedback(
      {this.name,
      this.contact,
      this.orderKey,
      this.remarks,
      this.questions,
      this.items});

  Map<String, dynamic> toMap() => {
        'Name': name,
        'Contact': contact,
        'OrderKey': orderKey,
        'Remarks': remarks,
        'Questions': questions
            .map((e) => {'Question': e.question, 'Answer': e.answer})
            .toList(),
        'Items': items
            .map((e) => {
                  'ItemName': e.itemName,
                  'Rating': e.rating,
                })
            .toList(),
      };
}

class FeedbackQuestions {
  String question;
  String answer;
  FeedbackQuestions({this.question, this.answer});
}

class FeedbackItems {
  String itemName;
  int rating;
  FeedbackItems({this.itemName, this.rating});
}
