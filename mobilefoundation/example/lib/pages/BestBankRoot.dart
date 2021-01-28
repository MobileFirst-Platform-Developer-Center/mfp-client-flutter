import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobilefoundation_example/pages/Login.dart';
import 'package:mobilefoundation_example/widgets/WavyClipper.dart';
import 'package:mobilefoundation_example/widgets/RoundedButton.dart';

class BestBankRoot extends StatelessWidget {
  setLogin(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => Login()));
  }

  Widget _getBody(BuildContext context) {
    Widget body = Stack(
      children: <Widget>[
        ClipPath(
            clipper: WavyClipper(),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF333366),
              ),
              height: MediaQuery.of(context).size.height * 0.45,
            )),
        Center(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)),
              Text(
                'Best Bank',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              Text(
                'powered by IBM Mobile Foundation',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              )
            ],
          ),
        )
      ],
    );
    return body;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        _getBody(context),
        Column(
          children: <Widget>[
            RoundedButton(
                title: 'Login',
                padding: 20,
                margin: 50,
                onPress: () => setLogin(context)),
          ],
        )
      ],
    ));
  }
}
