import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_growingio_touch/flutter_growingio_touch.dart';
import 'package:flutter_growingio_track/flutter_growingio_track.dart';

void main() {
  runApp(MyApp());
  GrowingTouch.enableEventPopupAndGenerateAppOpenEvent();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool open = await GrowingTouch.eventPopupEnable;
      platformVersion = open.toString();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GTouch Flutter'),
        ),
        body: _HomePage(),
      ),
    );
  }
}

class _HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  bool _popupEnable = false;

  @override
  void initState() {
    super.initState();
    initPopupEnable();
  }

  Future<void> initPopupEnable() async {
    bool state = await GrowingTouch.eventPopupEnable;
    setState(() {
      _popupEnable = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 30),
              child: const Text('触达开关', style: TextStyle(fontSize: 22)),
            ),
            CupertinoSwitch(
                value: _popupEnable,
                onChanged: (bool value) {
                  setState(() {
                    _popupEnable = !_popupEnable;
                    GrowingTouch.eventPopupEnable = _popupEnable;
                  });
                })
          ],
        ),
        Container(
          width: screenWidth,
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: CupertinoButton(
            child: Text('触发一个埋点事件'),
            onPressed: () {
              GrowingIO.track("touch1");
            },
            color: Colors.teal,
          ),
        ),
        Container(
          width: screenWidth,
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: CupertinoButton(
            child: Text('打开一个页面'),
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => SecondScreen()));
            },
            color: Colors.teal,
          ),
        ),
      ],
    );
  }
}

class SecondScreen extends StatelessWidget {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      if (!_open) {
        _open = true;
        print("Page first open ");
        GrowingIO.track("TestPageOpen");
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: CupertinoButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
          color: Colors.teal,
        ),
      ),
    );
  }
}
