import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:math';

import 'package:flutter_application_2/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Quote App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> quotes = [];
  String currentQuote = "";
  final databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    fetchQuotesFromFirebase();
  }

  void fetchQuotesFromFirebase() async {
    // Replace 'your_quotes_node' with the node in your Realtime Database where quotes are stored
    DatabaseEvent event = await databaseReference.child('Prompts').once();
    DataSnapshot snapshot = event.snapshot;
    setState(() {
      List<String> values = (snapshot.value as List<dynamic>)
      .where((element) => element is String)
      .cast<String>()
      .toList();
      quotes = values;
      generateRandomQuote();
    });
  }

  void generateRandomQuote() {
    int index = Random().nextInt(quotes.length);
    setState(() {
      currentQuote = quotes[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              currentQuote,
              style: TextStyle(
                fontSize: 18.0,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: generateRandomQuote,
              child: Text('Next Quote'),
            ),
          ],
        ),
      ),
    );
  }
}
