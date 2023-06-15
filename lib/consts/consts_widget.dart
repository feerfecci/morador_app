import 'package:flutter/material.dart';
import 'consts.dart';

class ConstsWidget {
  static Widget buildTextTitle(BuildContext context, String title,
      {textAlign, Color? color, double size = 16}) {
    return Text(
      title,
      maxLines: 20,
      textAlign: textAlign,
      style: TextStyle(
        color: color ?? Theme.of(context).colorScheme.primary,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget buildTextSubTitle(BuildContext context, String title,
      {Color? color}) {
    return Text(
      title,
      maxLines: 20,
      style: TextStyle(
        color: color ?? Theme.of(context).colorScheme.primary,
        fontSize: Consts.fontSubTitulo,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  static Widget buildCustomButton(BuildContext context, String title,
      {IconData? icon,
      double? altura,
      Color? color = Consts.kColorApp,
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

  static Widget buildLoadingButton(BuildContext context,
      {required void Function()? onPressed,
      required bool isLoading,
      required String title,
      Color color = Consts.kColorApp}) {
    var size = MediaQuery.of(context).size;

    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Consts.borderButton))),
        onPressed: onPressed,
        child: isLoading == false
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: size.height * 0.020,
                    width: size.width * 0.05,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ],
              ));
  }

  static Widget buildAtivoInativo(
    BuildContext context,
    bool ativo,
  ) {
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: ativo ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(size.height * 0.01),
        child: buildTextTitle(context, ativo ? 'Ativo' : 'Inativo'),
      ),
    );
  }
}
