import 'package:flutter/material.dart';

class HomeCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bgColor = Colors.red;
    var hoverColor = Colors.lightBlue;
    var iconColor = Colors.lightBlueAccent;

    return Scaffold(
      appBar: AppBar(
        title: Text('Work made easy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            _buildCard('Mpesa Received', iconColor, bgColor),
            _buildCard('Heed not the rabble', iconColor, bgColor),
            _buildCard('Sound of screams but the', iconColor, bgColor),
            _buildCard('Who scream', iconColor, bgColor),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String text, Color iconColor, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.payment,
            size: 40,
            color: iconColor,
          ),
          SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
