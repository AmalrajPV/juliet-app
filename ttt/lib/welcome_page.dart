import 'package:flutter/material.dart';
import 'gradient_bg.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

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
                  SizedBox(
                    child: Image(
                      width: 40,
                      height: 40,
                      image: AssetImage('assets/candela.png'),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "TALK",
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        // fontFamily: 'FjallaOne'
                      ),
                    ),
                    Text(
                      "-",
                      style:
                          TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "TEXT",
                      style:
                          TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
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
