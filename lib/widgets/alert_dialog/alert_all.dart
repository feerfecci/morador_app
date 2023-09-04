import 'package:flutter/material.dart';

showDialogAll(BuildContext context,
    {required String title,
    required List<Widget> children,
    bool barrierDismissible = false}) {
  return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialogAll(
          title: title,
          children: children,
        );
      });
}

class AlertDialogAll extends StatefulWidget {
  final String title;
  final List<Widget> children;
  const AlertDialogAll(
      {required this.title, required this.children, super.key});

  @override
  State<AlertDialogAll> createState() => _AlertDialogAllState();
}

class _AlertDialogAllState extends State<AlertDialogAll> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      title: Center(child: Text(widget.title)),
      content: SizedBox(
        width: size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.children,
        ),
      ),
    );
  }
}
