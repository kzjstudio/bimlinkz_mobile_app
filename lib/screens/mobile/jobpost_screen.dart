import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class PostJobPage extends StatefulWidget {
  @override
  _PostJobPageState createState() => _PostJobPageState();
}

class _PostJobPageState extends State<PostJobPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final db = FirebaseFirestore.instance;
  SfRangeValues _values = SfRangeValues(0.floor(), 100.floor());

  var _categories = <String>[];
  String? _selectedCategory;
  final List<String> _parishes = [
    'Christ Church',
    'Saint Andrew',
    'Saint George',
    'Saint James',
    'Saint John',
    'Saint Joseph',
    'Saint Lucy',
    'Saint Michael',
    'Saint Peter',
    'Saint Philip',
    'Saint Thomas'
  ];
  String? selectedParish;

  @override
  void initState() {
    // TODO: implement initState
    getJobCategories();
    super.initState();
  }

  void getJobCategories() async {
    await db.collection("categories").get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        setState(() {
          _categories.add(docSnapshot.data()['id'].toString());
          print(_categories);
        });
      }
    });
  }

  List<String> _skills = [];
  double? _budget;
  DateTime? _deadline;
  bool _isPublic = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a Job')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Post a job for freelancers, handymen and contractors to see',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                    labelText:
                        'Job Title: Eg. Logo Design, Home Plumbing repair',
                    border: OutlineInputBorder()),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a job title' : null,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    labelText:
                        'Job Description: EG. a breif description of the job.',
                    border: OutlineInputBorder()),
                maxLines: 3,
                validator: (value) => value!.isEmpty
                    ? 'Please provide a detailed description'
                    : null,
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                    labelText: 'Job Category', border: OutlineInputBorder()),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<String>(
                value: selectedParish,
                decoration: const InputDecoration(
                    labelText: 'Parish', border: OutlineInputBorder()),
                onChanged: (newValue) {
                  setState(() {
                    selectedParish = newValue!;
                  });
                },
                items: _parishes.map((parish) {
                  return DropdownMenuItem(
                    value: parish,
                    child: Text(parish),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please select a parish' : null,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'From \$${_values.start.toString()} BBD to \$${_values.end.toString()} BBD',
                style: TextStyle(fontSize: 18),
              ),
              SfRangeSlider(
                min: 0.0,
                max: 300,
                values: _values,
                stepSize: 10,
                interval: 50,
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                minorTicksPerInterval: 2,
                onChanged: (value) => setState(() {
                  _values = value;
                  print(_values);
                }),
              ),
              const SizedBox(
                height: 20,
              ),

              // Additional fields...
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Logic to handle form submission
                  }
                },
                child: Text('Post Job'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
