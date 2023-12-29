import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_cards.dart';
import 'messages_list_view.dart';

// sets the hex colors for the project
class HexColor extends Color {
  static int _getColor(String hex) {
    String formattedHex =  "FF" + hex.toUpperCase().replaceAll("#", "");
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
    const PrimaryColor = Color(0xFFFFFFFF);
    var IconColor = HexColor("#2CA7C9");
    var BgColor = HexColor("#B71918");
    var hvColor = HexColor("#2896B4");
    var Icolor = HexColor("#83E3FD");

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // here the desired height
    child: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(5),
          ),
        ),
        backgroundColor: PrimaryColor,
        title: Image.asset('assets/images/title.png',width:160, height: 40, fit: BoxFit.cover),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.menu,
              color: IconColor,
              size: 30,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      )),
      body: Scaffold(

        body:Container(child:Homecards()),
        // padding: const EdgeInsets.all(10.0),
        // child: _messages.isNotEmpty
        //     ? MessagesListView(
        //         messages: _messages,
        //       )
        //     : Center(
        //         child: Text(
        //           'No messages to show.\n Tap refresh button...',
        //           style: Theme.of(context).textTheme.headline6,
        //           textAlign: TextAlign.center,
        //         ),
        //       ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: _manualRefresh,
        backgroundColor: BgColor,
        foregroundColor: Colors.black,
        hoverColor: hvColor,
        splashColor: Colors.white,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh, color: Icolor,),

      ),
    );
  }
}
