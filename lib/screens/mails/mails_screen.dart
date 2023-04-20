// ignore_for_file: prefer_final_fields

import 'package:app_portaria/widgets/header.dart';
import 'package:flutter/material.dart';

class MailScreen extends StatefulWidget {
  const MailScreen({super.key});

  @override
  State<MailScreen> createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen> {
  double _margin = 0;
  double _opacity = 1;
  double _width = 200;
  Color _color = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red,
      ),
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        margin: EdgeInsets.all(_margin),
        width: _width,
        color: _color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _margin = 50;
                  });
                },
                child: Text('animatedmargin')),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _color = Colors.red;
                  });
                },
                child: Text('animatedcolor')),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _width = 400;
                  });
                },
                child: Text('animatedwidth')),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _opacity = 0;
                  });
                },
                child: Text('animatedopacity')),
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(seconds: 1),
              child: Text(
                'hide me',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
