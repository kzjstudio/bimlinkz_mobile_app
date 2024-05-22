import 'dart:io';

import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/landing_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';

class ContractorForm extends StatefulWidget {
  @override
  _ContractorFormState createState() => _ContractorFormState();
}

class _ContractorFormState extends State<ContractorForm> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  bool _isPrivacyPolicyChecked = false;
  List<String> jobCategories = [];
  String selectedSkill = "";
  var isLoading = false.obs;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  String _uploadUrl = '';

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController telNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController yearsExperience = TextEditingController();

  Future<void> _pickImage() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Image Source'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: Text('Camera'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: Text('Gallery'),
          ),
        ],
      ),
    );

    if (source != null) {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef = storageRef.child(
          "user images/ ${AuthController.instance.auth.currentUser!.uid}/ ${DateTime.now().toIso8601String()}.jpg");

      await imagesRef.putFile(_image!);
      final url = await imagesRef.getDownloadURL();

      setState(() {
        _uploadUrl = url;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload successful!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> getJobCategories() async {
    try {
      QuerySnapshot snapshot = await db.collection('categories').get();
      setState(() {
        jobCategories =
            snapshot.docs.map((doc) => doc['id'].toString()).toList();
      });
    } catch (e) {
      print('Error fetching job titles: $e');
    }
  }

  @override
  void initState() {
    getJobCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Become a Contractor'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  'Welcome! Please fill out the form below to register as a contractor on our platform. '
                  'We value your privacy and ensure that your information will be kept secure.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.grey[200],
                          backgroundImage:
                              _image != null ? FileImage(_image!) : null,
                          child: _image == null
                              ? Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                  color: Colors.grey[800],
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField('First Name', 'first Name', firstName),
                _buildTextField('Last Name', 'Last Name', lastName),
                _buildTextField('Phone', 'phone', telNumber,
                    keyboardType: TextInputType.phone),
                _buildDropdown('Skill or trade', selectedSkill, jobCategories),
                _buildTextField(
                    'Years of Experience', 'experience', yearsExperience,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _isPrivacyPolicyChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isPrivacyPolicyChecked = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Privacy Policy'),
                              content: const SingleChildScrollView(
                                child: Text(
                                  'Your privacy policy content goes here. '
                                  'Make sure to include all necessary information regarding user data and privacy.',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text(
                          'I agree to the Privacy Policy',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(
                  () => ElevatedButton(
                    onPressed: isLoading.isFalse ? () => _submitForm() : null,
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Submit'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String key, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        onSaved: (value) {
          _formData[key] = value;
        },
      ),
    );
  }

  Widget _buildDropdown(String label, String key, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        items: options.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option),
          );
        }).toList(),
        validator: (value) {
          if (value == null) {
            return 'Please select $label';
          }
          return null;
        },
        onChanged: (value) {
          selectedSkill = value.toString();
          _formData[key] = value;
        },
      ),
    );
  }

  void _submitForm() async {
    if (_image != null) {
      _uploadImage();
      if (_formKey.currentState?.validate() ?? false) {
        _formKey.currentState?.save();
        if (_isPrivacyPolicyChecked) {
          isLoading.value = true;
          try {
            await db
                .collection('users')
                .doc(AuthController().auth.currentUser!.uid)
                .update({
              'First name': firstName.text,
              'last name': lastName.text,
              'phone number': telNumber.text,
              'skill': selectedSkill,
              'experiance': yearsExperience.text,
              'imageUrl': _uploadUrl,
            }).then((_) {
              firstName.clear();
              lastName.clear();
              telNumber.clear();
              yearsExperience.clear();
              selectedSkill = 'Select Skill';
              Get.defaultDialog(
                  contentPadding: const EdgeInsets.all(25),
                  onConfirm: () {
                    print(_uploadUrl);
                    isLoading.value = false;
                    Get.offAll(() => const LandingScreen());
                  },
                  title: 'Profile updated successfully!',
                  content: const Text(
                      'Your account has been successfully updated to a contractor profile. You are now ready to offer your skills and services to users across Barbados.'));
            });
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error updating profile: $e')));
          }
        } else {
          Get.showSnackbar(const GetSnackBar(
            title: 'Privacy Policy',
            message: 'Please read and accept our privacy policy',
            duration: Duration(seconds: 3),
          ));
        }
      }
    } else {
      Get.showSnackbar(const GetSnackBar(
        title: 'Image',
        message: 'Please select a display image',
        duration: Duration(seconds: 3),
      ));
    }
  }
}
