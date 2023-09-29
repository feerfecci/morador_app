// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:app_portaria/repositories/biometric.dart';
import 'package:app_portaria/repositories/shared_preferences.dart';
import 'package:app_portaria/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import '../../consts/consts_widget.dart';
import '../../consts/consts_future.dart';

class SplashScreen extends StatefulWidget {
  static bool isSmall = false;
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool load = false;
  startLoginApp() async {
    LocalPreferences.getUserLogin().then((value) async {
      String? idUnidade;
      LocalPreferences.getIdLogin().then((getIdUnidade) {
        setState(() {
          idUnidade = getIdUnidade;
        });
      });

      if (value[0] == null || value[1] == null) {
        return ConstsFuture.navigatorPopAndPush(context, LoginScreen());
      } else if (value[0] != null || value[1] != null) {
        setState(() {
          load = true;
        });
        final auth = await LocalBiometrics.authenticate();
        final hasBiometrics = await LocalBiometrics.hasBiometric();

        if (!hasBiometrics) {
          return ConstsFuture.efetuaLogin(context, value[0], value[1],
              reLogin: idUnidade == null ? false : true);
        } else if (hasBiometrics && auth) {
          return ConstsFuture.efetuaLogin(context, value[0], value[1],
              reLogin: idUnidade == null ? false : true);
        }
      } else {
        return ConstsFuture.navigatorPopAndPush(context, LoginScreen());
      }
    });
  }

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      startLoginApp();
    });
    // NotificationServiceCorresp().initNotificationCorresp();
    // NotificationServiceDelivery().initNotificationDelivery();
    // NotificationServiceVisitas().initNotificationVisitas();
    // NotificationAvisos().initNotificationAvisos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SplashScreen.isSmall = size.width <= 350
        ? true
        : Platform.isIOS
            ? true
            : false;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          SizedBox(
            height: size.height * 0.2,
            width: size.width * 0.6,
            child: Image.network(
              'https://a.portariaapp.com/img/logo_azul.png',
            ),
          ),
          Spacer(),
          Row(),
          if (load)
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.03, horizontal: size.width * 0.03),
              child: ConstsWidget.buildCustomButton(
                context,
                'Autenticar Biometria',
                // icon: Icons.lock_open_outlined,

                onPressed: () {
                  startLoginApp();
                },
              ),
            ),
        ],
      ),
    );
  }
}
