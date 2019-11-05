import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_growingio_touch/flutter_growingio_touch.dart';
import 'package:flutter_growingio_track/flutter_growingio_track.dart';

void main() {
  Widget app = MyApp();
  runApp(app);
  openEventPopup();
}

void openEventPopup() async {
  if (!await GrowingTouch.eventPopupEnable) {
    GrowingTouch.eventPopupListener = EventPopupListener(
      onLoadSuccess: (eventId, eventType) => print('onLoadSuccess: eventId = ' + eventId + ', eventType = ' + eventType),
      onLoadFailed: (eventId, eventType, errorCode, description) => print('onLoadFailed: eventId = ' + eventId + ', eventType = ' + eventType + ', errorCode = ' + errorCode.toString() + ', description = ' + description),
      onCancel: (eventId, eventType) => print('onCancel: eventId = ' + eventId + ', eventType = ' + eventType),
      onClicked: (eventId, eventType, openUrl) => print('onClicked: eventId = ' + eventId + ', eventType = ' + eventType + ', openUrl = ' + openUrl),
      onTimeout: (eventId, eventType) => print('onTimeout: eventId = ' + eventId + ', eventType = ' + eventType),
    );
    GrowingTouch.enableEventPopupAndGenerateAppOpenEvent();
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
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
  bool _popupEnable = true;

  @override
  void initState() {
    super.initState();
//    initPopupEnable();
  }

  Future<void> initPopupEnable() async {
    bool state = await GrowingTouch.eventPopupEnable;
    print("eventPopupEnable is " + state.toString());
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
        Container(
          width: screenWidth,
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: CupertinoButton(
            child: Text('注册弹窗监听'),
            onPressed: () {
              GrowingTouch.eventPopupListener = EventPopupListener(onLoadSuccess: (eventId, eventType) => print('onLoadSuccess: eventId = ' + eventId + ', eventType = ' + eventType));
            },
            color: Colors.teal,
          ),
        ),
        Container(
          width: screenWidth,
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: CupertinoButton(
            child: Text('注销弹窗监听'),
            onPressed: () {
              GrowingTouch.eventPopupListener = null;
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
