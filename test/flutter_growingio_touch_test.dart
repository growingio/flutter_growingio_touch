import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_growingio_touch/flutter_growingio_touch.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_growingio_touch');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await GrowingTouch.platformVersion, '42');
  });
}
