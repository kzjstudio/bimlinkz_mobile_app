import 'package:bimlinkz_mobile_app/screens/mobile/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:bimlinkz_mobile_app/Controllers/user_profile_controller.dart';
import 'package:get/get.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late UserProfile userProfile = UserProfile(
    email: 'john.doe@example.com', // Placeholder for user email
    // Initialize other fields as needed
  );

  TextEditingController specialtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildProfilePictureSection(),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 6,
                ),
                Text('i am a really good welder, capable of many things.')
              ],
            ),
            SizedBox(
              height: 18,
            ),
            _buildPersonalInfoSection(),
            _buildContactInfoSection(),
            _buildResumeSection(),
            _buildWorkExperienceSection(),
            _buildSkillsSection(),
            _buildEducationSection(),
          ],
        ),
      ),
    );
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return "";
    return text[0].toUpperCase() + text.substring(1);
  }

  Widget _buildProfilePictureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {},
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(userProfile.profileImageUrl ??
                'https://via.placeholder.com/150'),
            backgroundColor: Colors.grey[200],
          ),
        ),
        const SizedBox(
          height: 18,
        ),
        Text(c.userName.value),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('Specialty'),
          subtitle: Text(
              capitalizeFirstLetter(userProfile.specialty.toString()) ??
                  'Add Specialty'),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Get.defaultDialog(
                  onConfirm: () {
                    setState(() {
                      userProfile.specialty = specialtyController.text;
                    });

                    Get.close(0);
                  },
                  onCancel: () {
                    Get.close(0);
                  },
                  title: 'Enter you special skill',
                  content: Column(
                    children: [
                      TextFormField(
                        controller: specialtyController,
                        decoration: InputDecoration(
                          labelText: 'specialty',
                          hintText: 'Enter your specialty',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your specialty';
                          }
                          return null;
                        },
                      ),
                    ],
                  ));
            },
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('About'),
          subtitle: Text(userProfile.about ?? 'Add about information'),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Implement about update functionality
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('Email Address'),
          subtitle: Text(userProfile.email),
          trailing: Icon(Icons.lock_outline), // Email is not editable
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('Phone Number'),
          subtitle: Text(userProfile.phoneNumber ?? 'Add Phone Number'),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Implement phone number update functionality
            },
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('Address'),
          subtitle: Text(userProfile.address ?? 'Add Address'),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Implement address update functionality
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResumeSection() {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      title: Text('Resume'),
      subtitle: Text('Upload or update your resume'),
      trailing: ElevatedButton(
        onPressed: () {
          // Implement resume upload functionality
        },
        child: Text('Upload'),
      ),
    );
  }

  Widget _buildWorkExperienceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var experience in userProfile.workExperiences)
          ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(experience.position),
            subtitle: Text('${experience.company}, ${experience.duration}'),
          ),
        ElevatedButton(
          onPressed: () {
            // Implement add work experience functionality
          },
          child: Text('Add Experience'),
        ),
      ],
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: userProfile.skills
              .map((skill) => Chip(label: Text(skill)))
              .toList(),
        ),
        ElevatedButton(
          onPressed: () {
            // Implement add skills functionality
          },
          child: Text('Add Skills'),
        ),
      ],
    );
  }

  Widget _buildEducationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var edu in userProfile.education)
          ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(edu.schoolName),
            subtitle: Text('Attended: ${edu.duration}'),
          ),
        ElevatedButton(
          onPressed: () {
            // Implement add education functionality
          },
          child: Text('Add Education'),
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
