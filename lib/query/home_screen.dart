import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_cards.dart';
import 'hero_banner.dart'; // Import the HeroBanner widget

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
  List<SmsMessage> mpesa_messages = [];
  List<SmsMessage> fuliza_messages = [];
  List<SmsMessage> mshwari_messages = [];
  List<SmsMessage> kcb_mpesa_messages = [];
  List<SmsMessage> bank_messages = [];
  List<SmsMessage> hustler_fund_messages = [];
  List<SmsMessage> reversals_messages = [];
  List<SmsMessage> fuliza_paid_messages = [];
  late Timer _timer;

  static const PrimaryColor = Color(0xFFFFFFFF);
  final BgColor = HexColor("#B71918");

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

  Future<void> _checkForNewMessages() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      final messages = await _query.querySms(
        kinds: [SmsQueryKind.inbox],
      );
      debugPrint('sms inbox messages: ${messages.length}');
      _updateMessageLists(messages);
    } else {
      // Request SMS permission
      await _requestSmsPermission();
    }
  }

  Future<void> _requestSmsPermission() async {
    var status = await Permission.sms.request();
    if (status.isGranted) {
      // Permission granted, reload messages
      _checkForNewMessages();
    } else {
      // Handle the case when permission is denied
      // You can show a dialog or guide the user to settings
    }
  }

  void _updateMessageLists(List<SmsMessage> messages) {
    setState(() {
      // Update mpesa_messages based on criteria
      mpesa_messages = messages
          .where((message) =>
              message.body?.contains('received') == true &&
              message.body?.contains('M-PESA') == true &&
              message.body?.contains('sent') == false &&
              message.body?.contains('reversal') == false &&
              message.body?.contains('BANK') == false)
          .toList();

      // Update fuliza_messages based on criteria
      fuliza_messages = messages
          .where((message) =>
              message.body?.contains('Fuliza') == true &&
              message.body?.contains('partially') == false)
          .toList();

      // Update mshwari_messages based on criteria
      mshwari_messages =
          messages.where((message) => message.body?.contains('M-SHWARI') == true).toList();

      // Update fuliza_paid_messages based on criteria
      fuliza_paid_messages = messages
          .where((message) =>
              message.body?.contains('Fuliza') == true &&
              message.body?.contains('partially') == true)
          .toList();

      // Update reversals_messages based on criteria
      reversals_messages =
          messages.where((message) => message.body?.contains('reversal') == true).toList();

      // Update hustler_fund_messages based on criteria
      hustler_fund_messages =
          messages.where((message) => message.body?.contains('hustler') == true).toList();

      // Update bank_messages based on criteria
      bank_messages = messages
          .where((message) =>
              message.body?.contains('received') == true &&
              message.body?.contains('M-PESA') == true &&
              message.body?.contains('BANK') == true)
          .toList();

      // Update kcb_mpesa_messages based on criteria
      kcb_mpesa_messages = messages
          .where((message) =>
              message.body?.contains('KCB') == true &&
              message.body?.contains('M-PESA') == true &&
              message.body?.contains('received') == true &&
              message.body?.contains('sent') == false)
          .toList();
    });
  }

  void _manualRefresh() {
    _checkForNewMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(5),
          ),
        ),
        backgroundColor: PrimaryColor,
        title: Hero(
          tag: 'hero_banner', // Unique tag for the hero animation
          child: HeroBanner(), // Include the HeroBanner widget here
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.menu,
              size: 30,
            ),
            onPressed: _manualRefresh,
          )
        ],
      ),
      body: HomeCards(
        messages: mpesa_messages,
        fuliza: fuliza_messages,
        mshwari: mshwari_messages,
        kcb_mpesa: kcb_mpesa_messages,
        hustler: hustler_fund_messages,
        reversals: reversals_messages,
        bank: bank_messages,
        fuliza_paid: fuliza_paid_messages,
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: _manualRefresh,
        backgroundColor: BgColor,
        foregroundColor: Colors.white,
        splashColor: Colors.white,
        tooltip: 'Refresh',
        child: Icon(
          Icons.refresh,
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
