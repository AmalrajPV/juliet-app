import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ttt/gradient_bg.dart';
import 'package:ttt/record.dart';
import 'package:ttt/services/auth_services.dart';
import 'package:ttt/services/protected_route.dart';
import 'login.dart';
import 'signup.dart';
import 'begin.dart';
import 'my_profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> addDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginPage(),
        '/profile': (context) => const ProtectedRoute(
              child: MyProfile(),
            ),
        '/register': (context) => const SignupPage(),
        '/': (context) => const ProtectedRoute(child: RecordHome()),
        '/begin': (context) => FutureBuilder(
              future: addDelay(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return const Begin();
                }
                AuthService().isLoggedIn().then((isLoggedIn) {
                  if (isLoggedIn) {
                    Navigator.of(context).pushReplacementNamed('/');
                  } else {
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                });
                return const GradientBg(
                    child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Center(
                          child: CircularProgressIndicator(),
                        )));
              },
            ),
      },
      initialRoute: '/begin',
      title: 'Text',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        // fontFamily: 'FjallaOne'
      ),
    );
  }
}
