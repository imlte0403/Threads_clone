import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String logoPath;

  const CustomAppBar({super.key, required this.logoPath});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      floating: true,
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Image.asset(logoPath, height: 32),
    );
  }
}
