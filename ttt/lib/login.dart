import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:ttt/services/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final auth = AuthService();
  bool loading = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFEB85A),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Image(
              image: AssetImage('assets/candela.png'),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                controller: email,
                validator: ValidationBuilder().email().build(),
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  fillColor: Color(0xffFFEFDA), // Change the color here
                  filled: true,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                controller: password,
                validator: ValidationBuilder().minLength(5).build(),
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  fillColor: Color(0xffFFEFDA), // Change the color here
                  filled: true,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  bool status =
                      await auth.login(email.text.trim(), password.text);
                  setState(() {
                    loading = false;
                  });
                  if (status) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacementNamed(context, '/');
                  } else {
                    const snackBar = SnackBar(
                      content: Text('Login Failed'),
                      duration: Duration(seconds: 3),
                    );
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: const Color(0xffA25F06)),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 2,
                  width: 50,
                  color: Colors.white,
                ),
                const Text("    or    "),
                Container(
                  height: 2,
                  width: 60,
                  color: Colors.white,
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 300,
              height: 53,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: const Color(0xffA25F06)),
                child: const Text(
                  'Create an Account',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
