import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/Controllers/user_profile_controller.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/contractor_details_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/jobpost_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/popular_selection_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/see_all_categories_screen.dart';
import 'package:bimlinkz_mobile_app/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bimlinkz_mobile_app/Controllers/data_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final AuthController c = Get.find();
final UserProfileController usercontroller = Get.find();

class _HomeScreenState extends State<HomeScreen> {
  final DataController dataController = Get.find();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _initializeData() async {
    // No need to await this, let the UI render while fetching
    dataController.fetchAndCacheData(context);
  }

  void _onSearchChanged() {
    // Update categories based on search input
    dataController.categories.value = dataController.categories
        .where((category) => category['id']
            .toString()
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Find trades men for your needs'),
              ],
            ),
          ),
          body: Obx(() {
            if (dataController.dataFetched.isFalse) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search the type of work you want done',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          ),
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _searchController.text.isNotEmpty
                          ? _buildSuggestions()
                          : _featuredTradesSection(),
                      const SizedBox(height: 30),
                      const Text(
                        'Contractors who Recently joined',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _recommendedTradesPersons(),
                    ],
                  ),
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    if (dataController.categories.isEmpty) {
      return const Center(
        child: Text('No categories available at the moment'),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: dataController.categories.length,
      itemBuilder: (context, index) {
        final category = dataController.categories[index];
        return ListTile(
          title: Text(category['id']),
          onTap: () {
            Get.to(() => PopularSelectionScreen(id: category['id']),
                transition: Transition.rightToLeft);
            _searchController.clear();
          },
        );
      },
    );
  }

  Widget _featuredTradesSection() {
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

  Widget _recommendedTradesPersons() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 20.0, // Horizontal spacing between items
          runSpacing: 2.0, // Vertical spacing between items
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
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2 -
                      36, // 2 items per row
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              contractor['imageUrl'] ?? '',
                              fit: BoxFit.cover,
                              height: 120, // Adjust height based on design
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 120,
                                  color: Colors.grey,
                                  child: const Center(
                                    child: Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
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
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.message),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.bookmark),
                              ),
                            ],
                          ),
                        ],
                      ),
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
