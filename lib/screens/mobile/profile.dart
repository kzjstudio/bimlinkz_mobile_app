import 'package:flutter/material.dart';
import 'package:bimlinkz_mobile_app/Controllers/user_profile_controller.dart';
import 'package:get/get.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  TextEditingController specialtyController = TextEditingController();
  var usercontroller = Get.find<
      UserProfileController>(); // Assuming UserController is previously defined and correctly configured with GetX.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileSection(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'About',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
                  ],
                ),
                Text(usercontroller.about.value.toString())
              ],
            ),
            const Divider(height: 32, thickness: 2),
            _buildPersonalInfoSection(),
            const Divider(height: 32, thickness: 2),
            _buildContactInfoSection(),
            const Divider(height: 32, thickness: 2),
            _buildResumeSection(),
            const Divider(
              height: 32,
              thickness: 2,
            ),
            _buildWorkExperienceSection(),
            const Divider(height: 32, thickness: 2),
            _buildSkillsSection(),
            const Divider(height: 32, thickness: 2),
            _buildEducationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {},
          child: CircleAvatar(
            radius: 60, // Larger profile image
            backgroundImage: NetworkImage(usercontroller.profileImageUrl ??
                'https://via.placeholder.com/150'),
            backgroundColor: Colors.grey[300],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          usercontroller.firstName.value,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey),
        ),
        const SizedBox(height: 5),
        Text(
          'Tap to change picture',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: const Text('Specialty'),
          subtitle: Text(
              usercontroller.specialty.value.isEmpty
                  ? 'Add Specialty'
                  : usercontroller.specialty.value,
              style: const TextStyle(color: Colors.black54)),
          trailing: const Icon(Icons.edit, color: Colors.blueGrey),
          onTap: () => _editSpecialty(),
        ),
      ],
    );
  }

  void _editSpecialty() {
    // Edit specialty implementation
  }

  void _editAbout() {
    // Edit about implementation
  }

  Widget _buildContactInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: const Text('Email Address'),
          subtitle: Text(usercontroller.email.value,
              style: const TextStyle(color: Colors.black54)),
          trailing: const Icon(Icons.lock_outline, color: Colors.grey),
        ),
        ListTile(
          title: const Text('Phone Number'),
          subtitle: Text(usercontroller.phoneNumber ?? 'Add Phone Number',
              style: const TextStyle(color: Colors.black54)),
          trailing: const Icon(Icons.edit, color: Colors.blueGrey),
          onTap: () => _editPhoneNumber(),
        ),
        ListTile(
          title: const Text('Address'),
          subtitle: Text(usercontroller.address ?? 'Add Address',
              style: const TextStyle(color: Colors.black54)),
          trailing: const Icon(Icons.edit, color: Colors.blueGrey),
          onTap: () => _editAddress(),
        ),
      ],
    );
  }

  void _editPhoneNumber() {
    // Edit phone number implementation
  }

  void _editAddress() {
    // Edit address implementation
  }

  Widget _buildResumeSection() {
    return ListTile(
      title: const Text('Resume'),
      subtitle: const Text('Upload or update your resume',
          style: TextStyle(color: Colors.black54)),
      trailing: ElevatedButton(
        onPressed: () {
          // Implement resume upload functionality
        },
        child: const Text('Upload'),
      ),
    );
  }

  Widget _buildWorkExperienceSection() {
    // Similar to previous widget implementations
    return Container();
  }

  Widget _buildSkillsSection() {
    // Similar to previous widget implementations
    return Container();
  }

  Widget _buildEducationSection() {
    // Similar to previous widget implementations
    return Container();
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return "";
    return text[0].toUpperCase() + text.substring(1);
  }
}
