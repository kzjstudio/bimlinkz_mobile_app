import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/Controllers/user_profile_controller.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/popular_selection_screen.dart';
import 'package:bimlinkz_mobile_app/widgets/home%20screen/featured_trades_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bimlinkz_mobile_app/Controllers/data_controller.dart';
import '../../widgets/home screen/freelancers_who_recently_joined.dart';

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
          body: RefreshIndicator(
            onRefresh: _initializeData,
            child: Obx(() {
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
                            : FeaturedTradesSection(),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recently joined',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Get.to(() => const SeeAllCategoriesScreen(),
                                //     transition: Transition.rightToLeft);
                              },
                              child: const Text('See all'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FreelancersWhoRecentlyJoined(),
                      ],
                    ),
                  ),
                );
              }
            }),
          ),
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
}
