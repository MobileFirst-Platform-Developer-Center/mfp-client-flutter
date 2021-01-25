// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';


void main() {
  group('MFP Integration Tests', () {
    // First, define the Finders and use them to locate widgets from the app
    final outputTextFinder = find.byValueKey('output');
    final obtainToken = find.byValueKey('one');
    final loginButton = find.byValueKey('two');
    final getBalance = find.byValueKey('four');
    final logoutButton = find.byValueKey('three');
    final timeOutTest = find.byValueKey('five');
    final timeOutTest2 = find.byValueKey('six');
    final setDeviceName = find.byValueKey('seven');
    final getDeviceName = find.byValueKey('eight');
    final get404 = find.byValueKey('nine');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('starts at 0', () async {
      expect(await driver.getText(outputTextFinder), "");
    });

    test('obtainAccessToken', () async {
      // First, tap the button.
      await driver.tap(obtainToken);

      await driver.waitFor(find.text("Got Token"));
    });

    test('getBalance', () async {
      await driver.tap(getBalance);

      await driver.waitFor(find.text("Get Balance Failed"));
    });


    test('userLogin', () async {
      await driver.tap(loginButton);
      
      await driver.waitFor(find.text("Login Success"));
    });

    test('getBalance', () async {
      await driver.tap(getBalance);

      await driver.waitFor(find.text("Balance : 19938.80"));
    });

    test('logout', () async {
      await driver.tap(logoutButton);
      
      await driver.waitFor(find.text("LogOut Success"));
    });

    test('timeOut 15sec', () async {
      await driver.tap(timeOutTest);

      await driver.waitFor(find.text("Request timed out"));
    });

    test('timeOut 30sec', () async {
      await driver.tap(timeOutTest2);

      await driver.waitFor(find.text("Got Response"));
    });

    test('set device display name',() async {
      await driver.tap(setDeviceName);

      await driver.waitFor(find.text("Successfully set the device display name"));
    });

    test('get device display name',() async {
      await driver.tap(getDeviceName);

      await driver.waitFor(find.text("Got device display name FlutterDemo"));
    });

    test('call adapter that does not exist',() async {
      await driver.tap(get404);

      await driver.waitFor(find.text("Got 404"));
    });

  });
}
