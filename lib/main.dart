import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];

  @override
  void initState() {
    super.initState();
  }

  bool isMpesaMessage(String? body) {
    // Customize this function based on the structure of M-Pesa messages
    return body?.contains('Confirmed') == true && body?.contains('received') == true && body?.contains('M-PESA') == true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SMS Inbox App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pesaway SMS Retriever'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: _messages.isNotEmpty
              ? _MessagesListView(
                  messages: _messages,
                )
              : Center(
                  child: Text(
                    'No messages to show.\n Tap refresh button...',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var permission = await Permission.sms.status;
            if (permission.isGranted) {
              final messages = await _query.querySms(
                kinds: [
                  SmsQueryKind.inbox,
//                   SmsQueryKind.sent,
                ],
                count: 10,
              );

              debugPrint('sms inbox messages: ${messages.length}');

              // Filter only M-Pesa messages
              final mpesaMessages = messages.where((message) => isMpesaMessage(message.body)).toList();

              setState(() => _messages = mpesaMessages);
            } else {
              await Permission.sms.request();
            }
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}

class _MessagesListView extends StatelessWidget {
  const _MessagesListView({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final List<SmsMessage> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int i) {
        var message = messages[i];
               debugPrint('${message.body}');
               var amount = message.body?.split('received')[1]?.split('from')[0]?.trim();
               var receipt_no = message.body?.split('Confirmed')[0]?.trim();
               var sender = message.body?.split('from')[1]?.split("0")[0]?.trim();
               var phone_no = message.body?.split('0')[1]?.split("on")[0]?.trim();
               var date = message.body?.split('on')[1]?.split("at")[0]?.trim();
               var time = message.body?.split('at')[1]?.split("New")[0]?.trim();

               var data = {
                 'amount': amount,
                 'receipt_no': receipt_no,
                 'sender': sender,
                 'phone_no': phone_no,
                 'date': date,
                 'time': time
               };

               debugPrint(data.toString());
        return ListTile(
          title: Text('${message.sender} [${message.date}]'),
          subtitle: Text('${message.body}'),
        );
      },
    );
  }
}
