import 'package:bimlinkz_mobile_app/Controllers/data_controller.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/contractor_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FreelancersWhoRecentlyJoined extends StatelessWidget {
  final DataController dataController = Get.find();

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
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      // Handle message action
                                    },
                                    icon: const Icon(Icons.message),
                                    label: const Text('Message'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Handle bookmark action
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
