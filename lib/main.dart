import 'dart:io';
import 'package:catalog/screens/login_screen.dart';
import 'package:catalog/screens/orders_screen.dart';
import 'package:catalog/screens/payment_screen.dart';
import 'package:catalog/splashScreen/splash_screen.dart';
import 'package:catalog/work_field/genral_labour.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'global/global.dart';
import 'screens/main_screen.dart';
import 'screens/register_screen.dart';
import "package:catalog/themeProvider/theme_provider.dart";
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCzEu2EBwTRpAYD44RtwPP6gooEOvk6bwQ",
          appId: '1:628847559209:android:361258b33e50ff8ae31238',
          messagingSenderId: '628847559209',
          projectId: 'tasktap-44f95',
          storageBucket: 'tasktap-44f95.appspot.com',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }

    runApp(const MyApp());
  }
Future<Widget> determineInitialRoute() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (userModelCurrentinfo != null ) {
    // User is signed in, return your main screen
    return MainScreen();
  } else {
    return LoginScreen();
  }
}

@override

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManPower Service',
      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}


