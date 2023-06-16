// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:ttt/avatars.dart';
import 'package:ttt/const/const.dart';
import 'package:ttt/services/auth_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ttt/services/avatar.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final auth = AuthService();
  bool loading = false;
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  Avatar? selectedAvatar;
  List<Avatar>? avatars;

  @override
  void initState() {
    super.initState();
    fetchAvatars();
  }

  Future<void> fetchAvatars() async {
    try {
      final response = await http.get(Uri.parse('${Constants.url}/api/avatar'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> avatarData = data;
        setState(() {
          avatars = avatarData
              .map((avatarJson) => Avatar.fromJson(avatarJson))
              .toList();
          if (avatars!.isNotEmpty) {
            selectedAvatar = avatars![0];
          }
        });
      } else {
        const snackBar = SnackBar(
          content: Text('Something went wrong...'),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      const snackBar = SnackBar(
        content: Text('Something went wrong...'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xffFEB85A),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  if (avatars != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AvatarPage(
                          avatars: avatars!,
                          selectedAvatar: selectedAvatar!,
                          onSelectAvatar: (avatar) {
                            setState(() {
                              selectedAvatar = avatar;
                            });
                          },
                        ),
                      ),
                    );
                  }
                },
                child: selectedAvatar != null
                    ? CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 70,
                        backgroundImage: NetworkImage(
                            '${Constants.url}${selectedAvatar!.image}'),
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.white54,
                        radius: 70,
                        child: Text(
                          'Choose Avatar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: username,
                  validator: ValidationBuilder().minLength(3).build(),
                  decoration: const InputDecoration(
                    hintText: 'username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    fillColor: Color(0xffFFEFDA),
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: email,
                  validator: ValidationBuilder().email().build(),
                  decoration: const InputDecoration(
                    hintText: 'email id',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    fillColor: Color(0xffFFEFDA),
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  obscureText: true,
                  controller: password,
                  decoration: const InputDecoration(
                    hintText: 'password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    fillColor: Color(0xffFFEFDA),
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              SizedBox(
                width: 300,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    bool status = await auth.register(
                        email.text.trim(),
                        username.text.trim(),
                        password.text,
                        selectedAvatar!.id);
                    setState(() {
                      loading = false;
                    });
                    if (status) {
                      Navigator.pushReplacementNamed(context, '/');
                    } else {
                      
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffA25F06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Create Account",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
