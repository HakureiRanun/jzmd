import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget{
  BasePage({Key key, this.title, this.child});
  final String title;
  final Widget child;
  @override
  State<StatefulWidget> createState() {
  return BasePageState();
  }
}

class BasePageState extends State<BasePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: widget.child,
    );
  }
}