import 'package:flutter/material.dart';
import 'package:sms_advanced/sms_advanced.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<SmsMessage> mpesaMessages = [];

  @override
  void initState() {
    super.initState();
    _loadMpesaMessages();
  }

  Future<void> _loadMpesaMessages() async {
    // Query the SMS inbox
    List<SmsMessage> allMessages = await SmsQuery().querySms(
      kinds: [SmsQueryKind.Inbox],
    );

    // Filter M-Pesa messages based on keyword or pattern
    List<SmsMessage> mpesaMessages = allMessages
        .where((message) =>
            message.body?.toLowerCase().contains('mpesa') ?? false)
        .toList();

    setState(() {
      this.mpesaMessages = mpesaMessages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('M-Pesa Messages'),
      ),
      body: ListView.builder(
        itemCount: mpesaMessages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(mpesaMessages[index].address ?? ''),
            subtitle: Text(mpesaMessages[index].body ?? ''),
          );
        },
      ),
    );
  }
}
