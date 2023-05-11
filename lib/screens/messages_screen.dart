import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Inbox",
          style: GoogleFonts.inter(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
