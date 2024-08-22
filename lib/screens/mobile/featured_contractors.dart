import 'package:flutter/material.dart';

class FeaturedContractors extends StatelessWidget {
  final List<Contractor> contractors = [
    Contractor('John Doe', 'Electrician', 'images/contractor1.png'),
    Contractor('Jane Smith', 'Plumber', 'images/contractor2.png'),
    Contractor('Sam Brown', 'Carpenter', 'images/contractor3.png'),
    Contractor('Lisa White', 'Painter', 'images/contractor4.png'),
    Contractor('Mike Green', 'Roofer', 'images/contractor5.png'),
    Contractor('Susan Blue', 'Landscaper', 'images/contractor6.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 columns
        childAspectRatio: 0.75, // Adjust aspect ratio as needed
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: contractors.length,
      itemBuilder: (context, index) {
        return ContractorCard(contractor: contractors[index]);
      },
    );
  }
}

class Contractor {
  final String name;
  final String trade;
  final String imageUrl;

  Contractor(this.name, this.trade, this.imageUrl);
}

class ContractorCard extends StatelessWidget {
  final Contractor contractor;

  const ContractorCard({required this.contractor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            contractor.imageUrl,
            height: 80, // Adjust image height as needed
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Text(
            contractor.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            contractor.trade,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle save action
                },
                child: const Text('Save'),
              ),
              OutlinedButton(
                onPressed: () {
                  // Handle message action
                },
                child: const Text('Message'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
