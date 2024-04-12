import 'package:flutter/material.dart';

class ListButton extends StatelessWidget {
  VoidCallback tapped;
  IconData icon;
  String title;
  String subTitle;

  ListButton({
    required this.tapped,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tapped,
      child: ListTile(
        dense: true,
        isThreeLine: true,
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subTitle),
      ),
    );
  }
}
