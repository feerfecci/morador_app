import 'package:morador_app/screens/splash_screen/splash_screen.dart';
import 'package:morador_app/widgets/shimmer.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'consts.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';

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
      {textAlign,
      Color? color,
      double size = 18,
      TextOverflow overflow = TextOverflow.ellipsis}) {
    return Text(
      title,
      maxLines: 20,
      textAlign: textAlign,
      overflow: overflow,
      style: TextStyle(
        color: color ?? Theme.of(context).textTheme.bodyLarge!.color,
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
          color: color ?? Theme.of(context).textTheme.bodyLarge!.color,
          fontSize: SplashScreen.isSmall ? (size - 2) : size,
          fontWeight: FontWeight.normal,
          height: 1.4),
    );
  }

  static Widget buildCustomButton(BuildContext context, String title,
      {double? altura,
      Color? color = Consts.kColorAzul,
      double rowSpacing = 0,
      Color? colorText = Colors.white,
      double fontSize = 18,
      required void Function()? onPressed}) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: color, shape: StadiumBorder()),
      onPressed: onPressed,
      child: buildPadding001(
        context,
        horizontal: 0,
        vertical: SplashScreen.isSmall ? 0.035 : 0.025,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: size.height * rowSpacing,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: colorText,
                fontSize: SplashScreen.isSmall ? fontSize - 2 : fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: size.height * rowSpacing,
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildOutlinedButton(BuildContext context,
      {required String title,
      required void Function()? onPressed,
      Color colorBorder = Consts.kButtonColor,
      Color colorIcon = Consts.kButtonColor,
      Color colorFont = Consts.kButtonColor,
      Color? backgroundColor = Colors.transparent,
      double rowSpacing = 0,
      double fontSize = 18,
      double horizontal = 0.03}) {
    var size = MediaQuery.of(context).size;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        alignment: Alignment.center,
        backgroundColor: backgroundColor,
        // padding: EdgeInsets.symmetric(
        //     vertical: SplashScreen.isSmall
        //         ? size.height * 0.035
        //         : size.height * 0.023,
        //     horizontal: size.width * horizontal),
        side: BorderSide(width: size.width * 0.005, color: colorBorder),
        shape: StadiumBorder(),
      ),
      onPressed: onPressed,
      child: buildPadding001(
        context,
        horizontal: 0,
        vertical: SplashScreen.isSmall ? 0.035 : 0.025,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width * rowSpacing,
            ),
            Text(
              title,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: colorFont,
                fontSize: SplashScreen.isSmall ? fontSize - 2 : fontSize,
                // fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: size.width * rowSpacing,
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildLoadingButton(BuildContext context,
      {required void Function()? onPressed,
      required bool isLoading,
      required String title,
      double rowSpacing = 0,
      double horizontal = 0,
      double fontSize = 18,
      Color color = Consts.kColorAzul}) {
    var size = MediaQuery.of(context).size;

    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            // padding: EdgeInsets.symmetric(
            //     vertical: SplashScreen.isSmall
            //         ? size.height * 0.035
            //         : size.height * 0.025,
            //     horizontal: size.width * horizontal),
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Consts.borderButton))),
        onPressed: onPressed,
        child: buildPadding001(context,
            horizontal: 0,
            vertical: SplashScreen.isSmall ? 0.035 : 0.025,
            child: !isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width * rowSpacing,
                      ),
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              SplashScreen.isSmall ? fontSize - 2 : fontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: size.width * rowSpacing,
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
                  )));
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
      double? width,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center}) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        SizedBox(
          width: width,
          child: buildTextTitle(context, title),
        ),
        Checkbox(
          // shape:
          //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          value: isChecked,
          onChanged: onChanged,
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

  static Widget buildCachedImage(BuildContext context,
      {required String iconApi,
      double? width,
      double? height,
      String? title,
      bool meuWidth = false}) {
    var size = MediaQuery.of(context).size;
    // bool isLoading = true;
    return CachedNetworkImage(
      imageUrl: iconApi,
      height: !meuWidth
          ? height != null
              ? size.height * height
              : null
          : height,
      width: !meuWidth
          ? width != null
              ? size.width * width
              : null
          : width,
      fit: BoxFit.fill,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholder: (context, url) => ShimmerWidget(
          height:
              SplashScreen.isSmall ? size.height * 0.06 : size.height * 0.068,
          width: size.width * 0.15),
      errorWidget: (context, url, error) => Image.asset('ico-error.png'),
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
        iconColor: Theme.of(context).textTheme.bodyLarge!.color,
        subtitle: subtitle == null
            ? null
            : titleCenter
                ? Center(child: subtitle)
                : subtitle,
        expandedCrossAxisAlignment: expandedCrossAxisAlignment,
        childrenPadding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
        expandedAlignment: expandedAlignment,
        tilePadding: EdgeInsets.only(left: size.width * 0.02),
        title: title,
        children: children,
      ),
    );
  }

  static Widget buildBadge(BuildContext context,
      {required int title,
      required bool showBadge,
      required Widget? child,
      BadgePosition? position}) {
    return badges.Badge(
        showBadge: showBadge,
        badgeAnimation: badges.BadgeAnimation.fade(toAnimate: false),
        badgeContent: Text(
          title > 99
              ? '+99'
              : title == 0
                  ? ''
                  : title.toString(),
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: title < 99
                  ? SplashScreen.isSmall
                      ? 12
                      : 16
                  : SplashScreen.isSmall
                      ? 10
                      : 14),
        ),
        position: position,
        badgeStyle: badges.BadgeStyle(
          badgeColor: Consts.kColorRed,
        ),
        child: child);
  }

  static Widget buildCamposObrigatorios(BuildContext context) {
    return ConstsWidget.buildPadding001(
      context,
      child: ConstsWidget.buildTextTitle(context, '(*) Campos Obrigatórios',
          color: Consts.kColorRed),
    );
  }

  static TextSpan builRichTextTitle(BuildContext context,
      {required String textBold, Color? color}) {
    return TextSpan(
        text: textBold,
        style: TextStyle(
          color: color ?? Theme.of(context).textTheme.bodyLarge!.color,

          // Theme.of(context)
          //     .colorScheme
          //     .primary,
          overflow: TextOverflow.ellipsis,
          fontSize: SplashScreen.isSmall ? 16 : 18,
          fontWeight: FontWeight.bold,
        ));
  }

  static TextSpan builRichTextSubTitle(BuildContext context,
      {required String subTitle, Color? color}) {
    return TextSpan(
        text: subTitle,
        style: TextStyle(
            color: color ?? Theme.of(context).textTheme.bodyLarge!.color,
            height: 1.5,
            overflow: TextOverflow.ellipsis,
            fontSize: SplashScreen.isSmall ? 14 : 16));
  }

  static Widget buildTextExplicaSenha(BuildContext context,
      {bool isAlertDialog = false, textAlign = TextAlign.center}) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
          style: TextStyle(color: Colors.red, fontSize: 60),
          children: [
            ConstsWidget.builRichTextSubTitle(
              context,
              //  color: Colors.red,
              subTitle: 'Para unificar todas suas unidades no login atual ',
            ),
            ConstsWidget.builRichTextTitle(context,
                color: Colors.red, textBold: InfosMorador.login),
            ConstsWidget.builRichTextSubTitle(context,
                //  color: Colors.red,
                subTitle: ', atualize sua senha de acesso'),
            if (!isAlertDialog)
              ConstsWidget.builRichTextSubTitle(context,
                  //  color: Colors.red,
                  subTitle: ' selecione a opção '),
            if (!isAlertDialog)
              ConstsWidget.builRichTextTitle(context,
                  color: Colors.red, textBold: 'Adicionar Meus Condomínios'),
            ConstsWidget.builRichTextSubTitle(context,
                //  color: Colors.red,
                subTitle: ' e, clique no botão '),
            if (!isAlertDialog)
              ConstsWidget.builRichTextTitle(context,
                  color: Colors.red, textBold: 'Salvar'),
            if (!isAlertDialog)
              ConstsWidget.builRichTextSubTitle(context,
                  //  color: Colors.red,
                  subTitle:
                      '. Se deseja alterar a senha e manter separados os acessos a cada unidade no Portaria App, preencha os campos abaixo e clique em '),
            ConstsWidget.builRichTextTitle(context,
                color: Colors.red, textBold: 'Salvar'),
          ]),
    );
  }

  static Widget buildSeparated(BuildContext context, {double vertical = 0.02}) {
    return ConstsWidget.buildPadding001(
      context,
      vertical: vertical,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              width: 1, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
