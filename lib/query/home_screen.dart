import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_cards.dart';

class HexColor extends Color {
  static int _getColor(String hex) {
    String formattedHex = "FF" + hex.toUpperCase().replaceAll("#", "");
    return int.parse(formattedHex, radix: 16);
  }

  HexColor(final String hex) : super(_getColor(hex));
}

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

    _timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
      _checkForNewMessages();
    });

    _checkForNewMessages();
  }

  @override
  void dispose() {
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

      final filteredMessages = messages.where((message) =>
          message.body?.contains('received') == true &&
          message.body?.contains('M-PESA') == true);

      setState(() => _messages = filteredMessages.toList());
    }
  }

  void _manualRefresh() {
    _checkForNewMessages();
  }

  @override
  Widget build(BuildContext context) {
    const PrimaryColor = Color(0xFFFFFFFF);
    var BgColor = HexColor("#B71918");

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(5),
            ),
          ),
          backgroundColor: PrimaryColor,
          title: Image.asset(
            'assets/images/title.png',
            width: 160,
            height: 40,
            fit: BoxFit.cover,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.menu,
                size: 30,
              ),
              onPressed: () {
                // regresh button, not working, should be placed inside where we view messeges
              },
            )
          ],
        ),
      ),
      body: HomeCards(messages: _messages),
      floatingActionButton: FloatingActionButton.small(
        onPressed: _manualRefresh,
        backgroundColor: BgColor,
        foregroundColor: Colors.black,
        splashColor: Colors.white,
        tooltip: 'Refresh',
        child: Icon(
          Icons.refresh,
        ),
      ),
    );
  }
}