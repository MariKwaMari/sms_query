import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColor(String hex) {
    String formattedHex = "FF" + hex.toUpperCase().replaceAll("#", "");
    return int.parse(formattedHex, radix: 16);
  }

  HexColor(final String hex) : super(_getColor(hex));
}

class HomeCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define colors outside the Scaffold
    const PrimaryColor = Color(0xFFFFFFFF);
    var IconColor = HexColor("#2CA7C9");
    var BgColor = HexColor("#B71918");
    var hvColor = HexColor("#2896B4");
    var Icolor = HexColor("#83E3FD");

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
              _buildCard('Mpesa Received', Icons.credit_card, BgColor),
              _buildCard('Heed not the rabble', Icons.credit_card, BgColor ?? BgColor),
              _buildCard('Sound of screams but the', Icons.credit_card, BgColor ?? BgColor),
              _buildCard('Who scream', Icons.credit_card, BgColor ?? BgColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String text, IconData icon, Color color) {
    return Container(
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
    );
  }
}
