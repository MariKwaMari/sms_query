import 'package:flutter/material.dart';

class HomeCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                _buildCard('Mpesa Received', Icons.credit_card, Colors.green),
                _buildCard('Heed not the rabble', Icons.mic, Colors.green[200] ?? Colors.green),
                _buildCard('Sound of screams but the', Icons.mic, Colors.green[300] ?? Colors.green),
                _buildCard('Who scream', Icons.mic, Colors.green[400] ?? Colors.green),
              ],
            ),
          ),
        ],
      ),
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

