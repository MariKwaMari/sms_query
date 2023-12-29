import 'package:flutter/material.dart';

import 'home_screen.dart';

class Homecards extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var IconColor = HexColor("#2CA7C9");
    var BgColor = HexColor("#B71918");
    var hvColor = HexColor("#2896B4");
    var Icolor = HexColor("#83E3FD");
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
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: hvColor,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(8),
                  // color: Colors.green[100],
                  child: const Text("Mpesa Received"),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.green[200],
                  child: const Text('Heed not the rabble'),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.green[300],
                  child: const Text('Sound of screams but the'),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.green[400],
                  child: const Text('Who scream'),
                ),


              ],
            ),
          ),
        ],
      ),
    );
  }
  
}
  