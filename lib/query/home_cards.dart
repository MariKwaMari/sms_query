// home_cards.dart
import 'package:flutter/material.dart';
import 'messages_list_view.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

class HexColor extends Color {
  static int _getColor(String hex) {
    String formattedHex = "FF" + hex.toUpperCase().replaceAll("#", "");
    return int.parse(formattedHex, radix: 16);
  }

  HexColor(final String hex) : super(_getColor(hex));
}

class HomeCards extends StatelessWidget {
  final List<SmsMessage> messages;
  final List<SmsMessage> fuliza;
  final List<SmsMessage> mshwari;
  final List<SmsMessage> kcb_mpesa;

  HomeCards({required this.messages, required this.fuliza, required this.mshwari, required this.kcb_mpesa});

  @override
  Widget build(BuildContext context) {
    const PrimaryColor = Color(0xFFFFFFFF);
    var BgColor = HexColor("#B71918");

    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              _buildCard('MPESA Received', Icons.credit_card, BgColor, context),
              _buildCard('MSHWARI Received', Icons.credit_card, BgColor, context),
              _buildCard('FULIZA Received', Icons.credit_card, BgColor, context),
              _buildCard('KCB MPESA Received', Icons.credit_card, BgColor, context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String text, IconData icon, Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessagesListView(messages: messagesForCategory(text), category: text),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<SmsMessage> messagesForCategory(String category) {
    switch (category) {
      case 'MPESA Received':
        return messages;
      case 'MSHWARI Received':
        return mshwari;
      case 'FULIZA Received':
        return fuliza;
      case 'KCB MPESA Received':
        return kcb_mpesa;
      default:
        return [];
    }
  }
}
