import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/models/contractors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/jobs.dart';

class SavedPage extends StatefulWidget {
  @override
  _ContractorsPageState createState() => _ContractorsPageState();
}

class _ContractorsPageState extends State<SavedPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch saved contractors from Firestore
  Future<List<Contractor>> _fetchSavedContractors() async {
    final userId = AuthController.instance.auth.currentUser!.uid;
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('savedContractors') // Assuming saved contractors are here
        .get();
    return snapshot.docs
        .map((doc) => Contractor.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Fetch saved jobs from Firestore
  Future<List<Job>> _fetchSavedJobs() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('savedJobs') // Assuming saved jobs are here
        .get();
    return snapshot.docs.map((doc) => Job.fromFirestore(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Saved Contractors & Jobs')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Saved Contractors
            const Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Saved Contractors',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder<List<Contractor>>(
              future: _fetchSavedContractors(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  print(snapshot.data);
                  return Center(child: Text('No saved contractors found.'));
                } else {
                  List<Contractor> contractors = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true, // To avoid scrolling conflict
                    physics:
                        NeverScrollableScrollPhysics(), // Disable scroll for the list
                    itemCount: contractors.length,
                    itemBuilder: (context, index) {
                      Contractor contractor = contractors[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(contractor.name),
                          subtitle: Text('Skill: ${contractor.skill}'),
                        ),
                      );
                    },
                  );
                }
              },
            ),

            // Section 2: Saved Jobs
            const Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Saved Jobs',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            FutureBuilder<List<Job>>(
              future: _fetchSavedJobs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No saved jobs found.'));
                } else {
                  List<Job> jobs = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true, // To avoid scrolling conflict
                    physics:
                        NeverScrollableScrollPhysics(), // Disable scroll for the list
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      Job job = jobs[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(job.title),
                          subtitle: Text('Budget: '),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
