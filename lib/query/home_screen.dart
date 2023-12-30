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
  List<SmsMessage> mpesa_messages = [];
  List<SmsMessage> fuliza_messages = [];
  List<SmsMessage> mshwari_messages = [];
  List<SmsMessage> kcb_mpesa_messages = [];
  List<SmsMessage> bank_messages = [];
  List<SmsMessage> hustler_fund_messages = [];
  List<SmsMessage> reversals_messages = [];
  List<SmsMessage> fuliza_paid_messages = [];

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
      final MpesaMessages = messages.where((message) =>
          message.body?.contains('received') == true &&
          message.body?.contains('M-PESA') == true &&
          message.body?.contains('sent') == false &&
          message.body?.contains('reversal') == false &&
          message.body?.contains('BANK') == false);
      setState(() => mpesa_messages = MpesaMessages.toList());
      final FulizaMessages = messages.where((message) =>
          message.body?.contains('Fuliza') == true &&
          message.body?.contains('M-PESA') == true &&
          message.body?.contains('partially') == false);
      setState(() => fuliza_messages = FulizaMessages.toList());
      final MshwariMessages = messages.where((message) =>
          message.body?.contains('M-SHWARI') == true);
      setState(() => mshwari_messages = MshwariMessages.toList());
      final FulizaPaidMessages = messages.where((message) =>
            message.body?.contains('Fuliza') == true &&
            message.body?.contains('partially') == true);
       setState(() => fuliza_paid_messages = FulizaPaidMessages.toList());
       final ReversalsMessages = messages.where((message) =>
            message.body?.contains('reversal') == true);
       setState(() => reversals_messages = ReversalsMessages.toList());
       final HustlerMessages = messages.where((message) =>
            message.body?.contains('hustler') == true);
       setState(() => hustler_fund_messages = HustlerMessages.toList());
       final BankMessages = messages.where((message) =>
         message.body?.contains('received') == true &&
         message.body?.contains('M-PESA') == true &&
         message.body?.contains('BANK') == true);
       setState(() => bank_messages = BankMessages.toList());
       final KcbMpesaMessages = messages.where((message) =>
          message.body?.contains('KCB') == true &&
          message.body?.contains('M-PESA') == true &&
          message.body?.contains('received') == true &&
          message.body?.contains('sent') == false);
       setState(() => kcb_mpesa_messages = KcbMpesaMessages.toList());
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
              onPressed: _manualRefresh,
            )
          ],
        ),
      ),
      body: HomeCards(
          messages: mpesa_messages, fuliza: fuliza_messages, mshwari: mshwari_messages,
           kcb_mpesa: kcb_mpesa_messages, hustler: hustler_fund_messages,
           reversals: reversals_messages, bank: bank_messages, fuliza_paid: fuliza_paid_messages,
           ),
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
