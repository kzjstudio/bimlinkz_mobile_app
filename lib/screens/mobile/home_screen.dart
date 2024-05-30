import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/Controllers/user_profile_controller.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/contractor_details_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/jobpost_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/see_all_categories_screen.dart';
import 'package:bimlinkz_mobile_app/widgets/category_card.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/popular_selection_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final AuthController c = Get.find();
final UserProfileController usercontroller = Get.find();

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> _categoriesFuture;
  late Future<List<Map<String, dynamic>>> _recentContractorsFuture;
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _filteredCategories = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _fetchCategories();
    _recentContractorsFuture = _fetchRecentContractors();
    _searchController.addListener(_onSearchChanged);
  }

  Future<List<Map<String, dynamic>>> _fetchCategories() async {
    var collection =
        await FirebaseFirestore.instance.collection('categories').get();
    var categories = collection.docs.map((doc) => doc.data()).toList();
    setState(() {
      _categories = categories;
      _filteredCategories = categories;
    });
    return categories;
  }

  Future<List<Map<String, dynamic>>> _fetchRecentContractors() async {
    DateTime fourWeeksAgo = DateTime.now().subtract(const Duration(days: 28));
    var collection = await FirebaseFirestore.instance
        .collection('users')
        .where('Became_Contractor_Date', isGreaterThanOrEqualTo: fourWeeksAgo)
        .get();
    var recentContractors = collection.docs.map((doc) => doc.data()).toList();
    return recentContractors;
  }

  void _onSearchChanged() {
    setState(() {
      _filteredCategories = _categories
          .where((category) => category['id']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hi ${UserProfileController.instance.userName.value}!'),
              ],
            ),
          ),
          body: FutureBuilder<List<Map<String, dynamic>>>(
            future: _categoriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading categories'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No categories found'));
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
                            hintText: 'Search...',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                              },
                            ),
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _searchController.text.isNotEmpty
                            ? _buildSuggestions()
                            : _buildPopularSearches(),
                        const SizedBox(height: 30),
                        const Text(
                          'Contractors who Recently joined',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildFeaturedArea(),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => const PostJobPage(),
                  transition: Transition.downToUp,
                  duration: const Duration(milliseconds: 200));
            },
            child: const Icon(Icons.post_add_outlined),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    if (_filteredCategories.isEmpty) {
      return const Center(
        child: Text('No categories available at the moment'),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _filteredCategories.length,
      itemBuilder: (context, index) {
        final category = _filteredCategories[index];
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

  Widget _buildPopularSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Popular searches',
              style: TextStyle(
                fontSize: 18,
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
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final data = _categories[index];
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

  Widget _buildFeaturedArea() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _recentContractorsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading recent contractors'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No recent contractors found'));
        } else {
          final recentContractors = snapshot.data!;
          return SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recentContractors.length,
              itemBuilder: (context, index) {
                final contractor = recentContractors[index];
                return InkWell(
                  onTap: () {
                    Get.to(
                        transition: Transition.rightToLeft,
                        () => ContractorDetailScreen(contractor: contractor));
                  },
                  child: Card(
                    color: const Color.fromARGB(255, 239, 239, 239),
                    margin: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: Image.network(
                                  contractor['imageUrl'] ?? '',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 150,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey,
                                      child: const Center(
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    contractor['First_Name'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    contractor['Last_Name'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '${contractor['Years_Experience']} years as a ${contractor['Skill']}' ??
                                    '',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
