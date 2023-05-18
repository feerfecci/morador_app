import 'package:flutter/material.dart';
import 'consts.dart';

class ConstsWidget {
  static Widget buildTextTitle(String title,
      {textAlign, color, double size = 16}) {
    return Text(
      title,
      maxLines: 20,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget buildTextSubTitle(String title, {color}) {
    return Text(
      title,
      maxLines: 20,
      style: TextStyle(
        color: color,
        fontSize: Consts.fontSubTitulo,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  static Widget buildCustomButton(BuildContext context, String title,
      {IconData? icon,
      double? altura,
      Color? color = Consts.kButtonColor,
      required void Function()? onPressed}) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Consts.borderButton))),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.023),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              title,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: size.width * 0.015,
            ),
            icon != null
                ? Icon(size: 18, icon, color: Colors.white)
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
