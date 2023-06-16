import 'package:flutter/material.dart';
import 'package:ttt/change_password.dart';
import 'package:ttt/services/auth_services.dart';
import 'gradient_bg.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final auth = AuthService();
  Map<dynamic, dynamic>? data;

  @override
  void initState() {
    super.initState();
    fetchInfo();
  }

  void fetchInfo() async {
    try {
      final res = await auth.getProfileData();
      setState(() {
        data = res;
      });
    } catch (e) {
      const snackBar = SnackBar(
        content: Text('Something went wrong...!'),
        duration: Duration(seconds: 3),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Info Page'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (data != null && data?['avatar'] != null) // Add null checks
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(data?['avatar']?['image']),
                  ),
                const SizedBox(height: 20),
                Text(
                  '${data?['username'] ?? ''}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${data?['email'] ?? ''}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ChangePasswordPage()));
                    },
                    child: const Text("Change Password")),
                if (data == null) const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
