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

