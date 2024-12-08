import 'package:flutter/material.dart';

class GlobalBackground extends StatelessWidget {
  final Widget child;

  const GlobalBackground({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Color
          Container(
            color: const Color.fromARGB(255, 145, 142, 142), // Greyish background color
          ),
          // Top Yellow Blob
          Positioned(
            top: -50,
            right: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700), // Yellow color
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          // Bottom Yellow Blob
          Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700), // Yellow color
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
           Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color:const Color.fromARGB(255, 145, 142, 142),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          // Child Widget
          Center(
            child: child,
          ),
        ],
      ),
    );
  }
}
