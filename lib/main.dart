import 'package:app_portaria/itens_bottom.dart';
import 'package:app_portaria/repositories/theme_provider.dart';
import 'package:app_portaria/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'repositories/themes_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // NotificationServiceDelivery().initNotificationDelivery();
  // NotificationServiceVisitas().initNotificationVisitas();
  // NotificationDetailsAvisos().initNotificationAvisos();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          themeMode: themeProvider.themeMode,
          theme: themeLight(context),
          darkTheme: themeDark(context),
          home: SplashScreen(),
          builder: (context, child) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                child: child!);
          },
        );
      },
    );
  }
}
