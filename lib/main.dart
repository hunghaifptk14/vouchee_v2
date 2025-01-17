import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vouchee/core/configs/theme/app_theme.dart';
import 'package:vouchee/presentation/pages/login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Message received: ${message.notification?.title}');
    // TopSnackbar.show(context, message);
  });
  runApp(Vouchee());
}

class Vouchee extends StatelessWidget {
  const Vouchee({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
