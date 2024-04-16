import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum UserRole { freelancer, company, client }

class SignUpPage extends StatefulWidget {
  final UserRole? userRole;

  SignUpPage({Key? key, this.userRole}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int _currentStep = 0;
  UserRole? _selectedRole;
  String _roleDescription = '';
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final companyController = TextEditingController();
  final usernameController = TextEditingController();
  final parishController = TextEditingController();
  final streetController = TextEditingController();
  final buildingController = TextEditingController();
  String? selectedIndustry;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> skills = [
    'Web Development',
    'Mobile App Development',
    'Graphic Design',
    'Data Analysis',
    'SEO'
  ];
  List<String> industries = [
    'Technology',
    'Finance',
    'Healthcare',
    'Education',
    'Manufacturing',
    'Retail'
  ];
  var selectedSkills = [].obs;

  Map<UserRole, String> roleDescriptions = {
    UserRole.freelancer:
        "Freelancers provide services or work on projects for various clients without committing to a single employer.",
    UserRole.company:
        "Companies seek services from freelancers or may offer projects to individuals on a contractual basis.",
    UserRole.client:
        "Clients look for professionals to hire for specific tasks or projects in their personal or professional ventures."
  };

  bool _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return false; // Return false if validation fails
    }
    return true; // Return true if validation passes
  }

  void _showSkillsDialog() {
    Get.defaultDialog(
      title: 'Select your skills',
      content: SingleChildScrollView(
        child: ListBody(
          children: skills.map((skill) {
            return Obx(() => CheckboxListTile(
                  title: Text(skill),
                  value: selectedSkills.contains(skill),
                  onChanged: (bool? value) {
                    if (value == true) {
                      selectedSkills.add(skill);
                      print(selectedSkills);
                    } else {
                      selectedSkills.remove(skill);
                      print(selectedSkills);
                    }
                    ;
                  },
                ));
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Done'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.userRole != null) {
      _selectedRole = widget.userRole;
      _roleDescription = roleDescriptions[_selectedRole!]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Complete Your Profile'),
        ),
        body: Form(
          key: _formKey,
          child: Stepper(
            type: StepperType.vertical,
            currentStep: _currentStep,
            onStepContinue: _onStepContinue,
            onStepCancel: _onStepCancel,
            steps: _buildSteps(),
            controlsBuilder: (context, details) {
              return Container(
                margin: EdgeInsets.only(top: 50),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            onPressed: _onStepContinue, child: Text('Next'))),
                    const SizedBox(
                      width: 12,
                    ),
                    if (_currentStep != 0)
                      Expanded(
                          child: ElevatedButton(
                              onPressed: _onStepCancel, child: Text('Back')))
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: Text("Select Role"),
        content: Column(
          children: [
            DropdownButton<UserRole>(
              hint: Text('Select a role'),
              value: _selectedRole,
              onChanged: (UserRole? newValue) {
                setState(() {
                  _selectedRole = newValue;
                  _roleDescription = roleDescriptions[newValue!]!;
                });
              },
              items: UserRole.values.map((UserRole role) {
                return DropdownMenuItem<UserRole>(
                  value: role,
                  child: Text(role.toString().split('.').last),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Text(_roleDescription),
          ],
        ),
        isActive: _currentStep == 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text("Role-Specific Information"),
        content: _buildDetailedInformationForm(),
        isActive: _currentStep == 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      // New Step: Detailed Information
      Step(
        title: const Text("Detailed Information"),
        content: _buildRoleSpecificForm(),
        isActive: _currentStep == 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
    ];
  }

  Widget _buildRoleSpecificForm() {
    // Implement the role-specific form as before
    return const Center(
      child: Text('Form'),
    );
  }

  Widget _buildDetailedInformationForm() {
    switch (_selectedRole) {
      case UserRole.freelancer:
        return _buildFreelancerForm();
      case UserRole.company:
        return _buildCompanyForm();
      case UserRole.client:
        return _buildClientForm();
      default:
        return const Text("No role selected");
    }
  }

  Widget _buildFreelancerForm() {
    return Column(
      children: [
        ListTile(
          title: const Text('Select Your Top Skills'),
          onTap: () => _showSkillsDialog(),
        ),
        // Display selected skills
        Obx(
          () => Wrap(
            spacing: 10.0,
            children: List.generate(selectedSkills.length,
                (index) => Chip(label: Text(selectedSkills[index]))),
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Starting from (\$)'),
          validator: (value) =>
              value!.isEmpty ? 'Please enter your rate' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Professional Summary'),
          validator: (value) =>
              value!.isEmpty ? 'Please enter a summary' : null,
        ),
      ],
    );
  }

  Widget _buildCompanyForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: companyController,
          decoration: const InputDecoration(labelText: 'Company Name'),
          validator: (value) =>
              value!.isEmpty ? 'Please enter your company name' : null,
        ),
        TextFormField(
          controller: usernameController,
          decoration: const InputDecoration(labelText: 'Username'),
          validator: (value) =>
              value!.isEmpty ? 'Please enter a username' : null,
        ),
        DropdownButtonFormField<String>(
          value: selectedIndustry,
          decoration: const InputDecoration(labelText: 'Industry'),
          onChanged: (String? newValue) {
            setState(() {
              selectedIndustry = newValue;
            });
          },
          items: industries.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          validator: (value) =>
              value == null ? 'Please select an industry' : null,
        ),
        TextFormField(
          controller: parishController,
          decoration: const InputDecoration(labelText: 'Parish'),
          validator: (value) =>
              value!.isEmpty ? 'Please enter the parish' : null,
        ),
        TextFormField(
          controller: streetController,
          decoration: const InputDecoration(labelText: 'Street'),
          validator: (value) =>
              value!.isEmpty ? 'Please enter the street' : null,
        ),
        TextFormField(
          controller: buildingController,
          decoration: const InputDecoration(labelText: 'Building'),
          validator: (value) =>
              value!.isEmpty ? 'Please enter the building number/name' : null,
        ),
      ],
    );
  }

  Widget _buildClientForm() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Areas of Interest'),
          validator: (value) =>
              value!.isEmpty ? 'Please specify your interests' : null,
        ),
        TextFormField(
          decoration:
              const InputDecoration(labelText: 'Preferred Contact Method'),
          validator: (value) =>
              value!.isEmpty ? 'Please enter a contact method' : null,
        ),
      ],
    );
  }

  void _onStepContinue() {
    if (_currentStep == 0) {
      // Check if a role is selected on the first step.
      if (_selectedRole == null) {
        Get.showSnackbar(const GetSnackBar(
          title: 'Select a Role',
          message: 'Please select a user role before continuing.',
          duration: Duration(seconds: 3),
        ));
        return;
      }
      // If a role is selected, proceed to the next step.
      setState(() => _currentStep += 1);
    } else if (_currentStep == 1 && _selectedRole == UserRole.freelancer) {
      // Check if skills are selected on the second step (specific to Freelancers).
      if (selectedSkills.isEmpty) {
        Get.showSnackbar(const GetSnackBar(
          title: 'Skills Required',
          message: 'Please select at least one skill set.',
          duration: Duration(seconds: 3),
        ));
        return;
      }
      // Perform form validation for current step before proceeding.
      if (_formKey.currentState!.validate()) {
        setState(() => _currentStep += 1);
      }
    } else {
      // Handle any additional steps similarly...
      final isLastStep = _currentStep == _buildSteps().length - 1;
      if (isLastStep) {
        if (_formKey.currentState!.validate()) {
          // All validations are done, proceed to send data to the server
          print('Form is valid, send data to server');
        }
      } else {
        // Proceed to next step if not the last step and the form is valid.
        if (_formKey.currentState!.validate()) {
          setState(() => _currentStep += 1);
        }
      }
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }
}
