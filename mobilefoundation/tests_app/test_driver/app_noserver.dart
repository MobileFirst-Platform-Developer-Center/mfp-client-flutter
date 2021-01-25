// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('MFP Integration Tests', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
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

      await driver.waitFor(find.text("Obtain Access Token failure"));
    });

    test('obtainAccessTokenEmptyScope', () async {
      // First, tap the button.
      await driver.tap(obtainTokenWithEmptyScope);
      await driver
          .waitFor(find.text("Obtain Access Token failure for empty scope"));
    });

    test('obtainTokenWithValidScope', () async {
      // First, tap the button.
      await driver.tap(obtainTokenWithValidScope);
      await driver
          .waitFor(find.text("Obtain Access Token failure for valid scope"));
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

    test('userLogin', () async {
      await driver.tap(loginButton);

      await driver.waitFor(find.text("Login Failure"));
    });

    test('loginWithPinCode', () async {
      await driver.tap(loginWithPinCode);

      await driver.waitFor(find.text("Login Failure With PinCode"));
    });

    test('getBalance', () async {
      await driver.tap(getBalance);

      await driver.waitFor(find.text("Get Balance Failed"));
    });

    test('logout', () async {
      await driver.tap(logoutButton);

      await driver.waitFor(find.text("LogOut failure"));
    });

    test('timeOut 15sec', () async {
      await driver.tap(timeOutTest);

      await driver.waitFor(find.text("Request timed out"));
    });

    test('timeOut 30sec', () async {
      await driver.tap(timeOutTest2);

      await driver.waitFor(find.text("Request timed out"));
    });

    test('MFResourceRequestSendAsMap', () async {
      await driver.tap(mFResourceRequestSendAsMap);

      await driver.waitFor(find.text("WLRR Response Send As Map Failed"));
    });

    test('MFResourceRequestSendAsFormParameter', () async {
      await driver.scrollUntilVisible(
          listFinder, mFResourceRequestSendAsFormParameter);

      await driver.tap(mFResourceRequestSendAsFormParameter);

      await driver.waitFor(find
          .text("MFResourceRequest Response Send As Form Parameter Failed"));
    });

    test('MFResourceRequestSendAsString', () async {
      await driver.scrollUntilVisible(
          listFinder, mFResourceRequestSendAsString);

      await driver.tap(mFResourceRequestSendAsString);

      await driver.waitFor(
          find.text("MFResourceRequest Response Send As String Failed"));
    });

    test('MFResourceRequestaddGlobalHeader', () async {
      await driver.scrollUntilVisible(
          listFinder, mFResourceRequestaddGlobalHeader);

      await driver.tap(mFResourceRequestaddGlobalHeader);

      await driver.waitFor(find.text(
          "MFResourceRequest Call Failed For addGlobalHeader Custom Header Test"));
    });

    test('MFResourceRequestaddGlobalHeaderAndRemove', () async {
      await driver.scrollUntilVisible(
          listFinder, mFResourceRequestaddGlobalHeaderAndRemove);

      await driver.tap(mFResourceRequestaddGlobalHeaderAndRemove);

      await driver.waitFor(find.text(
          "MFResourceRequest Call Failed For addGlobalHeader and Remove Test"));
    });
    test('MFResourceRequestSetQueryParameter', () async {
      await driver.scrollUntilVisible(
          listFinder, mFResourceRequestSetQueryParameter);

      await driver.tap(mFResourceRequestSetQueryParameter);

      await driver.waitFor(
          find.text("MFResourceRequest Call Failed For Set Query Param Test"));
    });
    test('MFResourceRequestGetUrl', () async {
      await driver.scrollUntilVisible(listFinder, mFResourceRequestGetUrl);

      await driver.tap(mFResourceRequestGetUrl);

      await driver
          .waitFor(find.text("MFResourceRequest Call Failed For Get URL Test"));
    });

    test('set device display name', () async {
      await driver.scrollUntilVisible(listFinder, setDeviceName);

      await driver.tap(setDeviceName);

      await driver.waitFor(find.text("Failed to set Device display name"));
    });

    test('get device display name', () async {
      await driver.scrollUntilVisible(listFinder, getDeviceName);
      await driver.tap(getDeviceName);

      await driver.waitFor(find.text("Failed to get device display name"));
    });
  });
}
