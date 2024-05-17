import 'package:bimlinkz_mobile_app/models/contractors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContractorsPage extends StatefulWidget {
  @override
  _ContractorsPageState createState() => _ContractorsPageState();
}

class _ContractorsPageState extends State<ContractorsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Contractor>> _fetchContractors() async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: "freelancer")
        .get();
    return snapshot.docs
        .map((doc) => Contractor.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contractors you have worked with')),
      body: FutureBuilder<List<Contractor>>(
        future: _fetchContractors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No contractors found.'));
          } else {
            List<Contractor> contractors = snapshot.data!;
            return ListView.builder(
              itemCount: contractors.length,
              itemBuilder: (context, index) {
                Contractor contractor = contractors[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(contractor.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${contractor.email}'),
                        // Text('Phone: ${contractor.phoneNumber}'),
                        // Text('Address: ${contractor.address}'),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber),
                            // Text('${contractor.rating}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
