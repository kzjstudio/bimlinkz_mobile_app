import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContractorForm extends StatefulWidget {
  @override
  _ContractorFormState createState() => _ContractorFormState();
}

class _ContractorFormState extends State<ContractorForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  bool _isPrivacyPolicyChecked = false;

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
                _buildTextField('First Name', 'first Name'),
                _buildTextField('Last Name', 'Last Name'),
                _buildTextField('Phone', 'phone',
                    keyboardType: TextInputType.phone),
                _buildTextField('Email', 'email',
                    keyboardType: TextInputType.emailAddress),
                _buildTextField('Job Title/Occupation', 'jobTitle'),
                _buildTextField('Skills/Expertise', 'skills', maxLines: 3),
                _buildTextField('Years of Experience', 'experience',
                    keyboardType: TextInputType.number),
                _buildTextField('Work History', 'workHistory', maxLines: 3),
                _buildTextField('Ratings and Reviews', 'ratings', maxLines: 3),
                const SizedBox(height: 20),
                SizedBox(height: 20),
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
                              title: Text('Privacy Policy'),
                              content: SingleChildScrollView(
                                child: Text(
                                  'Your privacy policy content goes here. '
                                  'Make sure to include all necessary information regarding user data and privacy.',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(
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
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String key,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
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
          _formData[key] = value;
        },
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        await FirebaseFirestore.instance
            .collection('contractors')
            .add(_formData);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating profile: $e')));
      }
    }
  }
}
