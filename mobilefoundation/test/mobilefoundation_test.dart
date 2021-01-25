import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefoundation/mobilefoundationclient.dart';

void main() {
  const MethodChannel channel = MethodChannel('mobilefoundation');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Mobilefoundation.platformVersion, '42');
  });
}
