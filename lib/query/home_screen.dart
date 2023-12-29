import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'messages_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Start a timer to check for new messages every 60 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
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

  void _checkForNewMessages() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      final messages = await _query.querySms(
        kinds: [SmsQueryKind.inbox],
      );

      debugPrint('sms inbox messages: ${messages.length}');

      // Filter messages containing "received" and "M-PESA"
      final filteredMessages = messages.where((message) =>
          message.body?.contains('received') == true &&
          message.body?.contains('M-PESA') == true);

      setState(() => _messages = filteredMessages.toList());
    }
    // Handle the case where permission is not granted
  }

  // Function to handle manual refresh
  void _manualRefresh() {
    _checkForNewMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesaway SMS Retriever'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: _messages.isNotEmpty
            ? MessagesListView(
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
      floatingActionButton: FloatingActionButton(
        onPressed: _manualRefresh,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
