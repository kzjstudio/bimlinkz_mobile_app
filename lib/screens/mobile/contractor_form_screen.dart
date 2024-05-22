import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/landing_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController telNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController yearsExperience = TextEditingController();

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
          title: Text('Become a Contractor'),
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
                const SizedBox(height: 20),
                _buildTextField('First Name', 'first Name', firstName),
                _buildTextField('Last Name', 'Last Name', lastName),
                _buildTextField('Phone', 'phone', telNumber,
                    keyboardType: TextInputType.phone),
                _buildDropdown('Skill', selectedSkill, jobCategories),
                _buildTextField(
                    'Years of Experience', 'experience', yearsExperience,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 20),
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
                Obx(
                  () => ElevatedButton(
                    onPressed: isLoading.isFalse ? () => _submitForm() : null,
                    child: const Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
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
            'experiance': yearsExperience.text
          }).then((_) {
            firstName.clear();
            lastName.clear();
            telNumber.clear();
            yearsExperience.clear();
            selectedSkill = 'Select Skill';
            Get.defaultDialog(
                contentPadding: const EdgeInsets.all(25),
                onConfirm: () => Get.offAll(() => LandingScreen()),
                title: 'Profile updated successfully!',
                content: const Text(
                    'Your account has been successfully updated to a contractor profile. You are now ready to offer your skills and services to users across Barbados.'));
            isLoading.value = false;
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
  }
}
