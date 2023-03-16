import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Movies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _filmsList = "";

  late MethodChannel _iosPlatformChannel;
  late MethodChannel _androidPlatformChannel;

  Future<void> _getFilmsList() async {
    MethodChannel platformChannel;

    if (Platform.isAndroid) {
      platformChannel = _androidPlatformChannel;
    } else if (Platform.isIOS) {
      platformChannel = _iosPlatformChannel;
    } else {
      return;
    }

    Map<String, dynamic> sendMap = {
      "url": "https://api.themoviedb.org/3/discover/movie",
      "api_key": "838918a0429843af1ee8639f1ad0cf81",
      "language": "en-US",
      "sort_by": "popularity.desc",
      "include_adult": false,
      "include_video": false,
      "page": "1",
      "with_watch_monetization_types": "flatrate"
    };

    String _films;
    try {
      final String result =
          await platformChannel.invokeMethod('getFilmsList', sendMap);
      _films = result;
    } catch (e) {
      if (kDebugMode) {
        print("Can't fetch the method: '$e'.");
      }
      _films = "";
    }
    setState(() {
      _filmsList = _films;
    });
  }

  @override
  void initState() {
    _iosPlatformChannel = const MethodChannel('test.flutter.methodchannel/iOS');
    _androidPlatformChannel =
        const MethodChannel('test.flutter.methodchannel/android');

    _getFilmsList();

    super.initState();
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
              'films list:$_filmsList\n',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getFilmsList,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
