import 'package:flutter/material.dart';
import 'package:ttt/services/auth_services.dart';

class ProtectedRoute extends StatelessWidget {
  final Widget? child;

  const ProtectedRoute({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator or any other widget while checking the login status
          return const CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data == true) {
          // User is logged in, show the child widget
          return child!;
        } else {
          // User is not logged in, navigate to the login page
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          });
          return Container();
        }
      },
    );
  }
}
