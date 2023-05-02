import 'package:flutter/material.dart';

Widget buildMyTextFormField(BuildContext context,) {
  var size = MediaQuery.of(context).size;
  return Padding(
    padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
    child: TextFormField(
      textAlign: TextAlign.start,
      textInputAction: TextInputAction.next,
      maxLines: 5,
      minLines: 1,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: size.width * 0.04),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        label: Text('data'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.black26),
        ),
      ),
    ),
  );
}
