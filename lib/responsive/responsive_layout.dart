import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout(
      {super.key, required this.desktop, required this.mobile, required this.tablet});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth <= 600) {
        return mobile;
      } else if (constraints.maxWidth > 600 && constraints.maxWidth <= 1284) {
        return tablet;
      } else {
        return desktop;
      }
    });
  }
}
