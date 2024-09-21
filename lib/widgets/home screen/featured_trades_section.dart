import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/data_controller.dart';
import '../../screens/mobile/see_all_categories_screen.dart';
import '../category_card.dart';

class FeaturedTradesSection extends StatelessWidget {
  final DataController dataController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Featured Trades',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => const SeeAllCategoriesScreen(),
                    transition: Transition.rightToLeft);
              },
              child: const Text('See all'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dataController.categories.length,
            itemBuilder: (context, index) {
              final data = dataController.categories[index];
              return CategoryCard(
                catText: data["id"],
                imageUrl: data['imageUrl'],
              );
            },
          ),
        ),
      ],
    );
  }
}
