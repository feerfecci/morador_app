import 'package:app_portaria/screens/splash_screen/splash_screen.dart';
import 'package:app_portaria/widgets/shimmer.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'consts.dart';
import 'consts_future.dart';
import 'package:badges/badges.dart' as badges;

class ConstsWidget {
  static Widget buildPadding001(BuildContext context,
      {double horizontal = 0, double vertical = 0.01, required Widget? child}) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height * vertical,
        horizontal: size.width * horizontal,
      ),
      child: child,
    );
  }

  static Widget buildTextTitle(BuildContext context, String title,
      {textAlign, Color? color, double size = 18, TextOverflow? overflow}) {
    return Text(
      title,
      maxLines: 20,
      textAlign: textAlign,
      overflow: overflow,
      style: TextStyle(
        color: color ?? Theme.of(context).colorScheme.primary,
        fontSize: SplashScreen.isSmall ? (size - 4) : size,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget buildTextSubTitle(BuildContext context, String title,
      {Color? color, double size = 16, textAlign}) {
    return Text(
      title,
      maxLines: 20,
      textAlign: textAlign,
      style: TextStyle(
          color: color ?? Theme.of(context).colorScheme.primary,
          fontSize: SplashScreen.isSmall ? (size - 4) : size,
          fontWeight: FontWeight.normal,
          height: 1.4),
    );
  }

  static Widget buildCustomButton(BuildContext context, String title,
      {IconData? icon,
      double? altura,
      Color? color = Consts.kColorAzul,
      required void Function()? onPressed}) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Consts.borderButton))),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.025),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (icon != null)
              Row(
                children: [
                  Icon(
                      size: SplashScreen.isSmall ? 20 : 24,
                      icon,
                      color: Colors.white),
                  SizedBox(
                    width: size.width * 0.015,
                  ),
                ],
              ),
            Text(
              title,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontSize: SplashScreen.isSmall ? 14 : 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildOutlinedButton(BuildContext context,
      {required String title,
      required void Function()? onPressed,
      Color color = Consts.kButtonColor,
      Color? backgroundColor = Colors.transparent,
      double fontSize = 18,
      IconData? icon,
      double vertical = 0.021,
      double horizontal = 0.024}) {
    var size = MediaQuery.of(context).size;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        alignment: Alignment.center,
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(
            vertical: size.height * vertical,
            horizontal: size.width * horizontal),
        side: BorderSide(width: size.width * 0.005, color: Colors.blue),
        shape: StadiumBorder(),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(size: SplashScreen.isSmall ? 20 : 24, icon, color: color),
          if (icon != null)
            SizedBox(
              width: size.width * 0.015,
            ),
          ConstsWidget.buildTextSubTitle(
            context,
            title,
            size: SplashScreen.isSmall ? fontSize - 2 : fontSize,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  static Widget buildLoadingButton(BuildContext context,
      {required void Function()? onPressed,
      required bool isLoading,
      required String title,
      double horizontal = 0,
      Color color = Consts.kColorAzul}) {
    var size = MediaQuery.of(context).size;

    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.025,
                horizontal: size.width * horizontal),
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Consts.borderButton))),
        onPressed: onPressed,
        child: !isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: SplashScreen.isSmall ? 16 : 18,
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
                    height: size.height * 0.025,
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
        child: buildTextTitle(context, ativo ? 'Ativo' : 'Inativo',
            color: Colors.white),
      ),
    );
  }

  static Widget buildCheckBox(BuildContext context,
      {required bool isChecked,
      required void Function(bool? value)? onChanged,
      required String title,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center}) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        buildTextTitle(context, title),
        Transform.scale(
          scale: 1.3,
          child: Checkbox(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            value: isChecked,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  static Widget buildRefreshIndicator(BuildContext context,
      {required Widget child, required Future<void> Function() onRefresh}) {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
        strokeWidth: 2,
        backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
        color: Theme.of(context).canvasColor,
        displacement: size.height * 0.1,
        onRefresh: onRefresh,
        child: child);
  }

  static Widget buildFutureImage(BuildContext context,
      {required String iconApi, double? width, double? height, String? title}) {
    var size = MediaQuery.of(context).size;
    bool isLoading = true;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        FutureBuilder(
            future: ConstsFuture.apiImageIcon(iconApi),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ShimmerWidget(
                    height: SplashScreen.isSmall
                        ? size.height * 0.08
                        : size.height * 0.068,
                    width: SplashScreen.isSmall
                        ? size.width * 0.14
                        : size.width * 0.15);
              } else if (snapshot.hasData) {
                isLoading == false;
                return SizedBox(
                  width: width != null ? size.width * width : null,
                  height: height != null ? size.height * height : null,
                  child: Image.network(
                    iconApi,
                    fit: BoxFit.cover,
                  ),
                );
              } else {
                isLoading == false;
                return Image.asset('assets/ico-error.png');
              }
            }),
        // if (title != null)
        //   Container(
        //     decoration: BoxDecoration(
        //       color: Colors.grey.withOpacity(0.5),
        //     ),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         ConstsWidget.buildPadding001(
        //           context,
        //           child: ConstsWidget.buildTextTitle(
        //             context,
        //             title,
        //             size: 20,
        //             color: Colors.white,
        //           ),
        //         ),
        //       ],
        //     ),
        //   )
      ],
    );
  }

  static Widget buildExpandedTile(BuildContext context,
      {required Widget title,
      bool titleCenter = true,
      Widget? subtitle,
      required List<Widget> children,
      void Function(bool)? onExpansionChanged,
      CrossAxisAlignment? expandedCrossAxisAlignment,
      Alignment? expandedAlignment}) {
    var size = MediaQuery.of(context).size;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        // trailing: Icon(Icons.arrow_downward),
        onExpansionChanged: onExpansionChanged,
        subtitle: subtitle == null
            ? null
            : titleCenter
                ? Center(child: subtitle)
                : subtitle,
        expandedCrossAxisAlignment: expandedCrossAxisAlignment,
        childrenPadding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
        expandedAlignment: expandedAlignment,
        title: titleCenter ? Center(child: title) : title,
        children: children,
      ),
    );
  }

  static Widget buildBadge(BuildContext context,
      {required String title,
      required bool showBadge,
      required Widget? child,
      BadgePosition? position}) {
    return badges.Badge(
        showBadge: showBadge,
        badgeAnimation: badges.BadgeAnimation.fade(toAnimate: false),
        badgeContent: Text(
          title,
          style: TextStyle(
              color: Theme.of(context).cardColor, fontWeight: FontWeight.bold),
        ),
        position: position,
        badgeStyle: badges.BadgeStyle(
          badgeColor: Consts.kColorRed,
        ),
        child: child);
  }
}
