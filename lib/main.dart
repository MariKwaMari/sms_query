import 'package:flutter/material.dart';
import 'package:sms_advanced/sms_advanced.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListTile Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SmsQuery query = new SmsQuery();
  final List<String> items = [
    'MPESA Message 1',
    'MPESA Message 2',
    'MPESA Message 3',
    'MPESA Message 4',
    'MPESA Message 5',
  ];

  // Track the tapped item index and its corresponding color
  int tappedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        title: Text("PESAWAY SMS QUERY"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: <Color>[Colors.blue, Colors.blue]),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(
              Icons.circle,
              color: tappedIndex == index ? Colors.blue : null,
            ),
            title: Text(items[index]),
            subtitle: Text('Subtitle ${index + 1}'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Update the tapped item index
              setState(() {
                tappedIndex = index;
              });
            },
          );
        },
      ),
    );
  }
}

