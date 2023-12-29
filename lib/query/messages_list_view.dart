import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

class MessagesListView extends StatelessWidget {
  final List<SmsMessage> messages;

  const MessagesListView({
    Key? key,
    required this.messages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int i) {
        var message = messages[i];
        var amount = "";
        var receiptNo = "";
        var sender = "";
        var phoneNo = "";
        var date = "";
        var time = "";

        if (message.body != null) {
          var messageParts = message.body!.split('received');
          if (messageParts.length >= 2) {
            amount = messageParts[1].split('from')[0].trim();
          }

          var receiptParts = message.body!.split('Confirmed');
          if (receiptParts.length >= 1) {
            receiptNo = receiptParts[0].trim();
          }

          var senderParts = message.body!.split('from');
          if (senderParts.length >= 2) {
            sender = senderParts[1].split("0")[0].trim();
          }

          var phoneNoParts = message.body!.split('0');
          if (phoneNoParts.length >= 2) {
            phoneNo = '0${phoneNoParts[1].split(" on ")[0].trim()}';
          }

          var dateParts = message.body!.split(' on ');
          if (dateParts.length >= 2) {
            date = dateParts[1].split(" at ")[0].trim();
          }

          var timeParts = message.body!.split(' at ');
          if (timeParts.length >= 2) {
            time = timeParts[1].split("New")[0].trim();
          }
        }

        return ListTile(
          title: Text('${message.sender} [$date - $time] '),
          subtitle: Text('$amount | $receiptNo | $sender | $phoneNo | $time'),
        );
      },
    );
  }
}
