import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../consts/consts_future.dart';
import '../../consts/consts_widget.dart';
import '../../widgets/my_box_shadow.dart';

Widget buildCardHome(BuildContext context,
    {required String title,
    int? indexOrder,
    Widget? pageRoute,
    required String iconApi,
    bool? isWhats,
    String? numberCall}) {
  var size = MediaQuery.of(context).size;

  launchNumber(number) async {
    await launchUrl(Uri.parse('tel:$number'));
  }

  return MyBoxShadow(
    child: InkWell(
      onTap: numberCall == null
          ? () {
              ConstsFuture.navigatorPageRoute(context, pageRoute!);
            }
          : () {
              if (isWhats != null) {
                launchUrl(Uri.parse('https://wa.me/+55$numberCall'),
                    mode: LaunchMode.externalApplication);
              } else {
                launchNumber(numberCall);
              }
            },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
              future: ConstsFuture.apiImageIcon(iconApi),
              builder: (context, snapshot) => SizedBox(
                  width: size.width * 0.12,
                  height: size.height * 0.075,
                  child: snapshot.data)),
          ConstsWidget.buildTextTitle(context, title),
        ],
      ),
    ),
  );
}
