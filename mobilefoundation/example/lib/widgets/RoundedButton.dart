import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final double padding;
  final double margin;
  final Function onPress;

  RoundedButton({this.title, this.padding, this.margin, this.onPress});
  @override
  Widget build(BuildContext context) {
    return new InkWell(
        onTap: () {
          onPress();
        },
        child: Container(
          padding: EdgeInsets.all(padding),
          margin: EdgeInsets.all(margin),
          decoration: BoxDecoration(
            // Box decoration takes a gradient
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: new Offset(5.0, 10.0),
              )
            ],
            gradient: RadialGradient(
              // Where the linear gradient begins and ends
              center: const Alignment(0.2, 0.2), // near the top right
              radius: 2,
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                Color(0xFF333366),
                Color(0xFF272d5a),
                Color(0xFF1b264e),
              ],
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(color: Colors.white,fontSize: 20),
            ),
          ),
        ));
  }
}
