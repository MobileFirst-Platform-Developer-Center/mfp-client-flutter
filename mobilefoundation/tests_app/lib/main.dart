import 'package:flutter/material.dart';
import "package:mobilefoundation/mobilefoundationauthorizationmanager.dart";
import 'package:mobilefoundation/mobilefoundationclient.dart';
import 'package:mobilefoundation/mobilefoundationresourcerequest.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tests App',
      home: MyHomePage(title: 'Integration Tests'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _output = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> _obtainToken() async {
    MFAuthorizationManager authManager = new MFAuthorizationManager();
    try{
      authManager.obtainAccessToken().then((value) {
        print("Got access Token");
        setState(() {
          _output = "Got Token";
        });
      } 
         ).catchError((error) {
            print("Obtain Access Token failure " + error.errorMsg);
            setState(() {
              _output="Obtain Access Token failure";
            });
          });  
    }
    catch(e){
      print(e);
    }
  }

  Future<void> _login() async {
    MFAuthorizationManager authManager = new MFAuthorizationManager();
    try{
      authManager.login(securityCheck:"UserLogin", credentials: {"username":"admin","password":"admin"}).then((value) {
        print("Login SUCESS ----> ");
        setState(() {
            _output="Login Success";
          });
        }
        ).catchError((error) {
            print("Login Failure");
            setState(() {
              _output="Login Failure";
            });
        });
    }
    catch(e){
      print(e);
    }
  }

  Future<void> _logout() async {
    MFAuthorizationManager authManager = new MFAuthorizationManager();
    try{
      authManager.logout( securityCheck:"UserLogin").then((value) {
          print("Logout SUCESS ----> ");
          setState(() {
            _output="LogOut Success";
          });
        }).catchError((error) {
            print("Logout Failure " + error.toString());
            setState(() {
              _output="LogOut failure";
            });
        });
    }
    catch(e){
      print(e);
    }
  }

  Future<void> _getBalance() async {
    MFResourceRequest request = new MFResourceRequest("/adapters/ResourceAdapter/balance", MFResourceRequest.GET);
      request.send().then((response) {
       print("MFResourceRequest Call Success. Response: " + response.responseText);
       setState(() {
            _output="Balance : ${response.responseText}";
          });
      }).catchError((error) {
        print("MFResourceRequest Call Failed. Error: " + error.errorMsg);
        setState(() {
          _output="Get Balance Failed";
        });
      });
  }

  Future<void> _testTimeOut(int timeout) async {
    MFResourceRequest request = new MFResourceRequest("/adapters/ResourceAdapter/timeOut", MFResourceRequest.GET,timeout:timeout);
      request.send().then((response) {
       print("MFResourceRequest Call Success. Response: " + response.responseText);
       setState(() {
         _output="Got Response";
       });
      }).catchError((error) {
        print("MFResourceRequest Call Failed. Error: " + error.errorMsg);
        setState(() {
          _output="Request timed out";
        });
      });
  }

  Future<void> _setDeviceName() async {
    MFClient mfClient = MFClient();
    mfClient.setDeviceDisplayName(deviceDisplayName: "FlutterDemo").then((value) {
      print("Successfully set the device display name to FlutterDemo");
      setState((){
        _output="Successfully set the device display name";
      });
    }).catchError((error) {
      print("Failed to set Device display name ${error.errorMsg}");
      setState((){
        _output="Failed to set Device display name";
      });
    });
  }

  Future<void> _getDeviceName() async {
    MFClient mfClient = MFClient();
    mfClient.getDeviceDisplayName().then((value) {
      print("Got device display name $value");
      setState((){
        _output="Got device display name $value";
      });
    }).catchError((error){
      print("Failed to get device display name: ${error.errorMsg}");
      setState(() {
        _output="Failed to get device display name";
      });
    });
  }

  void _get404() async {
    MFResourceRequest request = new MFResourceRequest("/adapters/DoesNotExist/getData", MFResourceRequest.GET);
      request.send().then((response) {
       print("MFResourceRequest Call Success. Response: " + response.responseText);
       setState(() {
         _output="Got Response";
       });
      }).catchError((error) {
        print("MFResourceRequest Call Failed. Error: " + error.errorMsg);
        setState(() {
          _output="Got 404";
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
              'Output:'
            ),
            Text(
              '$_output',
              maxLines: 2,
              // Provide a Key to this specific Text widget. This allows
              // identifying the widget from inside the test suite,
              // and reading the text.
              key: Key('output'),
              style: Theme.of(context).textTheme.headline4,
            ),
            FlatButton(
              // Provide a Key to this button. This allows finding this
              // specific button inside the test suite, and tapping it.
              key: Key('one'),
              onPressed: _obtainToken,
              child: Text(
                'Obtain Access Token'
              ),
            ),
            FlatButton(
              // Provide a Key to this button. This allows finding this
              // specific button inside the test suite, and tapping it.
              key: Key('two'),
              onPressed: _login,
              child: Text(
                'Login'
              ),
            ),
            FlatButton(
              // Provide a Key to this button. This allows finding this
              // specific button inside the test suite, and tapping it.
              key: Key('three'),
              onPressed: _logout,
              child: Text(
                'Logout'
              ),
            ),
            FlatButton(
              // Provide a Key to this button. This allows finding this
              // specific button inside the test suite, and tapping it.
              key: Key('four'),
              onPressed: _getBalance,
              child: Text(
                'Get Balance'
              ),
            ),
            FlatButton(
              // Provide a Key to this button. This allows finding this
              // specific button inside the test suite, and tapping it.
              key: Key('five'),
              onPressed: () => _testTimeOut(15000),
              child: Text(
                'Get Data'
              ),
            ),
            FlatButton(
              // Provide a Key to this button. This allows finding this
              // specific button inside the test suite, and tapping it.
              key: Key('six'),
              onPressed: () => _testTimeOut(30000),
              child: Text(
                'Get Data 30sec'
              ),
            ),
            FlatButton(
              // Provide a Key to this button. This allows finding this
              // specific button inside the test suite, and tapping it.
              key: Key('seven'),
              onPressed: _setDeviceName,
              child: Text(
                'Set Device Name'
              ),
            ),
            FlatButton(
              // Provide a Key to this button. This allows finding this
              // specific button inside the test suite, and tapping it.
              key: Key('eight'),
              onPressed: _getDeviceName,
              child: Text(
                'Get Device Name'
              ),
            ),
            FlatButton(
              // Provide a Key to this button. This allows finding this
              // specific button inside the test suite, and tapping it.
              key: Key('nine'),
              onPressed: _get404,
              child: Text(
                'Adapter 404'
              ),
            ),
          ],
        ),
      ),
    );
  }
}
