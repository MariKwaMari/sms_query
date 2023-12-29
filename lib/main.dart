import 'dart:async';
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

// the class helps in defining hex colors directly
class HexColor extends Color {
  static int _getColor(String hex) {
    String formattedHex =  "FF" + hex.toUpperCase().replaceAll("#", "");
    return int.parse(formattedHex, radix: 16);
  }
  HexColor(final String hex) : super(_getColor(hex));
}

class _MyAppState extends State<MyApp> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Start a timer to check for new messages every 60 seconds
    _timer = Timer.periodic(Duration(seconds: 60), (Timer t) {
      _checkForNewMessages();
    });

    // Fetch initial messages
    _checkForNewMessages();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  bool isMpesaMessage(String? body) {
    // Customize this function based on the structure of M-Pesa messages
    return body?.contains('Confirmed') == true && body?.contains('received') == true && body?.contains('M-PESA') == true;
  }

  Future<void> _checkForNewMessages() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      final messages = await _query.querySms(
        kinds: [
          SmsQueryKind.inbox,
        ],
        count: 10,
      );

      debugPrint('sms inbox messages: ${messages.length}');

      // Filter only M-Pesa messages
      final mpesaMessages = messages.where((message) => isMpesaMessage(message.body)).toList();

      setState(() => _messages = mpesaMessages);
    }
    // Handle the case where permission is not granted
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFFFFFFF);
    var iconColor = HexColor("#2CA7C9");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter SMS Inbox App',
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Image.asset('assets/images/title.png', width: 160,
            height:40,
            fit: BoxFit.cover,),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.message,
                color: iconColor,
                size: 29,
              ),
              onPressed: () {
                // do something
              },
            )
          ],),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: _messages.isNotEmpty
              ? _MessagesListView(
                  messages: _messages,
                )
              : Center(
                  child: Text(
                    'No messages to show.\n Tap refresh button...',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
        // Remove the FloatingActionButton since we are checking for messages periodically
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
        var phone_no = '0${message.body?.split('0')[1]?.split("on")[0]?.trim()}';
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
