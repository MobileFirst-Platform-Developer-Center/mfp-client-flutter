import 'package:flutter/material.dart';
import 'package:mobilefoundation/resource_request.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() {
    return DashboardState();
  }
}

class DashboardState extends State<Dashboard> {
  final _formKey = GlobalKey<FormState>();
  String _balance = "XXXXX";

  void _fetchBalance() {
    // https://demo2202897.mockable.io/getBalance
    MFResourceRequest request = new MFResourceRequest(
        "https://demo2202897.mockable.io/getBalance", MFResourceRequest.GET);
    request.send().then((response) {
      print(
          "MFResourceRequest Call Success. Response: " + response.responseText);
      setState(() {
        _balance = response.responseJSON["balance"];
      });
    }).catchError((error) {
      print("MFResourceRequest Call Failed. Error: " + error.toString());
      setState(() {
        _balance = "XXXXX";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Builder(
            builder: (context) => SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 40),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "My Account",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            color: Color(0xFF333366),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            elevation: 5,
                            child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Account #:\t\t",
                                          style: TextStyle(
                                              decorationColor: Colors.white,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "1234567890",
                                          style: TextStyle(
                                              decorationColor: Colors.white,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "IFSC Code:\t\t",
                                          style: TextStyle(
                                              decorationColor: Colors.white,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "BANK0000123",
                                          style: TextStyle(
                                              decorationColor: Colors.white,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Balance:\t\t",
                                          style: TextStyle(
                                              decorationColor: Colors.white,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          _balance,
                                          style: TextStyle(
                                              decorationColor: Colors.white,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                    ),
                                    RaisedButton(
                                        child: const Text('Fetch Balance',
                                            style: TextStyle(fontSize: 18)),
                                        color: Colors.white,
                                        textColor: Color(0xFF333366),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        onPressed: () {
                                          _fetchBalance();
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Updated account balance!')));
                                        })
                                  ],
                                )),
                          )
                        ])))));
  }
}
