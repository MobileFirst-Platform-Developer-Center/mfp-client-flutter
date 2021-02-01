import 'package:flutter/material.dart';
import 'package:mobilefoundation_example/pages/Dashboard.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  setDashboard(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
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
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.all(20),
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
                                    TextFormField(
                                      textCapitalization:
                                          TextCapitalization.words,
                                      maxLines: 1,
                                      style: TextStyle(
                                          decorationColor: Colors.white,
                                          color: Colors.white),
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                        hintText: 'User ID',
                                        hintStyle:
                                            TextStyle(color: Colors.blueGrey),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1),
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1),
                                        ),
                                      ),
                                      // ignore: missing_return
                                      validator: (value){
                                        if (value.isEmpty) {
                                          return 'Please enter a valid ID';
                                        }
                                        if (value != 'IBM') {
                                          return 'Please enter correct ID (try IBM)';
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                    ),
                                    TextFormField(
                                      maxLines: 1,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                          decorationColor: Colors.white,
                                          color: Colors.white),
                                      decoration: const InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.security,
                                            color: Colors.white,
                                          ),
                                          hintText: 'What\'s your secret?',
                                          hintStyle:
                                              TextStyle(color: Colors.blueGrey),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white, width: 1),
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white, width: 1),
                                          )),
                                      // ignore: missing_return
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter valid password';
                                        }
                                        if (value != 'password') {
                                          return 'Please enter correct \'password\'';
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                    ),
                                    RaisedButton(
                                        child: const Text('Go',
                                            style: TextStyle(fontSize: 18)),
                                        color: Colors.white,
                                        textColor: Color(0xFF333366),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        onPressed: () {
                                          // Validate will return true if the form is valid, or false if
                                          // the form is invalid.
                                          if (_formKey.currentState
                                              .validate()) {
                                            setDashboard(context);
                                          }
                                        })
                                  ],
                                )),
                          )
                        ])))));
  }
}
