import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mobilefoundation/mobilefoundationauthorizationmanager.dart';
import 'package:mobilefoundation/mobilefoundationclient.dart';
import 'package:mobilefoundation/mobilefoundationresourcerequest.dart';
import 'package:mobilefoundation/mobilefoundationlogger.dart';
import 'package:mobilefoundation_example/userLoginChallengeHandler.dart';

void main() {
  runApp(MyApp());
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
      MFClient client = new MFClient();
      UserLoginChallengeHandler ch = new UserLoginChallengeHandler();
      client.registerChallengeHandler(challengeHandler: ch);
      await client.addGlobalHeader(
          headerName: "MyHeader", headerValue: "MyHeaderValue");
      await client.removeGlobalHeader(headerName: "MyHeader");
      String serverUrl = await client.getServerUrl();

      MFLogger.setLevel(level: MFLoggerLevel.TRACE);
      MFLogger logger = new MFLogger(packageName: "DART_EXAMPLE");
      logger.trace(message: "TEST LOG ---->");

      MFAuthorizationManager authManager = new MFAuthorizationManager();
      authManager.obtainAccessToken().then((accessToken) {
        print("Token is ----> " + accessToken.value);
        platformVersion = accessToken.value;

        setState(() {
          _platformVersion = platformVersion;
        });
      }).catchError((error) => print("Error in obtain access token"));
      print("obtain accesstoken call complete ");

      MFResourceRequest request = new MFResourceRequest("adapters/ResourceAdapter/publicData", MFResourceRequest.GET);
      request.send().then((response) {
       print("MFResourceRequest Call Success. Response: " + response.responseText);
      }).catchError((error) {
        print("MFResourceRequest Call Failed. Error: " + error.errorMsg);
      });
     print("MFResourceRequest call complete ");
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
