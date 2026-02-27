import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class hola extends StatelessWidget {
  const hola({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            Text("pen"),
            Text("cil"),
          ]
      ),
    );
  }
}
