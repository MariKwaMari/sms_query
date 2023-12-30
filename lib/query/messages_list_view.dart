// messages_list_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import '/components/message_tile.dart';

class MessagesListView extends StatelessWidget {
  final List<SmsMessage> messages;
  final String category;

  MessagesListView({required this.messages, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Material(
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int i) {
            if (i >= 0 && i < messages.length) {
              var message = messages[i];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: MessageTile(message: message),
              );
            } else {
              // Handle the case where the index is out of bounds
              return Container();
            }
          },
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
//
// class MessagesListView extends StatelessWidget {
//   final List<SmsMessage> messages;
//   final String category;
//
//   MessagesListView({required this.messages, required this.category});
//
// 	  @override
// 	  Widget build(BuildContext context) {
// 	    return Scaffold(
// 	      appBar: AppBar(
// 	        title: Text(category),
// 	        centerTitle: true,
// 	        backgroundColor: Colors.white,
// 	        elevation: 0,
// 	      ),
// 	      body: Material(
// 	        child: ListView.builder(
// 	          itemCount: messages.length,
// 	          itemBuilder: (BuildContext context, int i) {
// 	            if (i >= 0 && i < messages.length) {
// 	              var message = messages[i];
// 	              return Card(
// 	                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// 	                child: buildMessageTile(message),
// 	              );
// 	            } else {
// 	              // Handle the case where the index is out of bounds
// 	              return Container(); // You can return an empty container or a message indicating no messages.
// 	            }
// 	          },
// 	        ),
// 	      ),
// 	    );
// 	  }
//
//   Widget buildMessageTile(SmsMessage message) {
//     var amount = "0.00";
//     var receiptNo = "";
//     var sender = "";
//     var phoneNo = "";
//     var date = "";
//     var time = "";
//     var balance = "";
//
//     void extractCommonData(List<String> parts) {
//       if (parts.length >= 2) {
//         receiptNo = parts[0].trim();
//         amount = parts[1].split('.')[0].trim();
//       }
//     }
//
//     if (message.body?.contains('Fuliza') == true) {
//       var parts = message.body!.split('Confirmed');
//       if (parts.length >= 1) {
//         extractCommonData(parts);
//         var dateParts = message.body!.split(' on ');
//         if (dateParts.length >= 2) {
//           date = dateParts[1].split(".")[0].trim();
//         }
//         return ListTile(
//           title: Text('${message.sender} [due - $date] '),
//           subtitle: Text('[fulizad amount : $amount | $receiptNo | due date : $date]'),
//         );
//       } else if (message.body?.contains('partially') == true) {
//         var parts = message.body!.split('balance is');
//         if (parts.length >= 2) {
//           balance = parts[1].split('.')[0].trim();
//         }
//         var receiptParts = message.body!.split('Confirmed');
//         if (receiptParts.length >= 1) {
//           receiptNo = receiptParts[0].trim();
//         }
//         var availableParts = message.body!.split('limit is');
//         if (availableParts.length >= 2) {
//           var availableLimitParts = availableParts[1].split(".");
//           if (availableLimitParts.length >= 1) {
//             amount = availableLimitParts[0].trim();
//           }
//         }
//         var paidParts = message.body!.split('Confirmed.');
//         if (paidParts.length >= 2) {
//           amount = paidParts[1].split('from')[0].trim();
//         }
//         return ListTile(
//           title: Text('${message.sender} [due - $date] '),
//           subtitle: Text(
//               '[receipt no : $receiptNo | amount paid : $amount | available_limit  : $amount | balance : $balance]'),
//         );
//       }
//     } else {
//       var parts = message.body!.split('Confirmed');
//       if (parts.length >= 1) {
//         extractCommonData(parts);
//         var senderParts = message.body!.split('from');
//         if (senderParts.length >= 2) {
//           sender = senderParts[1].split("0")[0].trim();
//         }
//         var phoneNoParts = message.body!.split('0');
//         if (phoneNoParts.length >= 2) {
//           phoneNo = '0${phoneNoParts[1].split(" on ")[0].trim()}';
//         }
//         var dateParts = message.body!.split(' on ');
//         if (dateParts.length >= 2) {
//           date = dateParts[1].split(" at ")[0].trim();
//         }
//         var timeParts = message.body!.split(' at ');
//         if (timeParts.length >= 2) {
//           time = timeParts[1].split(" New ")[0].trim();
//         }
//         var balanceParts = message.body!.split('balance is');
//         if (balanceParts.length >= 2) {
//           balance = balanceParts[1].split(".")[0].trim();
//         }
//         return ListTile(
//           title: Text('${message.sender} [$date - $time] '),
//           subtitle: Text('$amount | $receiptNo | $sender | $phoneNo | $time | balance is $balance'),
//         );
//       }
//     }
//
//     // Default case (if none of the conditions match)
//     return ListTile(
//       title: Text('${message.sender} [Unknown format]'),
//       subtitle: Text('Message body: ${message.body}'),
//     );
//   }
// }
