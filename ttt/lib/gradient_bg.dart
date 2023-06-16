import 'package:flutter/material.dart';

class GradientBg extends StatefulWidget {
  const GradientBg({super.key, required this.child});
  final Widget child;

  @override
  State<GradientBg> createState() => _GradientBgState();
}

class _GradientBgState extends State<GradientBg> {
  List<Color> c1 = const [
    Color.fromARGB(255, 255, 255, 255),
    Color.fromARGB(255, 254, 154, 90)
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: c1,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: widget.child);
  }
}
