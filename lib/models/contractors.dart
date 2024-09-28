class Contractor {
  final String name;
  final String email;
  final String skill;
  final String id;
  // final String phoneNumber;
  // final String address;
  // final String rating;

  Contractor(
      {required this.name,
      required this.email,
      required this.skill,
      required this.id
      // required this.phoneNumber,
      // required this.address,
      // required this.rating,
      });

  // Factory constructor with null-safety checks
  factory Contractor.fromMap(Map<String, dynamic> data) {
    return Contractor(
      name: data['name'] ?? 'Unknown', // Provide a default value if null
      email: data['email'] ?? 'No email', // Provide a default value if null
      skill: data['Skill'] ?? 'No skill', // Provide a default value if null
      id: data['id'] ?? 'No id',
      // phoneNumber: data['phoneNumber'] ?? 'No phone', // Handle null with a default
      // address: data['address'] ?? 'No address', // Handle null with a default
      // rating: data['rating'] ?? 'No rating', // Handle null with a default
    );
  }
}
