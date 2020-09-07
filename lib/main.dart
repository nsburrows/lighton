import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lighton/bplping.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Current een on aye!?',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Current On At Home?'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Ping> list;

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  Future<List<Ping>> getData() async {
    String link;

    // Get data from my API that has the sentiment analysis score
    link = "https://world101.herokuapp.com/api/BplPing";

    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    setState(() {
      if (res.statusCode == 200) {
        list = (json.decode(res.body) as List)
            .map<Ping>((json) => Ping.fromJson(json))
            .toList();
      }
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    bool isOn = false;
    if (list != null) {
      var bplPingDtTimeStamp =
          DateTime.parse(list[0].lastPingDt).add(Duration(hours: 4));
      var differenceInMinutes =
          DateTime.now().difference(bplPingDtTimeStamp).inMinutes;
      isOn = differenceInMinutes > 1 ? false : true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
        primary: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
                margin: EdgeInsets.all(10),
                elevation: 10,
                color: isOn ? Colors.yellow : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(width: 6, color: Colors.black),
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  size: 200,
                )),
            Text(isOn
                ? 'Current On Bey'
                : 'Current Off Since: ' +
                    DateTime.parse(list[0].lastPingDt).toString()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getData,
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
