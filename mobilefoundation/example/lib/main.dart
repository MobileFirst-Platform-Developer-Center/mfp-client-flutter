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