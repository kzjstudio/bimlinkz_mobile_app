import 'package:flutter/material.dart';

class ContractorDetailScreen extends StatelessWidget {
  final Map<String, dynamic> contractor;

  const ContractorDetailScreen({Key? key, required this.contractor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${contractor['First_Name']} ${contractor['Last_Name']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(contractor['imageUrl'] ?? ''),
                  onBackgroundImageError: (_, __) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${contractor['First_Name']} ${contractor['Last_Name']}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Email: ${contractor['Email']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Phone: ${contractor['phone']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Experience: ${contractor['Years_Experience']} years',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Skill: ${contractor['Skill']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Reviews',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Add reviews list or reviews widget here
              // For example purposes, we just add a placeholder
              Container(
                height: 200,
                color: Colors.grey.shade200,
                child: const Center(child: Text('Reviews Placeholder')),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to chat screen or start chat with contractor
          // For now, we just show a snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Chat with contractor')),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
