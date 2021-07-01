import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var streamRanging;

  @override
  void initState() {
    startBeacon();
    super.initState();
  }

  Future<void> startBeacon() async {
    try {
      await flutterBeacon.initializeScanning;
      await flutterBeacon.initializeAndCheckScanning;
    } on PlatformException catch (e) {}
  }

  void rangingBeacons() {
    setState(() {
      final regions = <Region>[];

      regions.add(Region(identifier: 'com.beacon'));

      streamRanging =
          flutterBeacon.ranging(regions).listen((RangingResult result) {
        for (var b in result.beacons) {
          log(b.proximityUUID.toString());
          log(b.txPower.toString());
          log(b.accuracy.toString());
          log(b.macAddress.toString());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Encontrar Beacon:',
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: rangingBeacons,
        tooltip: 'Encontrar beacon',
        child: Icon(Icons.add),
      ),
    );
  }
}
