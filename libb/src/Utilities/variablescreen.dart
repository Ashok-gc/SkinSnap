import 'package:flutter/material.dart';

class VariableScreens extends StatefulWidget {
  const VariableScreens({super.key});

  @override
  State<VariableScreens> createState() => _VariableScreensState();
}

class _VariableScreensState extends State<VariableScreens> {
  String myname = "skin";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(myname),
      ),
    );
  }
}
