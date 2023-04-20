import 'package:app_portaria/repositories/shared_preferences.dart';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'itens_bottom.dart';

class Consts {
  static double fontTitulo = 16;
  static double fontSubTitulo = 14;
  static double borderButton = 60;

  static const kBackPageColor = Color.fromARGB(255, 245, 245, 255);
  static const kButtonColor = Color.fromARGB(255, 0, 134, 252);

  static const String iconApi = 'https://escritorioapp.com/img/ico-';

  static Future navigatorPageRoute(BuildContext context, Widget route) {
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => route,
    ));
  }

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
        fontSize: fontSubTitulo,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  static Widget buildCustomButton(BuildContext context, String title,
      {IconData? icon,
      double? altura,
      Color? color = kButtonColor,
      required void Function()? onPressed}) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderButton))),
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

class UserLogin {
  static String email = "fernandofecci@hotmail.com";
  static String password = '123mudar';

  static efetuaLogin(context, String emailUser, String passwordUser) {
    if (emailUser == email && passwordUser == password) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ItensBottom(
            currentTab: 0,
          ),
        ),
      );
    } else {
      buildCustomSnackBar(
        context,
        'Login Errado',
        'Tente Verificar os dados preenchidos',
      );
      LocalPreferences.removeUserLogin();
    }
  }
}
