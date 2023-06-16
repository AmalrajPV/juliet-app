// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:http/http.dart' as http;

import 'package:ttt/const/const.dart';
import 'package:ttt/services/auth_services.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFEB85A),
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                  controller: _oldPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Old Password',
                  ),
                  obscureText: true,
                  validator: ValidationBuilder().required().build()),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                  ),
                  obscureText: true,
                  validator: ValidationBuilder().required().build()),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _changePassword();
                    }
                  },
                  child: const Text('Change Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changePassword() async {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final token = await AuthService().getToken();

    final response = await http
        .post(Uri.parse('${Constants.url}/api/change-password'), body: {
      'old_password': oldPassword,
      'new_password': newPassword,
    }, headers: {
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200) {
      const snackBar = SnackBar(
        content: Text('Password changed successfuly'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    } else {
      const snackBar = SnackBar(
        content: Text('Something went wrong ...!'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
