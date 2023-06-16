// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'gradient_bg.dart';

class Begin extends StatefulWidget {
  const Begin({Key? key}) : super(key: key);

  @override
  _BeginState createState() => _BeginState();
}

class _BeginState extends State<Begin> {
  @override
  Widget build(BuildContext context) {
    return const GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60,
                    width: 30,
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Let's",
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        // fontFamily: 'FjallaOne'
                      ),
                    ),
                    Text(
                      "Begin...",
                      style: TextStyle(
                          fontSize: 45, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      child: Image(
                        width: 350,
                        height: 350,
                        image: AssetImage('assets/penguin.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
