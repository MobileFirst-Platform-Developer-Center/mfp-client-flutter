import 'package:flutter/material.dart';
import "package:mobilefoundation/mobilefoundationauthorizationmanager.dart";
import 'package:mobilefoundation/mobilefoundationclient.dart';
import 'package:mobilefoundation/mobilefoundationresourcerequest.dart';
import 'package:tests_app/pinCodeChallengeHandler.dart';
import "package:tests_app/userLoginChallengeHandler.dart";

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
  bool shouldRegister = false;
  MFClient client;

  @override
  void initState() {
    super.initState();
    client = new MFClient();
    PinCodeChallengeHandler ch = new PinCodeChallengeHandler();
    client.registerChallengeHandler(challengeHandler: ch);
  }

  Future<void> _obtainToken() async {
    MFAuthorizationManager authManager = new MFAuthorizationManager();
    try {
      authManager.obtainAccessToken().then((value) {
        print("Got access Token");
        setState(() {
          _output = "Got Token";
        });
      }).catchError((error) {
        print("Obtain Access Token failure " + error.errorMsg);
        setState(() {
          _output = "Obtain Access Token failure";
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _obtainTokenWithEmptyScope() async {
    MFAuthorizationManager authManager = new MFAuthorizationManager();
    try {
      authManager.obtainAccessToken(scope: "").then((value) {
        print("Got Token For Empty Scope");
        setState(() {
          _output = "Got Token For Empty Scope";
        });
      }).catchError((error) {
        print("Obtain Access Token failure for empty scope " + error.errorMsg);
        setState(() {
          _output = "Obtain Access Token failure for empty scope";
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _obtainTokenWithValidScope() async {
    MFAuthorizationManager authManager = new MFAuthorizationManager();
    try {
      authManager.obtainAccessToken(scope: "checkScope").then((value) {
        print("Got Token For Valid Scope");
        setState(() {
          _output = "Got Token For Valid Scope";
        });
      }).catchError((error) {
        print("Obtain Access Token failure for valid scope " + error.errorMsg);
        setState(() {
          _output = "Obtain Access Token failure for valid scope";
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _obtainTokenWithInvalidScope() async {
    MFAuthorizationManager authManager = new MFAuthorizationManager();
    try {
      authManager.obtainAccessToken(scope: "check").then((value) {
        print("Got Token For Invalid Scope");
        setState(() {
          _output = "Got Token For Invalid Scope";
        });
      }).catchError((error) {
        print(
            "Obtain Access Token failure for invalid scope " + error.errorMsg);
        setState(() {
          _output = "Obtain Access Token failure for invalid scope";
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _login() async {
    MFAuthorizationManager authManager = new MFAuthorizationManager();
    try {
      authManager.login(securityCheck: "UserLogin", credentials: {
        "username": "admin",
        "password": "admin"
      }).then((value) {
        print("Login SUCESS ----> ");
        setState(() {
          _output = "Login Success";
        });
      }).catchError((error) {
        print("Login Failure");
        setState(() {
          _output = "Login Failure";
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loginWithPinCode() async {
    MFAuthorizationManager authManager = new MFAuthorizationManager();
    try {
      Map credentials = new Map();
      credentials['pin'] = '1234';
      authManager
          .login(securityCheck: "PinCodeAttempts", credentials: credentials)
          .then((value) {
        print("Login SUCESS With PinCode ----> ");
        setState(() {
          _output = "Login Success With PinCode";
        });
      }).catchError((error) {
        print("Login Failure With PinCode");
        setState(() {
          _output = "Login Failure With PinCode";
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _logout() async {
    MFAuthorizationManager authManager = new MFAuthorizationManager();
    try {
      authManager.logout(securityCheck: "UserLogin").then((value) {
        print("Logout SUCESS ----> ");
        setState(() {
          _output = "LogOut Success";
        });
      }).catchError((error) {
        print("Logout Failure " + error.toString());
        setState(() {
          _output = "LogOut failure";
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getBalance() async {
    if (shouldRegister == true) {
      MFClient client = new MFClient();
      UserLoginChallengeHandler ch = new UserLoginChallengeHandler();
      client.registerChallengeHandler(challengeHandler: ch);
    }
    setState(() {
      shouldRegister = true;
    });
    MFResourceRequest request = new MFResourceRequest(
        "/adapters/ResourceAdapter/balance", MFResourceRequest.GET);
    request.send().then((response) {
      print(
          "MFResourceRequest Call Success. Response: " + response.responseText);
      setState(() {
        _output = "Balance : ${response.responseText}";
      });
    }).catchError((error) {
      print("MFResourceRequest Call Failed. Error: " + error.errorMsg);
      setState(() {
        _output = "Get Balance Failed";
      });
    });
  }

  Future<void> _testTimeOut(int timeout) async {
    MFResourceRequest request = new MFResourceRequest(
        "/adapters/ResourceAdapter/timeOut", MFResourceRequest.GET,
        timeout: timeout);
    request.send().then((response) {
      print(
          "MFResourceRequest Call Success. Response: " + response.responseText);
      setState(() {
        _output = "Got Response";
      });
    }).catchError((error) {
      print("MFResourceRequest Call Failed. Error: " + error.errorMsg);
      setState(() {
        _output = "Request timed out";
      });
    });
  }

  Future<void> _mFResourceRequestSendAsMap() async {
    Map mapJson = new Map();
    mapJson['Header'] = 'Test';
    MFResourceRequest request = new MFResourceRequest(
        "adapters/ResourceAdapter/wlresreqwithsjsontest",
        MFResourceRequest.POST);
    request.send(json: mapJson).then((response) {
      print('WLRR Response' + response.responseText);

      //results['Header'] = response.responseText.Header;
      setState(() {
        if (response.responseText.contains(mapJson['Header'])) {
          _output = "Got Response Send As Map";
        } else {
          _output = "WLRR Response Send As Map Failed";
        }
      });
    }).catchError((error) {
      print("MFResourceRequest Call Failed. Error: " + error.errorMsg);
      setState(() {
        _output = "WLRR Response Send As Map Failed";
      });
    });
  }

  Future<void> _mFResourceRequestSendAsFormParameter() async {
    Map formParameter = new Map();
    formParameter['Name'] = 'John';
    formParameter['email'] = 'John@gmail.com';
    MFResourceRequest request = new MFResourceRequest(
        "adapters/ResourceAdapter/wlresreqwithformparamtest",
        MFResourceRequest.POST);
    request.send(formParameters: formParameter).then((response) {
      print('MFResourceRequest Response' + response.responseText);
      setState(() {
        if (response.responseText.contains(formParameter['Name'])) {
          _output = "Got Response Send As Form Parameter";
        } else {
          _output = "MFResourceRequest Response Send As Form Parameter Failed";
        }
      });
    }).catchError((error) {
      print("MFResourceRequest Call Failed. Error: " + error.errorMsg);
      setState(() {
        _output = "MFResourceRequest Response Send As Form Parameter Failed";
      });
    });
  }

  Future<void> _mFResourceRequestSendAsString() async {
    String requestBody = "Request";
    MFResourceRequest request = new MFResourceRequest(
        "adapters/ResourceAdapter/wlresreqwithstringtest",
        MFResourceRequest.POST);
    request.send(requestBody: requestBody).then((response) {
      print('MFResourceRequest Response' + response.responseText);
      setState(() {
        if (response.responseText.contains(requestBody)) {
          _output = "Got Response Send As String";
        } else {
          _output = "MFResourceRequest Response Send As String Failed";
        }
      });
    }).catchError((error) {
      print("MFResourceRequest Call Failed. Error: " + error.errorMsg);
      setState(() {
        _output = "MFResourceRequest Response Send As String Failed";
      });
    });
  }

  _mFResourceRequestaddGlobalHeader() {
    client.addGlobalHeader(
        headerName: "Resource", headerValue: "AddGlobalHeader");
    MFResourceRequest mfResourceRequest = new MFResourceRequest(
        "adapters/ResourceAdapter/WlClientTest", MFResourceRequest.GET);
    mfResourceRequest.send().then((response) {
      print(
          "MFResourceRequest Response For addGlobalHeader Custom Header Test" +
              response.responseText);
      if ("AddGlobalHeader" == response.responseText) {
        setState(() {
          _output = "Got Response Add Global Custom Header Header";
        });
      } else {
        setState(() {
          _output =
              "MFResourceRequest Call Failed For addGlobalHeader Custom Header Test";
        });
      }
    }).catchError((error) {
      print(
          "MFResourceRequest Call Failed For addGlobalHeader Custom Header Test. Error: " +
              error.errorMsg);
      setState(() {
        _output =
            "MFResourceRequest Call Failed For addGlobalHeader Custom Header Test";
      });
    });
  }

  _mFResourceRequestaddGlobalHeaderAndRemove() {
    client.addGlobalHeader(
        headerName: "Resource", headerValue: "AddGlobalHeader");
    client.removeGlobalHeader(headerName: "Resource");
    MFResourceRequest mfResourceRequest = new MFResourceRequest(
        "adapters/ResourceAdapter/WlClientTest", MFResourceRequest.GET);
    mfResourceRequest.send().then((response) {
      print("MFResourceRequest Response For addGlobalHeader and Remove Test" +
          response.responseText);

      if ("AddGlobalHeader" != response.responseText) {
        setState(() {
          _output = "Got Response Add Global Header and Remove";
        });
      } else {
        setState(() {
          _output =
              "MFResourceRequest Call Failed For addGlobalHeader and Remove Test";
        });
      }
    }).catchError((error) {
      print(
          "MFResourceRequest Call Failed For addGlobalHeader Null Value Test. Error: " +
              error.errorMsg);
      setState(() {
        _output =
            "MFResourceRequest Call Failed For addGlobalHeader and Remove Test";
      });
    });
  }

  _mFResourceRequestSetQueryParameter() {
    MFResourceRequest mfResourceRequest = new MFResourceRequest(
        "adapters/ResourceAdapter/WlClientTest", MFResourceRequest.GET);
    mfResourceRequest.setQueryParameters(
        paramName: "Resource", paramValue: "AddGlobalHeader");
    mfResourceRequest.send().then((response) {
      print("MFResourceRequest Response For Set Query Param Test" +
          response.responseText);

      mfResourceRequest.queryParameters.then((queryParam) {
        if ("AddGlobalHeader" == queryParam["Resource"]) {
          setState(() {
            _output = "Got Response For Set Query Param";
          });
        } else {
          setState(() {
            _output = "MFResourceRequest Call Failed For Set Query Param Test";
          });
        }
      }).catchError((error) {
        print("MFResourceRequest Call Failed to Get Query Param Error: " +
            error.errorMsg);
        setState(() {
          _output = "MFResourceRequest Call Failed to Get Query Param";
        });
      });
    }).catchError((error) {
      print("MFResourceRequest Call Failed For Set Query Param Test. Error: " +
          error.errorMsg);
      setState(() {
        _output = "MFResourceRequest Call Failed For Set Query Param Test";
      });
    });
  }

  _mFResourceRequestGetUrl() {
    MFResourceRequest mfResourceRequest = new MFResourceRequest(
        "adapters/ResourceAdapter/WlClientTest", MFResourceRequest.GET, timeout: 15000);
    mfResourceRequest.send().then((response) {
      print("MFResourceRequest Response For Get URL Test" +
          response.responseText);
      String propertyUrl =
          "http://192.168.99.100:9080/mfp/api/adapters/ResourceAdapter/WlClientTest";

      mfResourceRequest.url.then((mfResourceRequestUrl) {
        if (propertyUrl == mfResourceRequestUrl) {
          setState(() {
            _output = "Got Response For Get URL";
          });
        } else {
          setState(() {
            _output = "MFResourceRequest Call Failed Get URL Test";
          });
        }
      }).catchError((error) {
        print("MFResourceRequest Call Failed to Get URL Error: " +
            error.errorMsg);
        setState(() {
          _output = "MFResourceRequest Call Failed to Get URL";
        });
      });
    }).catchError((error) {
      print("MFResourceRequest Call Failed For Get URL Test. Error: " +
          error.errorMsg);
      setState(() {
        _output = "MFResourceRequest Call Failed For Get URL Test";
      });
    });
  }

  Future<void> _setDeviceName() async {
    MFClient mfClient = MFClient();
    mfClient
        .setDeviceDisplayName(deviceDisplayName: "FlutterDemo")
        .then((value) {
      print("Successfully set the device display name to FlutterDemo");
      setState(() {
        _output = "Successfully set the device display name";
      });
    }).catchError((error) {
      print("Failed to set Device display name ${error.errorMsg}");
      setState(() {
        _output = "Failed to set Device display name";
      });
    });
  }

  Future<void> _getDeviceName() async {
    MFClient mfClient = MFClient();
    mfClient.getDeviceDisplayName().then((value) {
      print("Got device display name $value");
      setState(() {
        _output = "Got device display name $value";
      });
    }).catchError((error) {
      print("Failed to get device display name: ${error.errorMsg}");
      setState(() {
        _output = "Failed to get device display name";
      });
    });
  }

  void _get404() async {
    MFResourceRequest request = new MFResourceRequest(
        "/adapters/DoesNotExist/getData", MFResourceRequest.GET);
    request.send().then((response) {
      print(
          "MFResourceRequest Call Success. Response: " + response.responseText);
      setState(() {
        _output = "Got Response";
      });
    }).catchError((error) {
      print("MFResourceRequest Call Failed. Error: " + error.errorMsg);
      setState(() {
        _output = "Got 404";
      });
    });
  }

  void _serverURL() {
    MFClient mfClient = MFClient();
    mfClient
        .setServerUrl(serverUrl: '')
        .then((value) {
      print("Changed the server URL");
      mfClient.getServerUrl().then((value) {
        print("Got server URL as  $value");
        setState(() {
          _output = "serverURL success";
        });
      }).catchError((error) {
        print("Failed to get Server URL ${error.errorMsg}");
        setState(() {
          _output = "Failed to set Server URL";
        });
      });
    }).catchError((error) {
      print("Failed to set Server URL ${error.errorMsg}");
      setState(() {
        _output = "Failed to set Server URL";
      });
    });
  }

  void _pinCertificate() {
    MFClient mfClient = MFClient();
    List<String> certificateNames = new List<String>();
    certificateNames.add("Cert1");
    mfClient
        .pinTrustedCertificatesPublicKey(certificateFileNames: certificateNames)
        .then((value) {
      print("Certificate pinned successfully");
      setState(() {
        _output = "Certificate pinned successfully";
      });
    }).catchError((error) {
      print("Certificate pinning failed: ${error.errorMsg}");
      setState(() {
        _output = "Certificate pinning failed";
      });
    });
  }

  void _serverURLInvalid() {
     MFClient mfClient = MFClient();
    mfClient
        .setServerUrl(serverUrl: "")
        .then((value) {
      print("Changed the server URL");
      setState(() {
          _output = "serverURL success";
        });
    }).catchError((error) {
      print("Failed to set Server URL ${error}");
      setState(() {
        _output = "Failed to set Server URL";
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
            Text('Output:'),
            Text(
              '$_output',
              maxLines: 2,
              key: Key('output'),
              style: Theme.of(context).textTheme.headline6,
            ),
            Expanded(
              child: ListView(key: Key('test_cases'), children: <Widget>[
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('one'),
                    onPressed: _obtainToken,
                    child: Text('Obtain Access Token'),
                  )
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('obtainTokenWithEmptyScope'),
                    onPressed: _obtainTokenWithEmptyScope,
                    child: Text('Obtain Access Token With Empty Scope'),
                  )
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('obtainTokenWithValidScope'),
                    onPressed: _obtainTokenWithValidScope,
                    child: Text('Obtain Access Token With Valid Scope'),
                  )
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('obtainTokenWithInValidScope'),
                    onPressed: _obtainTokenWithInvalidScope,
                    child: Text('Obtain Access Token With Invalid Scope'),
                  )
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('two'),
                    onPressed: _login,
                    child: Text('Login'),
                  ),
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('loginWithPinCode'),
                    onPressed: _loginWithPinCode,
                    child: Text('Login with PinCode'),
                  ),
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('three'),
                    onPressed: _logout,
                    child: Text('Logout'),
                  ),
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('four'),
                    onPressed: _getBalance,
                    child: Text('Get Balance'),
                  ),
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('five'),
                    onPressed: () => _testTimeOut(15000),
                    child: Text('Get Data'),
                  ),
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('six'),
                    onPressed: () => _testTimeOut(30000),
                    child: Text('Get Data 30sec'),
                  ),
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('mFResourceRequestSendAsMap'),
                    onPressed: _mFResourceRequestSendAsMap,
                    child: Text('MFResourceRequestSend With Map'),
                  ),
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('mFResourceRequestSendAsFormParameter'),
                    onPressed: _mFResourceRequestSendAsFormParameter,
                    child: Text('MFResourceRequestSend As Form Parameter'),
                  ),
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('mFResourceRequestSendAsString'),
                    onPressed: _mFResourceRequestSendAsString,
                    child: Text('MFResourceRequestSend As String'),
                  ),
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('mFResourceRequestaddGlobalHeader'),
                    onPressed: _mFResourceRequestaddGlobalHeader,
                    child: Text('Add GlobalHeader With Custom Header'),
                  ),
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('mFResourceRequestaddGlobalHeaderAndRemove'),
                    onPressed: _mFResourceRequestaddGlobalHeaderAndRemove,
                    child: Text('Add GlobalHeader and Remove Header'),
                  ),
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('mFResourceRequestSetQueryParameter'),
                    onPressed: _mFResourceRequestSetQueryParameter,
                    child: Text('MFResourceRequest Set Query Param'),
                  ),
                ]),
                Row(children: <Widget>[
                  FlatButton(
                      key: Key('mFResourceRequestGetUrl'),
                      onPressed: _mFResourceRequestGetUrl,
                      child: Text('MFResourceRequest  Get URL'))
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('seven'),
                    onPressed: _setDeviceName,
                    child: Text('Set Device Name'),
                  ),
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('eight'),
                    onPressed: _getDeviceName,
                    child: Text('Get Device Name'),
                  ),
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('nine'),
                    onPressed: _get404,
                    child: Text('Adapter 404'),
                  ),
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('ten'),
                    onPressed: _serverURL,
                    child: Text('Server URL'),
                  ),
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('pincertificate'),
                    onPressed: _pinCertificate,
                    child: Text('Pin Certificate'),
                  ),
                ]),
                Row(children: <Widget>[
                  FlatButton(
                    key: Key('serverUrlInvalid'),
                    onPressed: _serverURLInvalid,
                    child: Text('Server URL Invalid'),
                  ),
                ]),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
