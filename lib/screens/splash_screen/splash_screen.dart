// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously

import 'dart:async';

import 'package:app_portaria/repositories/biometric.dart';
import 'package:app_portaria/repositories/shared_preferences.dart';
import 'package:app_portaria/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

import '../../consts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startLoginApp() async {
    LocalPreferences.getUserLogin().then((value) async {
      Map<String, dynamic> cache = value;
      if (cache.values.first == null || cache.values.last == null) {
        Consts.navigatorPageRoute(context, LoginScreen());
      } else if ((cache.values.first != null || cache.values.last != null) &&
          cache.values.last == UserLogin.password) {
        Future authentic() async {
          final auth = await LocalBiometrics.authenticate();
          final hasBiometrics = await LocalBiometrics.hasBiometric();
          if (auth && hasBiometrics) {
            return UserLogin.efetuaLogin(
                context, cache.values.first, cache.values.last);
          }
        }

        return authentic();
      } else {
        return Consts.navigatorPageRoute(context, LoginScreen());
      }
    });
  }

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      startLoginApp();
    });
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
                'https://www.portariaapp.com/wp-content/uploads/2023/03/portria.png'),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.03, horizontal: size.width * 0.03),
            child: Consts.buildCustomButton(
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
