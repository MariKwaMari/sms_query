import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

class MessagesListView extends StatelessWidget {
  final List<SmsMessage> messages;
  final String category;

  MessagesListView({required this.messages, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
         title: Text(category),
        centerTitle: true, // Center align the title
        backgroundColor: Colors.white, // Set the background color
        elevation: 0, // Remove the app bar shadow
      ),
      body: Material(
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int i) {
            var message = messages[i];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: buildMessageTile(message),
            );
          },
        ),
      ),
    );
  }

  Widget buildMessageTile(SmsMessage message) {
    var amount = "0.00";
    var receiptNo = "";
    var sender = "";
    var phoneNo = "";
    var date = "";
    var due_date = "";
    var time = "";
    var balance = "";
    var amount_paid = "";
    var available_limit = "";
    var outstanding = "";

    if (message.body?.contains('Fuliza') == true) {
        if (message.body?.contains('partially') == true) {
             var messageParts = message.body!.split('balance is');
             if (messageParts.length >= 2) {
               balance = messageParts[1].split('.')[0].trim();
             }

             var receiptParts = message.body!.split('Confirmed');
             if (receiptParts.length >= 1) {
               receiptNo = receiptParts[0].trim();
             }

             var availableParts = message.body!.split('limit is');
             if (availableParts.length >= 2) {
               available_limit = availableParts[1].split(".")[0].trim();
             }

             var paidParts = message.body!.split('Confirmed.');
             if (paidParts.length >= 2) {
               if (message.body?.contains('partially') == true) {
                 amount_paid = paidParts[1].split('from')[0].trim();
               }
             }
             return ListTile(
               title: Text('${message.sender} [due - $due_date] '),
               subtitle: Text('[receipt no : $receiptNo | amount paid : $amount_paid | available_limit  : $available_limit | balance : $balance]'),
             );
       } else {
             var messageParts = message.body!.split('M-PESA amount is');
             if (messageParts.length >= 2) {
               amount = messageParts[1].split('.')[0].trim();
             }
             var receiptParts = message.body!.split('Confirmed');
             if (receiptParts.length >= 1) {
               receiptNo = receiptParts[0].trim();
             }

             var dateParts = message.body!.split(' on ');
             if (dateParts.length >= 2) {
               due_date = dateParts[1].split(".")[0].trim();
             }

             var outstandingParts = message.body!.split('outstanding amount is');
             if (outstandingParts.length >= 2) {
                 outstanding = outstandingParts[1].split('due')[0].trim();
             }
             return ListTile(
                   title: Text('${message.sender} [due - $due_date] '),
                   subtitle: Text('[fulizad amount : $amount | $receiptNo | due date : $due_date '),
                 );
       }

    } else {
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
            time = timeParts[1].split(" New ")[0].trim();
          }

          var balanceParts = message.body!.split('balance is');
          if (balanceParts.length >= 2) {
            balance = balanceParts[1].split(".")[0].trim();
          }
        return ListTile(
          title: Text('${message.sender} [$date - $time] '),
          subtitle: Text('$amount | $receiptNo | $sender | $phoneNo | $time | balance is $balance'),
        );
    }
  }
}

