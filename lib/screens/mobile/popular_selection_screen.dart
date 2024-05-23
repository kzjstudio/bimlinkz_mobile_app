import 'package:bimlinkz_mobile_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PopularSelectionScreen extends StatelessWidget {
  const PopularSelectionScreen({super.key, required this.id});

  final String id;

  Future<List<Map<String, dynamic>>> getData() async {
    List<Map<String, dynamic>> dataList = [];
    var data = await FirebaseFirestore.instance
        .collection('users')
        .where('skill', isEqualTo: id)
        .get();
    for (var element in data.docs) {
      dataList.add(element.data());
    }
    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(id.toUpperCase()),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No contractors found'));
          } else {
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final contractor = items[index];
                final String? imageUrl = contractor['imageUrl'];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      '${contractor["First name"]} ${contractor["last name"]}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${contractor["email"]}'),
                        Text('Phone: ${contractor["phone number"]}'),
                        Text('Experience: ${contractor["experiance"]} years'),
                      ],
                    ),
                    leading: Container(
                      width: 80, // Width of the leading image
                      height: double.infinity, // Fill the height of the card
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        image: imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: imageUrl == null
                          ? Icon(Icons.person, size: 40, color: Colors.white)
                          : null,
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
