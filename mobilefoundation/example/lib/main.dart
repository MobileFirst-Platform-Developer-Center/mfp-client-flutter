import 'package:flutter/material.dart';
import './pages/BestBankRoot.dart';

void main() => runApp(RootApp());

class RootApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BestBankRoot(),
      debugShowCheckedModeBanner: false,
    );
  }
}
// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String _result = '';

//   void _obtainAccessToken() {
//     MFAuthorizationManager authManager = new MFAuthorizationManager();
//     authManager.obtainAccessToken().then((accessToken) {
//       print("Token is ----> " + accessToken.value);
//       setState(() {
//         _result = "Successfully received token";
//       });
//     }).catchError((error) {
//       print("Error in obtain access token. Reason: " + error.toString());
//       setState(() {
//         _result = "Failed to fetch token";
//       });
//     });
//   }

//   void _getServerUrl() {
//     MFClient client = new MFClient();
//     client
//         .getServerUrl()
//         .then((value) => setState(() {
//               _result = value;
//             }))
//         .catchError((onError) => setState(() {
//               _result = "Failed to get server url";
//             }));
//   }

//   void _addGlobalHeader() {
//     MFClient client = new MFClient();
//     client
//         .addGlobalHeader(headerName: "MyHeader", headerValue: "MyHeaderValue")
//         .then((value) => setState(() {
//               _result = "Success";
//             }));
//   }

//   void _removeGlobalHeader() {
//     MFClient client = new MFClient();
//     client
//         .removeGlobalHeader(headerName: "MyHeader")
//         .then((value) => setState(() {
//               _result = "Success";
//             }));
//   }

//   void _wlResourceRequestSend() {
//     MFResourceRequest request = new MFResourceRequest(
//         "adapters/ResourceAdapter/publicData", MFResourceRequest.GET);
//     request.send().then((response) {
//       print(
//           "MFResourceRequest Call Success. Response: " + response.responseText);
//       setState(() {
//         _result = "Success. \n" + response.responseText;
//       });
//     }).catchError((error) {
//       print("MFResourceRequest Call Failed. Error: " + error.errorMsg);
//       setState(() {
//         _result = "Failed";
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('IBM Mobile Foundation'),
//           ),
//           body: Container(
//             padding: EdgeInsets.all(10),
//             child: Column(children: [
//               Expanded(
//                   flex: 3,
//                   child: ListView(
//                     children: [
//                       ElevatedButton(
//                         onPressed: _obtainAccessToken,
//                         child: Text('Obtain Access Token'),
//                       ),
//                       ElevatedButton(
//                         onPressed: _getServerUrl,
//                         child: Text('Get Server URL'),
//                       ),
//                       ElevatedButton(
//                         onPressed: _addGlobalHeader,
//                         child: Text('Add Global Header'),
//                       ),
//                       ElevatedButton(
//                         onPressed: _removeGlobalHeader,
//                         child: Text('Remove Global Header'),
//                       ),
//                       ElevatedButton(
//                         onPressed: _wlResourceRequestSend,
//                         child: Text('Resource Request Send'),
//                       ),
//                     ],
//                   )),
//               Padding(padding: EdgeInsets.all(10)),
//               Expanded(child: Text('Result:')),
//               Padding(padding: EdgeInsets.all(10)),
//               Expanded(
//                   child: Text(
//                 '$_result',
//                 style: TextStyle(
//                     backgroundColor: Colors.black,
//                     color: Colors.green,
//                     fontSize: 24),
//               ))
//             ]),
//           )),
//     );
//   }
// }
