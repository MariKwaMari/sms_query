import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_cards.dart';
import '/components/hero_banner.dart'; // Import the HeroBanner widget

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
//       sender = messages.where((message) => debugPrint(message.sender)
      mpesa_messages = messages
          .where((message) =>
              message.body?.contains("kindly forward") == false &&
              message.body?.contains("received") == true &&
              message.body?.contains("sent") == false &&
              message.body?.contains('M-PESA') == true &&
              message.body?.contains('BANK') == false)
          .toList();

      // Update fuliza_messages based on criteria
      fuliza_messages = messages
          .where((message) =>
             
              message.body?.contains("Fuliza M-PESA amount is") == true &&
               message.body?.contains('Failed') == false &&
              message.body?.contains('partially') == false)
          .toList();

      // Update mshwari_messages based on criteria
      mshwari_messages =
        
          messages.where((message) => message.body?.contains('M-SHWARI') == true).toList();

      // Update fuliza_paid_messages based on criteria
      fuliza_paid_messages = messages
          .where((message) =>
               
              message.body?.contains("has been used to partially") == true &&
              message.body?.contains('Fuliza') == true)
          .toList();

      // Update reversals_messages based on criteria
      reversals_messages =
          messages.where((message) =>  message.body?.contains('reversal') == true).toList();

      // Update hustler_fund_messages based on criteria
      hustler_fund_messages =
          messages.where((message) =>  message.body?.contains('hustler') == true).toList();

      // Update bank_messages based on criteria
      bank_messages = messages
          .where((message) =>
            
              message.body?.contains("You have received") == true &&
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
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right:10.0),
              child: Icon(Icons.message, size: 30, color: Color.fromRGBO(183, 25, 24, 1)),
            ),
            GradientText(
              'Mpesa SMS Query',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(183, 25, 24, 1),
                Color.fromRGBO(40, 150, 180, 1)
              ]),
            ),

          ],
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

// styles the appbar text
class GradientText extends StatelessWidget {
  const GradientText(
      this.text, {
        required this.gradient,
        this.style,
      });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
