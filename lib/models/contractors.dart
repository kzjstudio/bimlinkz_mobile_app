class Contractor {
  final String name;
  final String email;
  // final String phoneNumber;
  // final String address;
  // final String rating;

  Contractor({
    required this.name,
    required this.email,
    // required this.phoneNumber,
    // required this.address,
    // required this.rating,
  });

  factory Contractor.fromMap(Map<String, dynamic> data) {
    return Contractor(
      name: data['name'],
      email: data['email'],
      // phoneNumber: data['phoneNumber'],
      // address: data['address'],
      // rating: data['rating'],
    );
  }
}
