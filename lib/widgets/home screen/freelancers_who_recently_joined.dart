import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/Controllers/data_controller.dart';
import 'package:bimlinkz_mobile_app/models/contractors.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/chat_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/contractor_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FreelancersWhoRecentlyJoined extends StatelessWidget {
  final DataController dataController = Get.find();

  void saveFreeLancer(Map<String, dynamic> contractor) async {
    try {
      final userId = AuthController.instance.auth.currentUser!.uid;
      if (userId == null) {
        Get.snackbar('Error', 'You must be logged in to save a freelancer');
        return;
      }
      final userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('savedContractors')
          .doc(contractor['id']);

      final userSnapShot = await userDocRef.get();
      List<dynamic> savedContractors =
          userSnapShot.data()?['savedContractors'] ?? [];

      bool alreadySaved = savedContractors
          .any((saved) => saved['contractorId'] == contractor['id']);
      if (alreadySaved) {
        Get.snackbar(
            "Already Saved", "You have already saved this contractor.");
        return;
      }
      await userDocRef.set({
        'contractorId': contractor['id'], // Store contractor's unique ID
        'name':
            '${contractor['First_Name']} ${contractor['Last_Name']}', // Store contractor's name
        'Skill': contractor['Skill'] // Store contractor's skill (optional)
      });

      Get.snackbar("Success", "Contractor saved to your profile.");
    } catch (e) {
      print("Error saving contractor: $e");
      Get.snackbar("Error", "Failed to save contractor. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: List.generate(
            dataController.recentContractors.length,
            (index) {
              final contractor = dataController.recentContractors[index];
              return InkWell(
                onTap: () {
                  Get.to(
                    transition: Transition.rightToLeft,
                    () => ContractorDetailScreen(contractor: contractor),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Contractor Image on the Left
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            contractor['imageUrl'] ?? '',
                            fit: BoxFit.cover,
                            height: 80, // Adjust height
                            width: 80, // Adjust width
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 80,
                                width: 80,
                                color: Colors.grey,
                                child: const Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                            width: 12), // Spacing between image and details

                        // Contractor Information on the Right
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${contractor['First_Name'] ?? ''} ${contractor['Last_Name'] ?? ''}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                contractor['Skill'] ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),

                              // Message and Bookmark Buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Get.to(() => ChatScreen(
                                            contractorFirstName:
                                                contractor['First_Name'],
                                            contractorLastName:
                                                contractor["Last_Name"],
                                            contractorId: contractor['id']));
                                      },
                                      icon: Icon(Icons.message)),
                                  IconButton(
                                    onPressed: () {
                                      saveFreeLancer(contractor);
                                    },
                                    icon: const Icon(Icons.bookmark),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
