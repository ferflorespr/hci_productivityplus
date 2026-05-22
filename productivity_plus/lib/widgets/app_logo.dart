import 'package:flutter/material.dart';

/// The Productivity+ brand logo. One widget so the asset path lives in a
/// single place — swap the file or rename it here and every screen updates.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.height = 96});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/prod_plus_logo.png',
      height: height,
      semanticLabel: 'Productivity Plus logo',
      fit: BoxFit.contain,
    );
  }
}
