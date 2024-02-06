import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';

class BecomeATradesManScreen extends StatefulWidget {
  const BecomeATradesManScreen({super.key});

  @override
  State<BecomeATradesManScreen> createState() => _BecomeATradesManScreenState();
}

class _BecomeATradesManScreenState extends State<BecomeATradesManScreen> {
  final db = FirebaseFirestore.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  late String displayName;
  late String phoneNumber;
  late String email;
  late String skill;
  late String skillDescription;

  String? selectedTrade;
  bool isLoaded = false;
  List? tradesList = [];
  File? image;

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      }
    });
  }

  final ImagePicker picker = ImagePicker();

  void getTrades() async {
    DocumentSnapshot snapshot =
        await db.collection('tradeslist').doc('listoftrades').get();
    var data = snapshot.data() as Map;
    tradesList = data['trades'] as List<dynamic>;
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    getTrades();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: isLoaded
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const Text(
                      "Unlock the potential of your skills!",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Join now to turn your expertise into a rewarding income stream',
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey[300],
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, color: Colors.grey[600]),
                        onPressed: () {
                          getImageFromGallery();
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'First Name'),
                      validator: (value) => value!.isEmpty
                          ? 'Please enter your first name'
                          : null,
                      onSaved: (value) => firstName = value!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Last name'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your last name' : null,
                      onSaved: (value) => lastName = value!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'Display Name'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a display name' : null,
                      onSaved: (value) => displayName = value!,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration:
                          const InputDecoration(hintText: 'Select a skill'),
                      elevation: 10,
                      isExpanded: true,
                      value: selectedTrade,
                      items: tradesList?.map((e) {
                        return DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedTrade = value!;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a skill' : null,
                      onSaved: (value) => skill = value!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText:
                              'Enter a description of your skill for people to see'),
                      validator: (value) => value!.isEmpty
                          ? 'Please enter a skill description'
                          : null,
                      onSaved: (value) => skillDescription = value!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'Add a phone number'),
                      keyboardType: TextInputType.phone,
                      validator: (value) => value!.isEmpty
                          ? 'Please enter your phone number'
                          : null,
                      onSaved: (value) => phoneNumber = value!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'Email address'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value!.isEmpty
                          ? 'Please enter your email address'
                          : null,
                      onSaved: (value) => email = value!,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child:
                          const Text('Sign up', style: TextStyle(fontSize: 18)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // TODO: Implement sign up logic
                          print(firstName +
                              lastName +
                              displayName +
                              selectedTrade! +
                              skillDescription +
                              phoneNumber +
                              email);
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: LoadingIndicator(
              indicatorType: Indicator.ballClipRotatePulse,
              colors: [Colors.black, Colors.green],
              strokeWidth: 1,
            )),
    );
  }
}
