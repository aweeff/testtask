import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final double height;
  final Function()? onTap;
  const SquareTile(
      {super.key, required this.imagePath, required this.height, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Image.asset(
          imagePath,
          height: height,
        ),
      ),
    );
  }
}
