// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously

import 'dart:async';
import 'package:app_portaria/repositories/biometric.dart';
import 'package:app_portaria/repositories/shared_preferences.dart';
import 'package:app_portaria/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import '../../consts/consts_widget.dart';
import '../../consts/consts_future.dart';
import '../../consts/consts_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startLoginApp() async {
    LocalPreferences.getUserLogin().then((value) async {
      List cache = value;
      if (cache.first == null || cache.last == null) {
        ConstsFuture.navigatorPopAndPush(context, LoginScreen());
      } else if (cache.first != null || cache.last != null) {
        final auth = await LocalBiometrics.authenticate();
        final hasBiometrics = await LocalBiometrics.hasBiometric();
        if (auth && hasBiometrics) {
          return ConstsFuture.efetuaLogin(context, cache.first, cache.last);
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
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          SizedBox(
            height: size.height * 0.3,
            width: size.width * 0.6,
            child: Image.network(
              'https://a.portariaapp.com/img/logo-portaria.png',
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.03, horizontal: size.width * 0.03),
            child: ConstsWidget.buildCustomButton(
              context,
              'Autenticar Biometria',
              icon: Icons.lock_open_outlined,
              onPressed: () {
                startLoginApp();
              },
            ),
          )
        ],
      ),
    );
  }
}
