// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('MFP Integration Tests', () {
    // First, define the Finders and use them to locate widgets from the app
    final outputTextFinder = find.byValueKey('output');
    final listFinder = find.byValueKey('test_cases');
    final obtainToken = find.byValueKey('one');
    final obtainTokenWithEmptyScope =
        find.byValueKey('obtainTokenWithEmptyScope');
    final obtainTokenWithValidScope =
        find.byValueKey('obtainTokenWithValidScope');
    final obtainTokenWithInValidScope =
        find.byValueKey('obtainTokenWithInValidScope');
    final loginButton = find.byValueKey('two');
    final loginWithPinCode = find.byValueKey('loginWithPinCode');
    final getBalance = find.byValueKey('four');
    final logoutButton = find.byValueKey('three');
    final timeOutTest = find.byValueKey('five');
    final timeOutTest2 = find.byValueKey('six');
    final mFResourceRequestSendAsMap =
        find.byValueKey('mFResourceRequestSendAsMap');
    final mFResourceRequestSendAsFormParameter =
        find.byValueKey('mFResourceRequestSendAsFormParameter');
    final mFResourceRequestSendAsString =
        find.byValueKey('mFResourceRequestSendAsString');
    final mFResourceRequestaddGlobalHeader =
        find.byValueKey('mFResourceRequestaddGlobalHeader');
    final mFResourceRequestaddGlobalHeaderAndRemove =
        find.byValueKey('mFResourceRequestaddGlobalHeaderAndRemove');
    final mFResourceRequestSetQueryParameter =
        find.byValueKey('mFResourceRequestSetQueryParameter');
    final mFResourceRequestGetUrl = find.byValueKey('mFResourceRequestGetUrl');
    final setDeviceName = find.byValueKey('seven');
    final getDeviceName = find.byValueKey('eight');
    final get404 = find.byValueKey('nine');
    final serverUrl = find.byValueKey('ten');
    final certPinning = find.byValueKey('pincertificate');

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

    test('obtainAccessTokenEmptyScope', () async {
      // First, tap the button.
      await driver.tap(obtainTokenWithEmptyScope);
      await driver.waitFor(find.text("Got Token For Empty Scope"));
    });

    test('obtainTokenWithValidScope', () async {
      // First, tap the button.
      await driver.tap(obtainTokenWithValidScope);
      await driver.waitFor(find.text("Got Token For Valid Scope"));
    });

    test('obtainTokenWithInValidScope', () async {
      // First, tap the button.
      await driver.tap(obtainTokenWithInValidScope);
      await driver
          .waitFor(find.text("Obtain Access Token failure for invalid scope"));
    });

    test('getBalance', () async {
      await driver.tap(getBalance);

      await driver.waitFor(find.text("Get Balance Failed"));
    });

    test('Challenge Handler for UserLogin', () async {
      await driver.tap(getBalance);

      await driver.waitFor(find.text("Balance : 19938.80"));
    });
    test('loginWithPinCode', () async {
      await driver.tap(loginWithPinCode);

      await driver.waitFor(find.text("Login Success With PinCode"));
    });
    test('logout', () async {
      await driver.tap(logoutButton);

      await driver.waitFor(find.text("LogOut Success"));
    });

    test('userLogin', () async {
      await driver.tap(loginButton);

      await driver.waitFor(find.text("Login Success"));
    });

    test('getBalance after login', () async {
      await driver.tap(getBalance);

      await driver.waitFor(find.text("Balance : 19938.80"));
    });

    test('timeOut 15sec', () async {
      await driver.tap(timeOutTest);

      await driver.waitFor(find.text("Request timed out"));
    });

    test('timeOut 30sec', () async {
      await driver.tap(timeOutTest2);

      await driver.waitFor(find.text("Got Response"));
    });

    test('MFResourceRequestSendAsMap', () async {
      await driver.scrollUntilVisible(listFinder, mFResourceRequestSendAsMap);
      await driver.tap(mFResourceRequestSendAsMap);

      await driver.waitFor(find.text("Got Response Send As Map"));
    });

    test('MFResourceRequestSendAsFormParameter', () async {
      await driver.scrollUntilVisible(
          listFinder, mFResourceRequestSendAsFormParameter);

      await driver.tap(mFResourceRequestSendAsFormParameter);

      await driver.waitFor(find.text("Got Response Send As Form Parameter"));
    });

    test('MFResourceRequestSendAsString', () async {
      await driver.scrollUntilVisible(
          listFinder, mFResourceRequestSendAsString);

      await driver.tap(mFResourceRequestSendAsString);

      await driver.waitFor(find.text("Got Response Send As String"));
    });

    test('MFResourceRequestaddGlobalHeader', () async {
      await driver.scrollUntilVisible(
          listFinder, mFResourceRequestaddGlobalHeader);

      await driver.tap(mFResourceRequestaddGlobalHeader);

      await driver
          .waitFor(find.text("Got Response Add Global Custom Header Header"));
    });

    test('MFResourceRequestaddGlobalHeaderAndRemove', () async {
      await driver.scrollUntilVisible(
          listFinder, mFResourceRequestaddGlobalHeaderAndRemove);

      await driver.tap(mFResourceRequestaddGlobalHeaderAndRemove);

      await driver
          .waitFor(find.text("Got Response Add Global Header and Remove"));
    });
    test('MFResourceRequestSetQueryParameter', () async {
      await driver.scrollUntilVisible(
          listFinder, mFResourceRequestSetQueryParameter);

      await driver.tap(mFResourceRequestSetQueryParameter);

      await driver.waitFor(find.text("Got Response For Set Query Param"));
    });
    test('MFResourceRequestGetUrl', () async {
      await driver.scrollUntilVisible(listFinder, mFResourceRequestGetUrl);

      await driver.tap(mFResourceRequestGetUrl);

      await driver.waitFor(find.text("Got Response For Get URL"));
    });

    test('set device display name', () async {
      await driver.scrollUntilVisible(listFinder, setDeviceName);
      await driver.tap(setDeviceName);

      await driver
          .waitFor(find.text("Successfully set the device display name"));
    });

    test('get device display name', () async {
      await driver.scrollUntilVisible(listFinder, getDeviceName);
      await driver.tap(getDeviceName);

      await driver.waitFor(find.text("Got device display name FlutterDemo"));
    });

    test('call adapter that does not exist', () async {
      await driver.scrollUntilVisible(listFinder, get404);
      await driver.tap(get404);

      await driver.waitFor(find.text("Got 404"));
    });

    test('set and get server url', () async {
      await driver.scrollUntilVisible(listFinder, serverUrl);
      await driver.tap(serverUrl);

      await driver.waitFor(find.text("serverURL success"));
    });

    test('cert pinning', () async {
      await driver.scrollUntilVisible(listFinder, certPinning);
      await driver.tap(certPinning);

      await driver.waitFor(find.text("Certificate pinning failed"));
    });
  });
}
