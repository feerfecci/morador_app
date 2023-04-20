import 'package:flutter/material.dart';

import '../../consts.dart';

class MyBoxShadow extends StatefulWidget {
  final dynamic child;
  const MyBoxShadow({required this.child, super.key});

  @override
  State<MyBoxShadow> createState() => MyBoxShadowState();
}

class MyBoxShadowState extends State<MyBoxShadow> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(size.height * 0.01),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(5, 5), // changes position of shadow
              ),
            ],
            // border: Border.all(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(16)),
        child: widget.child,
      ),
    );
  }
}
